#!/usr/bin/env bash
# One token across THREE agent_utils services, drawing from one credit pool.
# Run:  ./demo.sh   (needs curl; auto-provisions a free trial on first call)
set -euo pipefail

TOKEN="${AGENT_UTILS_TOKEN:-sk_$(openssl rand -hex 32)}"
echo "Using token: $TOKEN"

call() { # service, tool, args-json
  curl -s -X POST "https://$1.agent-utils.ai/mcp" \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$2\",\"arguments\":$3}}"
}

echo "1) idempotency: guard the job so it runs once"
call idempotency acquire_key '{"key":"nightly-report:2026-07-14","operation":"nightly-report","agent_name":"demo"}'

echo "2) mutex: take the lock for the shared resource"
call mutex acquire_lock '{"resource_id":"report.pdf","agent_name":"demo","ttl_seconds":60}'

echo "3) memory: record progress"
call memory put_memory '{"namespace":"jobs","key":"nightly-report","value_json":"\"running\""}'

echo "4) one shared balance - ask any service"
call memory get_account '{}'
