#!/usr/bin/env bash

set -uo pipefail

RUNLOG_OUTPUT_FILE="${RUNLOG_OUTPUT_FILE:-/tmp/chatgpt_terminal_last.json}"

json_escape() {
  python3 -c 'import json, sys; print(json.dumps(sys.stdin.read()))'
}

runlog() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: runlog <command> [args...]"
    return 1
  fi

  local tmp_output
  local timestamp
  local cwd
  local exit_code
  local command_str

  tmp_output="$(mktemp /tmp/runlog_output.XXXXXX)"
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  cwd="$(pwd)"

  # Build shell-escaped command string
  printf -v command_str '%q ' "$@"
  command_str="${command_str% }"

  # Run command, mirror output to terminal, and save full output
  "$@" > >(tee "$tmp_output") 2> >(tee -a "$tmp_output" >&2)
  exit_code=$?

  {
    printf '{\n'
    printf '  "timestamp": %s,\n' "$(printf '%s' "$timestamp" | json_escape)"
    printf '  "cwd": %s,\n' "$(printf '%s' "$cwd" | json_escape)"
    printf '  "command": %s,\n' "$(printf '%s' "$command_str" | json_escape)"
    printf '  "exit_code": %s,\n' "$exit_code"
    printf '  "output": %s\n' "$(cat "$tmp_output" | json_escape)"
    printf '}\n'
  } > "$RUNLOG_OUTPUT_FILE"

  rm -f "$tmp_output"
  return "$exit_code"
}