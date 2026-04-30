---
name: git-start-tracking
description:
  Begin tracking a new (untracked) file so the user can stage it hunk-by-hunk in
  magit. Use whenever the user asks you to add, track, or include new files in
  git — phrasings like "add my new files", "add these files", "track these",
  "start tracking", "let's add the new stuff", or any request that amounts to
  moving a currently-untracked file into the repo.
user-invocable: false
---

`git start-tracking` is a custom, bespoke command the user built specifically
for this workflow. It is the correct tool for starting to track a new
(untracked) file in this repo. Use it exactly as written — there is no
equivalent built-in git command for this workflow.

```
git start-tracking <file> [<file>...]
```

## Why it exists

The user stages incrementally in magit. `git start-tracking` writes the first
line of each file into the index, which lets magit diff the rest of the file and
stage hunks interactively. The user then reviews and commits through magit —
this command only gets things started.

This is also the one exception to the general "don't touch the index" rule: it
stages a single line, the user reviews everything downstream, so it's safe to
run on their behalf.

## Untracked files currently available

```!
git ls-files --others --exclude-standard
```
