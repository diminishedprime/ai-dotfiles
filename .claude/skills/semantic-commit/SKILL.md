---
name: semantic-commit
description:
  Generate a high-quality semantic commit message for the user's staged changes.
  Use when the user says "commit this", "write me a commit message", "make a
  commit", "semantic commit", or otherwise asks you to author a commit for what
  they've already staged.
user-invocable: true
---

Generate a semantic commit message from the user's staged changes.

**Assume the user has already staged exactly what they want committed.** If
they're asking for a commit, they've set things up ahead of time. The staged
changes shown below are the full scope of this commit — unstaged edits and
untracked files are deliberately not part of it.

Do not question the shape of the stage. Specifically:

- Do not ask "should I also include..." or point out unstaged files as if they
  might be an oversight.
- Do not ask whether the staged changes should be split into multiple commits,
  or suggest that they look like "two distinct things." If the user staged them
  together, they intend to commit them together. Write one message that covers
  the staged scope.
- Do not offer to stage, unstage, or rearrange anything.

The only thing you ask the user about is the _why_ behind the changes when
that's genuinely unclear (see step 1).

## Current staged changes

```!
git diff --staged --stat
```

## Steps

1. Consider whether the _why_ behind the changes is obvious from context. If the
   motivation is clear (e.g., adding a new feature that's self-explanatory,
   fixing a typo), skip ahead. But if you'd otherwise be guessing at the user's
   intent — why a refactor was done, what problem a config change solves, what
   prompted a fix — ask a brief clarifying question or two first. Keep it
   lightweight: one or two focused questions, not an interrogation. The goal is
   to capture the real motivation without being tedious.

   **Use the `AskUserQuestion` tool for these clarifying questions.** Do not
   pose them as a numbered list in plain text — answering a numbered list by
   hand is annoying. The tool gives the user a proper structured prompt.

   **You are an LLM. You cannot reconstruct user motivation from a diff.** The
   why must come from something explicit — a conversation in this session, a
   TODO comment, a linked issue, an obviously self-explanatory subject line. If
   you can't point to a specific source for the motivation, you don't know it;
   stop and ask the user instead of inventing one. A diff feeling
   self-evident is not the same as you actually knowing why the user made it.

2. Craft a commit message. Format: `<type>[(<scope>)]: <subject>` with an
   optional body.

   Types: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `ci`,
   `build`, `perf`

   Subject: imperative mood, no trailing period, ≤ 72 characters.

3. **Default to a body that explains the _why_.** The commit message is
   documentation that lives next to the diff in `git log` — anyone reading it
   sees what changed right alongside your message, so the message exists to add
   what the diff can't show on its own. That's almost always a motivation: the
   problem being solved, the constraint forcing the change, the prior incident,
   the deliberate tradeoff. One or two short sentences is plenty.

   A bodyless commit is allowed only when the subject itself makes the
   motivation self-evident — e.g., `fix: typo in README`, `chore: bump deps`,
   `fix: handle empty input in parser`. If you'd have to read the diff to
   understand why this change exists, the body is not optional.

   If the why isn't obvious to you from context, ask the user before drafting
   rather than inventing a plausible-sounding motivation.

   **Common failure modes to avoid** (you will be tempted):
   - Listing the files that changed
   - Summarizing or paraphrasing the code
   - Narrating the change ("updates X to handle Y")
   - Inverting the change into a "why" ("we wanted X to happen" for a
     change that makes X happen — the diff already shows that). If the
     only motivation you can articulate is the inverse-restatement of
     the change, either find a deeper why (the original friction, a
     prior incident, a constraint) or drop the body line entirely.

   Before writing each sentence, ask: "would a reader with the diff in front of
   them learn anything from this?" A sentence that explains _why_ passes; a
   sentence that restates _what_, or that just states the desired outcome the
   diff already implements, does not.

4. **Audit before showing.** Invoke the `semantic-commit-audit` subagent (via
   the Agent tool) with your draft message as the prompt. If it returns
   `VIOLATIONS`, fix every one and re-audit. **You must keep re-running the
   auditor until it returns `APPROVED`** — every revised draft requires a
   fresh audit call, even if the change feels minor or you're confident the
   fix addresses the violation. Reasoning "I trimmed the offending sentence,
   so it must pass now" is not a substitute for actually running the audit.
   Do not show the user any draft that has not, on its most recent revision,
   come back `APPROVED`.

   **If the auditor flags "narration" or "doesn't explain why" on two
   consecutive revisions, stop iterating and go ask the user.** That
   pattern means you are guessing at motivation rather than reporting
   it, and each new draft is just substituting one plausible fabrication
   for another. The fix is to get the real why from the user via
   `AskUserQuestion` (same reasoning as step 1 — one question per change
   whose motivation you're missing, with concrete candidate motivations
   as options) and draft a new revision from their words. Then re-audit
   that revision like any other.

   **The auditor is not optional and you do not get to overrule it by
   appealing to the user.** Showing the user an un-`APPROVED` draft
   alongside the auditor's outstanding complaints — inviting them to
   wave it through, sharpen it for you, or confirm the auditor is being
   too strict — is a way of laundering an audit failure into approval.
   Don't do it. If you are stuck, the next move is always to gather
   more grounding from the user (their motivation, in their words) and
   feed it back into a new revision that you then re-audit. The user
   only sees drafts that have come back `APPROVED` on their most recent
   revision.

5. Present the (audited) message to the user (rendered markdown, not a code
   block). Ask if they'd like to commit or adjust it.

6. If the user wants changes, iterate — re-audit each new draft — until they
   approve. On approval, run `git commit` using a HEREDOC for the message.
   **Run the commit in the background** (`run_in_background: true`). Pre-commit
   hooks routinely take long enough that a foreground call looks hung and
   derails the session; backgrounding lets the harness notify you when it
   finishes. Once notified, check the result and report success or surface the
   hook failure to the user.
