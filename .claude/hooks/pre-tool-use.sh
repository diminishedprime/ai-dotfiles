#!/bin/bash

# PreToolUse hook:
#   1. Let cc-toolgate decide allow/ask/deny (compound-aware, reads its own config).
#   2. Wrap the command with tee-claude so `watch-claude` can follow along live.
#
# updatedInput replaces tool_input wholesale, so carry the original fields
# through and only override `command`. Otherwise sibling fields like
# `run_in_background` get dropped.

input=$(cat)

root="${CLAUDE_PROJECT_DIR:-$PWD}"

cc-toolgate <<<"$input" | jq --argjson orig "$input" --arg root "$root" '
  .hookSpecificOutput.updatedInput = (
    ($orig.tool_input // {}) +
    { command: (
        "TEE_CLAUDE_ROOT=" + ($root | @sh)
        + " tee-claude zsh -c " + ($orig.tool_input.command | @sh)
    ) }
  )
'
