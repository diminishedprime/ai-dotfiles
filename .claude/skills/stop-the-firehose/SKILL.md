---
name: stop-the-firehose
description:
  Use when the assistant's previous message was too much at once and the user
  needs them to slow down and chunk smaller. The user's most recent reply should
  NOT be treated as a response to the firehose — it is a meta-signal to reset,
  not engagement with the content.
user-invocable: true
---

The user has invoked `/stop-the-firehose`. Your previous message was too much
for them to absorb. They likely did not read it in full, or at all.

## What this means

- **Your previous message should be treated as withdrawn.** Do not assume the
  user has read it or agreed to anything in it.
- **The user's most recent reply is not a response to that message.** Do not
  treat it as agreement, disagreement, or a content answer. It was a signal to
  slow down.
- **This is a reminder.** You are already supposed to work in small, reviewable
  chunks per global guidelines. This skill exists because you often drift.

## What to do now

1. Acknowledge briefly. No defensiveness, no re-explaining the firehose.
2. List the 2–4 topics that were buried in the previous message as short bullets
   — one line each, no elaboration. The point is to give the user a map, not to
   re-deliver the firehose in list form.
3. Ask which one to start with.
   - If possible, use an Ask Question skill for this, with the options as
     buttons.

## Specific patterns to avoid

- Multi-part questions ("two things to confirm:", "a few quick questions:")
- Numbered lists of options when one would do
- Trailing alternatives
- Pre-emptive caveats and tradeoff lists the user didn't ask for
- More than a paragraph of text
