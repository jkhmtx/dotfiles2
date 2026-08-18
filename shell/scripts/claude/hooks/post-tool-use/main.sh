# shellcheck shell=bash

DISALLOWED_TOOLS=(
  Edit
  Read
)

LOG_FILE="${HOME}/data/commands.lst"

input=$(</dev/stdin)

tool_input=$(echo "${input}" | jq '.tool_input')
tool_name=$(echo "${input}" | jq -r '.tool_name')

for tool in "${DISALLOWED_TOOLS[@]}"; do
  if test "${tool}" = "${tool_name}"; then
    exit 0
  fi
done

mkdir -p "$(dirname "${LOG_FILE}")"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $tool_name: $(echo "$tool_input" | jq -c '.')" >>"${LOG_FILE}"

# Key points:
# - Reads JSON from stdin (the hook input)
# - Extracts tool name and input
# - Filters out Read/Edit noise
# - Appends timestamped entries to the log file
# - Creates log directory if needed
# 2. Settings Configuration (~/.claude/settings.json)
# {
#   "hooks": {
#     "PostToolUse": [
#       {
#         "matcher": "*",
#         "hooks": [
#           {
#             "type": "command",
#             "command": "$HOME/.claude/hooks/log-tools.sh"
#           }
#         ]
#       }
#     ]
#   }
# }
# Configuration breakdown:
# - PostToolUse event: Fires after every tool execution
# - matcher: "*" : Matches all tools
# - type: "command" : Runs the shell script
# - Uses $HOME for cross-machine portability
# 3. Log Output (~/data/commands.lst)
# [2026-04-10 09:17:07] Write: {"file_path":"/Users/kamadorueda/data/commands.lst","content":""}
# [2026-04-10 09:17:15] Bash: {"command":"gcloud scheduler jobs describe..."}
# [2026-04-10 09:17:40] Bash: {"command":"terraform plan"}
# [2026-04-10 09:17:50] Bash: {"command":"terraform validate && safebase.terraform.document"}
# Format: [timestamp] ToolName: {JSON tool input}
# ---
# Using Logs to Auto-Generate Permission Patterns
# Once you've accumulated tool calls in your log, you can have an agent analyze it and generate permission patterns to add to
# ~/.claude/settings.json:

# Can you review ~/data/commands.lst and suggest which commands are read-only and
# harmless enough to auto-approve? Output them as Bash permission rules for my
# Claude settings."
# The agent will:
# 1. Parse the log file
# 2. Identify read-only/harmless patterns
# 3. Group similar commands into permission rules
# 4. Provide a ready-to-copy JSON block for your settings.json
# Result: Over time, your permission list grows to match your actual workflow, reducing manual approvals without taking on
# unnecessary risk.
