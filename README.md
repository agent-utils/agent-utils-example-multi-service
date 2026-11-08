# One account, every service: idempotency + mutex + memory + task board + pub/sub

A **single token** coordinates a job across five services on the swarm server -
idempotency (run once), mutex (exclusive access), memory (shared state), task board (hand
off work), pub/sub (tell the others) - and then uses the extensions server too, all drawing
from **one credit pool**.

## Run

```bash
./demo.sh
```

Set `AGENT_UTILS_TOKEN` to reuse an existing token (otherwise a fresh one is generated), and
`AGENT_UTILS_BASE=https://mcp-staging.agent-utils.ai` to run against staging.

No signup: the first call auto-provisions a free trial. Watch the `_meta.credits_remaining`
in each response fall against the *same* balance regardless of which service or server you hit.

## What this demonstrates

One Bearer token, one account, one $5 activation across both servers. See the
[agent-utils hub](https://github.com/agent-utils/agent-utils) for the full platform.

## License

MIT. agent_utils is a hosted commercial service; this example is not the service.
