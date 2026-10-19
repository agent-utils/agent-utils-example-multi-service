#!/usr/bin/env bash
# One token across every agent_utils service, drawing from one credit pool.
# Run:  ./demo.sh   (needs curl; auto-provisions a free trial on first call)
# AGENT_UTILS_BASE=https://mcp-staging.agent-utils.ai ./demo.sh  runs it against staging.
set -euo pipefail

TOKEN="${AGENT_UTILS_TOKEN:-sk_$(openssl rand -hex 32)}"
BASE="${AGENT_UTILS_BASE:-https://mcp.agent-utils.ai}"
echo "Using token: $TOKEN"

call() { # server (swarm|extensions), tool, args-json
  curl -s -X POST "$BASE/$1" \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$2\",\"arguments\":$3}}"
  echo
}

echo "1) idempotency: guard the job so it runs once"
call swarm acquire_key '{"key":"nightly-report:2026-07-14","operation":"nightly-report","agent_name":"demo"}'

echo "2) mutex: take the lock for the shared resource"
call swarm acquire_lock '{"resource_id":"report.pdf","agent_name":"demo","ttl_seconds":60}'

echo "3) memory: record progress"
call swarm put_memory '{"namespace":"jobs","key":"nightly-report","value_json":"\"running\""}'

echo "4) task board: hand the review to whichever agent claims it first"
call swarm create_task '{"board":"nightly","title":"Review the nightly report"}'

echo "5) pub/sub: tell the other agents"
call swarm publish '{"topic":"nightly","body":"report generated, review queued","sender":"demo"}'

echo "6) extensions: same token, other server"
call extensions eval_expr '{"expr":"1234 * 1.0825"}'

echo "7) one shared balance - ask either server"
call extensions get_account '{}'
