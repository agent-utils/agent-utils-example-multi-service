# One account, three services: memory + mutex + idempotency

The agent_utils moat, made runnable: a **single token** coordinates a job across three
MCP services - idempotency (run once), mutex (exclusive access), memory (shared state) -
all drawing from **one credit pool**. A single-purpose competitor can't do this.

## Run

```bash
./demo.sh
```

No signup: the first call auto-provisions a free trial. Watch the `_meta.credits_remaining`
in each response fall against the *same* balance regardless of which service you hit.

## What this demonstrates

One Bearer token, one account, one $5 activation across every service. See the
[agent-utils hub](https://github.com/agent-utils/agent-utils) for the full platform.

## License

MIT. agent_utils is a hosted commercial service; this example is not the service.
