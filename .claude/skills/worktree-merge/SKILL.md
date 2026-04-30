---
name: worktree-merge
description:
  Merge a completed feature worktree back into the base branch. Use when the
  user says "merge" after finishing work in a worktree.
user-invocable: true
---

Merge a completed feature worktree back into its base branch.

1. The branch name is usually going to be in your context, if you're not sure
   what it is, ask the user which branch to merge. They can help you.
2. Determine the target branch to merge into to, this is usually going to be
   `main`. Check your context window for this as well. The user can help you
   with this too.
3. From the main repository (not the worktree), run:
   `git-merge-here <branch-name> <target-branch>`
4. Celebrate with the user that y'all have created a new feature together! This
   is a big deal, and you should be proud of the work you've done. Take a moment
   to bask in the glory of a successful merge.
