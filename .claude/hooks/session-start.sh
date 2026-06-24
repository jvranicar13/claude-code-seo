#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Install DataForSEO MCP server globally so it's available without npx download delay
npm install -g dataforseo-mcp-server --prefer-offline 2>/dev/null || npm install -g dataforseo-mcp-server

# Install slash commands into Claude's user commands directory
mkdir -p ~/.claude/commands
cp "$CLAUDE_PROJECT_DIR"/commands/*.md ~/.claude/commands/

# Restore GSC OAuth token using refresh token from environment
# Set GSC_REFRESH_TOKEN, GSC_CLIENT_ID, GSC_CLIENT_SECRET in Claude Code project env settings
if [ -n "${GSC_REFRESH_TOKEN:-}" ] && [ ! -f ~/.gsc-mcp/oauth-token.json ]; then
  mkdir -p ~/.gsc-mcp
  RESPONSE=$(curl -s -X POST https://oauth2.googleapis.com/token \
    -d "client_id=${GSC_CLIENT_ID}" \
    -d "client_secret=${GSC_CLIENT_SECRET}" \
    -d "refresh_token=${GSC_REFRESH_TOKEN}" \
    -d "grant_type=refresh_token")
  ACCESS_TOKEN=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('access_token',''))")
  if [ -n "$ACCESS_TOKEN" ]; then
    cat > ~/.gsc-mcp/oauth-token.json << EOF
{"access_token":"${ACCESS_TOKEN}","refresh_token":"${GSC_REFRESH_TOKEN}","scope":"https://www.googleapis.com/auth/webmasters.readonly","token_type":"Bearer","expiry_date":9999999999999}
EOF
  fi
fi
