---
name: tdd
description:
  Build a feature using strict, collaborative test-driven development. Use when
  the user wants to work test-first, drive a new behavior with tests, or says
  "let's TDD this" / "do this TDD-style". Enforces red-green-refactor with the
  user approving each test and driving every refactor — not a one-shot
  implementation mode.
user-invocable: true
argument-hint: "[behavior to build]"
---

Work on the user's task using TDD. **This is a collaboration.** The goal is not
to one-shot a feature — it's for the user to understand what's being built as
it's built. Move in small steps and check in often.

## The loop

1. **Agree on the next small behavior with the user.** Propose a candidate or
   ask what they want to drive next, and confirm before moving on. If the
   behavior would require a branch or condition that doesn't exist yet, surface
   that and agree to test-drive the branch _first_. Never introduce untested
   branches just to make another test pass.

2. **Write the test directly into the corresponding test file.** Do not paste
   the test into the chat window as a proposal — writing it to the file _is_ the
   proposal. The user reviews the test in their editor (and stages it as they
   go) so they can see exactly what's new and what they've approved. Write only
   one test. Do not touch production code yet.

3. **Run the test and prove it fails correctly.** Always. Never skip this. A
   valid red is _only_ an assertion failure from the new test, showing the new
   behavior is missing. The following are **not** valid reds — if you see one,
   fix it and re-run before proceeding:
   - Compile errors, syntax errors, type errors
   - Missing imports, missing modules, undefined references
   - Setup/fixture failures, test runner config errors
   - Any _other_ test failing (you broke something else)

   The test must run, execute its assertion, and fail _because the behavior
   under test is not yet implemented_. Show the red output.

4. **Wait for the user to approve the test.** After red is proven, pause and
   use the `AskUserQuestion` tool to ask whether the test is good to go
   (options: "Approve — implement it", "Revise the test"). The user reviews it
   in the file (often staging it) to signal approval. Do not start
   implementation until they give the go-ahead.

5. **Write the minimum code to go green.** Bare minimum, literally. Do not copy
   a pattern from elsewhere if it introduces branches, error handling, or
   abstractions the current test doesn't force. If a test seems to require a
   branch, propose to the user we start over and write a test for that branch
   first.

6. **Run the test and prove it passes.**

7. **Pause.** Use the `AskUserQuestion` tool to ask "continue to the next test,
   or refactor the current state?" (options: "Next test", "Refactor"). The
   auto-provided "Other" option lets the user type a specific refactor
   instruction directly — treat that free-text as their refactor direction for
   step 8, not as a rejection of the prompt. Do not rush to the next red.

8. **If refactoring:** the user drives. They decide what to refactor and how.
   Follow their instruction, make the one small change they asked for, re-run
   the tests, and wait for the next instruction. Expect many back-and-forth
   steps; treat each as its own small transaction.

   If the user explicitly asks for suggestions ("what would you refactor here?",
   "any ideas?"), share your thoughts. Otherwise, stay focused on executing what
   they asked for.

## Rules

- No production code without a failing test driving it.
- No untested branches. If you'd need one, test-drive it first.
- Always prove red before green. Always.
- Always get user sign-off on the test before implementing.
- Always pause after green. Never auto-advance to the next test.
- Refactoring is slow and iterative. Don't rush.

## When a new test passes immediately

If you write a new test and it's green on the first run with no implementation
change, **stop and question it** before moving on. This is not disallowed —
sometimes a test is genuinely redundant-but-valuable as documentation or as a
guard against regression — but it's suspicious.

Ask:

- Is this test actually covered by an existing test? If so, is the duplication
  worth it?
- Did we miss a chance to drive this behavior with a red first (e.g., did we
  already implement too much in a prior step)?
- Is the assertion weak enough that it passes trivially?

Raise this with the user. A small amount of redundancy is fine; a pattern of it
means we're not really test-driving.
