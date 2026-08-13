/**
 * Snapshot Extension
 *
 * The first time a subagent is dispatched in a session, saves a git snapshot
 * ref (refs/pi/snapshot) capturing HEAD plus uncommitted tracked changes.
 * If a worker run goes sideways, restore with:
 *
 *   git reset --hard refs/pi/snapshot
 *
 * /snapshot shows the current ref; the ref survives across sessions until
 * the next snapshot overwrites it.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const REF = "refs/pi/snapshot";

export default function (pi: ExtensionAPI) {
	let snapshotted = false;

	async function takeSnapshot(ctx: { cwd: string; ui: { notify: (m: string, l: "info" | "warning") => void } }) {
		const head = await pi.exec("git", ["rev-parse", "--verify", "HEAD"]);
		if (head.code !== 0) return; // not a git repo — nothing to snapshot

		// `git stash create` captures uncommitted tracked changes as a commit
		// object; falls back to plain HEAD when the tree is clean.
		const stash = await pi.exec("git", ["stash", "create"]);
		const ref = stash.stdout.trim() || head.stdout.trim();

		await pi.exec("git", ["update-ref", REF, ref]);
		ctx.ui.notify(`📸 Snapshot saved (${ref.slice(0, 8)}) — restore with: git reset --hard ${REF}`, "info");
	}

	pi.on("tool_call", async (event, ctx) => {
		if (snapshotted || event.toolName !== "subagent") return;
		snapshotted = true;
		await takeSnapshot(ctx);
		return undefined;
	});

	pi.registerCommand("snapshot", {
		description: "Show the saved pre-orchestration snapshot ref",
		handler: async (_args, ctx) => {
			const res = await pi.exec("git", ["rev-parse", "--verify", REF]);
			if (res.code !== 0) {
				ctx.ui.notify("No snapshot saved for this repo yet.", "info");
				return;
			}
			const show = await pi.exec("git", ["log", "-1", "--oneline", REF]);
			ctx.ui.notify(`Snapshot: ${show.stdout.trim()}\nRestore with: git reset --hard ${REF}`, "info");
		},
	});
}
