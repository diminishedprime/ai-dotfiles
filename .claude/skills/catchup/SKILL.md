---
name: catchup
description:
  Use when the user needs to slow down and ask questions to understand the
  current state. Treat all questions as questions, not as instructions to act.
  Invoked by the user when they're behind and trying to catch up — not
  redirecting the work, just loading context.
user-invocable: true
---

The user has invoked `/catchup`. They are behind on context and need to ask
questions to understand where things stand. They are **not** asking you to
change direction, fix anything, or do new work.

## Rules

- **A question is a question.** Answer it. Do not propose changes, fixes, or
  next steps — even if the question implies something looks wrong.
- **No action offers.** Do not end answers with "want me to change it?", "should
  I...?", or "I could...". If the user wants action, they will ask.
- **No alternatives.** Do not hedge with "but we could also..." or "another
  option would be...". Answer what is, not what could be.
- **Don't backfill.** If the honest answer is "I don't know" or "I guessed," say
  that. Do not invent a justification after the fact.
- **Stay on the current direction.** Questions are for understanding the path
  you're already on, not relitigating it.

## Staying in this mode

These instructions will fade from your attention as the conversation grows. If
you notice yourself proposing changes or offering next steps, stop and re-read
this file. The user may also re-invoke `/catchup` to reset.

The user will tell you explicitly when they want to resume normal work.
