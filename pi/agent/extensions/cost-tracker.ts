/**
 * Cost Tracker Extension
 *
 * Accumulates token usage and cost per model across the session and exposes
 * a /cost command with a breakdown. Notifies the session total on shutdown.
 *
 * Note: subagents run as separate pi processes, so this tracks the current
 * process only — subagent spend appears in their own sessions.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

interface ModelUsage {
	input: number;
	output: number;
	cacheRead: number;
	cost: number;
	requests: number;
}

function fmt(n: number): string {
	return n >= 1_000_000 ? `${(n / 1_000_000).toFixed(1)}M` : n >= 1_000 ? `${(n / 1_000).toFixed(1)}k` : String(n);
}

export default function (pi: ExtensionAPI) {
	const byModel = new Map<string, ModelUsage>();

	pi.on("message_end", async (event) => {
		const msg = event.message as {
			role?: string;
			model?: string;
			provider?: string;
			usage?: {
				input?: number;
				output?: number;
				cacheRead?: number;
				cost?: { total?: number };
			};
		};
		if (msg.role !== "assistant" || !msg.usage) return;

		const key = msg.model ?? "unknown";
		const entry = byModel.get(key) ?? { input: 0, output: 0, cacheRead: 0, cost: 0, requests: 0 };
		entry.input += msg.usage.input ?? 0;
		entry.output += msg.usage.output ?? 0;
		entry.cacheRead += msg.usage.cacheRead ?? 0;
		entry.cost += msg.usage.cost?.total ?? 0;
		entry.requests += 1;
		byModel.set(key, entry);
	});

	function report(): string {
		if (byModel.size === 0) return "No usage recorded yet.";
		const lines = ["Model".padEnd(32) + "Reqs   In       Out      Cache    Cost"];
		let total = 0;
		for (const [model, u] of [...byModel.entries()].sort((a, b) => b[1].cost - a[1].cost)) {
			total += u.cost;
			lines.push(
				model.padEnd(32) +
					`${String(u.requests).padEnd(7)}${fmt(u.input).padEnd(9)}${fmt(u.output).padEnd(9)}${fmt(u.cacheRead).padEnd(9)}$${u.cost.toFixed(4)}`,
			);
		}
		lines.push("-".repeat(70));
		lines.push(`TOTAL`.padEnd(32) + " ".repeat(34) + `$${total.toFixed(4)}`);
		return lines.join("\n");
	}

	pi.registerCommand("cost", {
		description: "Show token usage and cost breakdown per model for this session",
		handler: async (_args, ctx) => {
			ctx.ui.notify(report(), "info");
		},
	});

	pi.on("session_shutdown", async (_event, ctx) => {
		if (byModel.size === 0) return;
		ctx.ui.notify(`Session cost:\n${report()}`, "info");
	});
}
