---
name: worktree-new-feature
description:
  Start a new feature using the git worktree workflow. `git-work-here` creates a
  feature worktree, writes a plan file, and opens a new VS Code window for the
  user to start working on it with another claude instance. Use when the user
  wants to start new work on any repo.
user-invocable: true
---

Help the user start a new feature using the git worktree workflow.

**IMPORTANT: Your role is to write the plan file and hand off to the worktree.
Do NOT implement the changes yourself — even if the task seems simple or
straightforward. ALL implementation happens in the worktree by another Claude
instance. Running `git-work-here` is REQUIRED, not optional.**

1. **FIRST ACTION — before anything else:** Call the `EnterPlanMode` tool to
   ensure you are in plan mode. Do this immediately, before asking questions or
   doing any other work.
2. If a branch name or suggestion was not provided, ask the user what they want
   to build and suggest a `<branch-name>` using `feat/<name>` convention.
3. The `<base-ref>` will be main unless otherwise specified
   1. An EXCEPTION to this is if you're in the `~/programming/dotfiles` repo (or
      worktree), in which case the `<base-ref>` is `m4`
4. Now that you're in plan mode, draft the plan file that will be handed to a
   fresh LLM in the worktree. You are NOT planning your own implementation. The
   plan mode response should include:
   - A brief summary of what you're about to do (create worktree, write plan
     file, open VS Code)
   - The full proposed contents of `~/worktree-features/feat-<branch-slug>.md`,
     clearly labeled so the user can review and comment on it

   The plan file should include all context that will help a completely fresh
   LLM with no prior knowledge about the specific feature to complete it
   successfully. This file is the only context the worktree LLM will have of the
   direct feature — they _will_ have the CLAUDE.md files in their context,
   however, so don't duplicate that information.

   Wait for the user to approve or refine the plan file before proceeding. Once
   approved, exit plan mode and write the plan file to
   `~/worktree-features/feat-<branch-slug>.md`.

5. **IMPORTANT: Plan file must exist before calling git-work-here**

   The `git-work-here` script validates that the plan file exists and is a
   regular file before creating the worktree. Make sure the plan file is written
   to `~/worktree-features/feat-<branch-slug>.md` and saved to disk before
   proceeding to the next step. If the file doesn't exist or is invalid,
   `git-work-here` will fail immediately and clearly.

6. **REQUIRED — you MUST run this before any implementation happens:**
   ```sh
   git-work-here <branch-name> <base-ref> ~/worktree-features/feat-<branch-slug>.md
   ```
   This is the handoff. Your implementation work ends here.
7. Remind the user that the plan file at
   `~/worktree-features/feat-<branch-slug>.md` is ephemeral and should be
   deleted (not committed) before they wrap up in the worktree. They should
   delete it as part of their final commit or cleanup.
8. Tell the user that you'll patiently wait for them to complete the work, and
   for them to come back and say "merge" when done. ABSOLUTELY DO NOT, UNDER ANY
   CIRCUMSTANCE, RUN `git-merge-here` UNTIL THE USER COMES BACK AND SAYS
   "MERGE".
