#!/bin/bash

# Read tool logging hook:
#   PreToolUse:  clear the tee-claude log, write a colored "read: <path>" header.
#   PostToolUse: append the file content so watch-claude shows it live.

set -o pipefail

input=$(cat)
event=$(jq -r '.hook_event_name' <<<"$input")
tool=$(jq -r '.tool_name' <<<"$input")

if git_root=$(ensure-git-repo 2>/dev/null); then
	log_id=$(basename "$git_root")
else
	log_id="$(basename "$PWD")_$(pwd | md5sum | cut -d' ' -f1)"
fi
LOG="/tmp/tee-claude/${log_id}.log"
COLOR_STATE="/tmp/tee-claude/${log_id}.color"

mkdir -p /tmp/tee-claude

case "$event" in
	PreToolUse)
		case "$tool" in
			Read)
				label="read: $(jq -r '.tool_input.file_path' <<<"$input")"
				;;
			WebFetch)
				url=$(jq -r '.tool_input.url' <<<"$input")
				prompt=$(jq -r '.tool_input.prompt' <<<"$input")
				label=$(printf 'fetch: %s\nprompt: %s' "$url" "$prompt")
				;;
			WebSearch)
				label="search: $(jq -r '.tool_input.query' <<<"$input")"
				;;
			Write)
				label="write: $(jq -r '.tool_input.file_path' <<<"$input")"
				;;
			Edit)
				label="edit: $(jq -r '.tool_input.file_path' <<<"$input")"
				;;
			Task|Agent)
				label="agent: $(jq -r '.tool_input.subagent_type // .tool_input.description // "?"' <<<"$input")"
				;;
		esac
		COLORS=(36 33 32 35)
		idx=$(cat "$COLOR_STATE" 2>/dev/null || echo 0)
		color=${COLORS[$idx]}
		next=$(( (idx + 1) % ${#COLORS[@]} ))
		printf '%s' "$next" > "$COLOR_STATE"
		printf '\033[H\033[2J\033[%sm%s\033[0m\n' "$color" "$label" >> "$LOG"
		case "$tool" in
			Task|Agent)
				printf 'subagent_type: %s\n' "$(jq -r '.tool_input.subagent_type // "?"' <<<"$input")" >> "$LOG"
				printf 'description: %s\n' "$(jq -r '.tool_input.description // "?"' <<<"$input")" >> "$LOG"
				printf 'prompt:\n' >> "$LOG"
				jq -r '.tool_input.prompt' <<<"$input" \
					| prettier --parser markdown --prose-wrap always \
					| bat --force-colorization --paging=never --style=grid -l md >> "$LOG"
				;;
		esac
		;;
	PostToolUse)
		case "$tool" in
			Read)
				path=$(jq -r '.tool_response.file.filePath' <<<"$input")
				start=$(jq -r '.tool_response.file.startLine' <<<"$input")
				num=$(jq -r '.tool_response.file.numLines' <<<"$input")
				end=$(( start + num - 1 ))
				bat --force-colorization --paging=never --style=numbers,grid --line-range "$start:$end" "$path" >> "$LOG"
				;;
			WebFetch)
				jq -r '.tool_response.result' <<<"$input" \
					| prettier --parser markdown --prose-wrap always \
					| bat --force-colorization --paging=never --style=grid -l md >> "$LOG"
				;;
			WebSearch)
				while IFS=$'\t' read -r url title; do
					printf -- '- \033]8;;%s\033\\%s\033]8;;\033\\\n' "$url" "$title" >> "$LOG"
				done < <(jq -r '.tool_response.results[0].content[] | "\(.url)\t\(.title)"' <<<"$input")
				jq -r '.tool_response.results[1]' <<<"$input" \
					| fmt -w 120 \
					| bat --force-colorization --paging=never --style=grid -l md >> "$LOG"
				;;
			Write)
				path=$(jq -r '.tool_response.filePath' <<<"$input")
				bat --force-colorization --paging=never --style=numbers,grid "$path" >> "$LOG"
				;;
			Edit)
				path=$(jq -r '.tool_response.filePath' <<<"$input")
				orig=$(mktemp)
				jq -j '.tool_response.originalFile' <<<"$input" > "$orig"
				width=$(( $(cat "/tmp/tee-claude/${log_id}.cols" 2>/dev/null || echo 200) - 2 ))
				diff -u "$orig" "$path" | delta --paging=never --line-numbers --width "$width" >> "$LOG"
				rm -f "$orig"
				;;
			Task|Agent)
				COLORS=(36 33 32 35)
				idx=$(cat "$COLOR_STATE" 2>/dev/null || echo 0)
				prev=$(( (idx - 1 + ${#COLORS[@]}) % ${#COLORS[@]} ))
				color=${COLORS[$prev]}
				printf '\n\033[%smresponse:\033[0m\n' "$color" >> "$LOG"
				types=$(jq -r '.tool_response.content // [] | map(.type) | unique | join(",")' <<<"$input")
				if [ "$types" = "text" ]; then
					jq -r '.tool_response.content | map(.text) | join("\n\n")' <<<"$input" \
						| prettier --parser markdown --prose-wrap always \
						| bat --force-colorization --paging=never --style=grid -l md >> "$LOG"
				else
					printf '[unknown agent response shape: content types=%s — extend log-read.sh to render this]\n' "$types" >> "$LOG"
					jq '.tool_response' <<<"$input" >> "$LOG"
				fi
				;;
		esac
		;;
esac
