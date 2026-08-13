/**
 * Permission Gate Extension
 *
 * Policy: the agent may freely delete things that are regenerable
 * (node_modules, lockfiles, build output) or files it created itself this
 * session. Deleting anything pre-existing requires confirmation, and truly
 * dangerous operations are hard-denied.
 *
 * Allow (silent):   rm of regenerable paths or AI-created files
 * Ask:              rm of anything else, chmod/chown, ssh, docker, kill,
 *                   pkill, systemctl, service, mv to system paths
 * Deny (never run): sudo, dd to device, mkfs, shutdown/reboot, fork bombs,
 *                   git push/commit/reset --hard/clean -f (user owns git),
 *                   rm -rf of system paths
 */

import { existsSync } from "node:fs";
import { resolve } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const DENY: Array<{ pattern: RegExp; label: string }> = [
	{ pattern: /\bsudo\b/i, label: "sudo" },
	{ pattern: /\bdd\b.*\bof=\/dev/i, label: "dd to device" },
	{ pattern: /\bmkfs\b/i, label: "mkfs" },
	{ pattern: /\b(shutdown|reboot|poweroff|halt)\b/i, label: "shutdown/reboot" },
	{ pattern: /:\(\)\s*\{\s*:\|:&\s*\}\s*;:/, label: "fork bomb" },
	{ pattern: /\bgit\s+push\b/i, label: "git push (user owns git)" },
	{ pattern: /\bgit\s+commit\b/i, label: "git commit (user owns git)" },
	{ pattern: /\bgit\s+reset\s+--hard\b/i, label: "git reset --hard" },
	{ pattern: /\bgit\s+clean\s+-[a-zA-Z]*f/i, label: "git clean -f" },
];

const ASK: Array<{ pattern: RegExp; label: string }> = [
	// Adding a dependency is a supply-chain decision — always confirm.
	// Plain `pnpm install` (no package args) just regenerates node_modules and is allowed.
	{ pattern: /\b(pnpm|npm|yarn|bun)\s+add\b/i, label: "dependency add" },
	{ pattern: /\b(npm|pnpm|yarn|bun)\s+(install|i)\s+(?!-|--)\S/i, label: "dependency install" },
	{ pattern: /\b(chmod|chown)\b/i, label: "chmod/chown" },
	{ pattern: /\bssh\b/i, label: "ssh" },
	{ pattern: /\bdocker\b/i, label: "docker" },
	{ pattern: /\b(kill|pkill)\b/i, label: "kill/pkill" },
	{ pattern: /\b(systemctl|service)\b/i, label: "systemctl/service" },
	{ pattern: /\bmv\b.*\s(\/etc|\/usr|\/bin|\/sbin|\/var)\b/i, label: "mv to system path" },
];

// Paths that can always be regenerated — safe to delete without asking.
const REGENERABLE =
	/(^|\/)(node_modules|dist|build|out|coverage|\.next|\.nuxt|\.turbo|\.cache|\.parcel-cache|\.svelte-kit|__pycache__|\.pytest_cache|\.venv|target)(\/|$)|(^|\/)(pnpm-lock\.yaml|package-lock\.json|yarn\.lock|bun\.lockb?)$/;

const SYSTEM_PATH = /^\/(etc|usr|bin|sbin|var|boot|sys|proc|dev)(\/|$)/;

/** Extract the target paths from an rm command (strips flags and command name). */
function rmTargets(command: string, cwd: string): string[] {
	const match = command.match(/^\s*rm\s+(.+)$/s);
	if (!match) return [];
	return match[1]
		.split(/\s+/)
		.filter((t) => t && !t.startsWith("-"))
		.map((t) => resolve(cwd, t.replace(/["']/g, "")));
}

export default function (pi: ExtensionAPI) {
	// Files the agent created this session — it may delete its own work.
	const agentCreated = new Set<string>();

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName === "write") {
			const path = (event.input as { path?: string }).path;
			if (path) {
				const abs = resolve(ctx.cwd, path);
				if (!existsSync(abs)) agentCreated.add(abs);
			}
			return undefined;
		}

		if (event.toolName !== "bash") return undefined;

		const command = (event.input as { command?: string }).command ?? "";

		for (const { pattern, label } of DENY) {
			if (pattern.test(command)) {
				ctx.ui.notify(`⛔ Blocked: ${label}`, "warning");
				return {
					block: true,
					reason: `Command blocked by permission gate: "${label}" is hard-denied. The user performs git commits/pushes and destructive operations themselves. Do not attempt to work around this.`,
				};
			}
		}

		if (/\brm\b/.test(command)) {
			const targets = rmTargets(command, ctx.cwd);

			if (targets.some((t) => SYSTEM_PATH.test(t))) {
				ctx.ui.notify("⛔ Blocked: rm targeting system path", "warning");
				return { block: true, reason: "Blocked: rm targeting a system path is hard-denied." };
			}

			const needsConfirm = targets.filter((t) => !REGENERABLE.test(t) && !agentCreated.has(t));

			if (needsConfirm.length > 0) {
				if (!ctx.hasUI) {
					return { block: true, reason: "rm of pre-existing files requires confirmation but no UI is available." };
				}
				const choice = await ctx.ui.select(
					`⚠️ Delete pre-existing file(s)?\n\n${needsConfirm.map((t) => `  ${t}`).join("\n")}\n\nAllow?`,
					["Yes", "No"],
				);
				if (choice !== "Yes") {
					return { block: true, reason: "Blocked by user (rm of pre-existing files)" };
				}
			}
			return undefined;
		}

		for (const { pattern, label } of ASK) {
			if (pattern.test(command)) {
				if (!ctx.hasUI) {
					return { block: true, reason: `"${label}" requires confirmation but no UI is available.` };
				}
				const choice = await ctx.ui.select(`⚠️ Risky command (${label}):\n\n  ${command}\n\nAllow?`, [
					"Yes",
					"No",
				]);
				if (choice !== "Yes") {
					return { block: true, reason: `Blocked by user (${label})` };
				}
				break;
			}
		}

		return undefined;
	});
}
