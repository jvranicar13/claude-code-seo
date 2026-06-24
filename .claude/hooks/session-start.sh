#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Install slash commands into Claude's user commands directory
mkdir -p ~/.claude/commands
cp "$CLAUDE_PROJECT_DIR"/commands/*.md ~/.claude/commands/
