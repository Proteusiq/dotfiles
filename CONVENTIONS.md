# Development Conventions

## Philosophy

### Simplicity is King
- The simplest solution that works is the best solution
- If code needs step-by-step comments, it's too complex—refactor it
- Clear logic over clever tricks

### Self-Documenting Code
- **No tutorial comments**: never `# loop through items` or `// increment counter`
- Descriptive names: `calculate_total_price()` not `calc()`, `user_ids` not `ids`
- If you must comment, explain **why**, never **what**

### Functional Over OOP (Pragmatically)
- Prefer pure functions and immutability
- Composition over inheritance
- Use classes when they genuinely simplify (state machines, resource management)
- Data: dataclasses, structs, plain objects—not class hierarchies

### Commit Early, Commit Often
- Small, focused commits after each logical change
- One commit = one coherent unit of work
- Format: `type: description`

### Verify Before Commit
- Always verify changes work before committing
- If it's not tested, it's not done

---

## Python

### Tools
| Tool | Purpose | Install |
|------|---------|---------|
| `uv` | Package/project manager, Python versions | `brew install uv` |
| `ruff` | Linter & formatter | `uv tool install ruff` |
| `ty` | Type checker (Astral, 10-100x faster than mypy) | `uv tool install ty` |
| `pytest` | Testing | `uv add --dev pytest` |

### Workflow
```bash
uv init myproject && cd myproject
uv add requests
uv add --dev pytest

uv run python script.py
uv run pytest

# One-off (no install)
uvx ruff check .
uvx ty check .
```

### Before Commit
```bash
uv run ruff format .
uv run ruff check --fix .
uv run ty check .
uv run pytest
```

### Style
```python
async def fetch_users(user_ids: list[int]) -> list[User]:
    """Fetch users by their IDs."""
    async with httpx.AsyncClient() as client:
        tasks = [client.get(f"/users/{id}") for id in user_ids]
        responses = await asyncio.gather(*tasks)
        return [User(**r.json()) for r in responses]
```

- Type annotations: always, Python 3.12+ (`list[T]`, `X | None`)
- Docstrings: brief, public APIs only
- Async for I/O

---

## Rust

### Tools
| Tool | Purpose | Install |
|------|---------|---------|
| `cargo` | Build, test, package manager | `brew install rust` |
| `bacon` | Background checker (watches files) | `cargo install bacon` |
| `rustfmt` | Formatter | included |
| `clippy` | Linter | included |

### Workflow
```bash
cargo new myproject && cd myproject
cargo add serde tokio

# Background watcher (recommended)
bacon        # watches and runs cargo check
bacon clippy # watches and runs clippy
bacon test   # watches and runs tests

# Manual
cargo run
cargo test
```

### Before Commit
```bash
cargo fmt
cargo clippy -- -D warnings
cargo test
```

### Style
```rust
use anyhow::Result;
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct User {
    pub id: u64,
    pub name: String,
}

pub async fn fetch_user(user_id: u64) -> Result<User> {
    let url = format!("https://api.example.com/users/{user_id}");
    let user = reqwest::get(&url).await?.json().await?;
    Ok(user)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_fetch_user_returns_valid_user() {
        let user = fetch_user(1).await.unwrap();
        assert_eq!(user.id, 1);
    }
}
```

- Error handling: `Result<T, E>` and `?`, avoid `.unwrap()` in production
- No inline comments

---

## TypeScript / JavaScript

### Tools (Option A: Bun)
| Tool | Purpose | Install |
|------|---------|---------|
| `bun` | Runtime, bundler, test runner | `brew install bun` |
| `biome` | Linter & formatter (replaces eslint+prettier) | `bun add -d @biomejs/biome` |

### Tools (Option B: Deno)
| Tool | Purpose | Install |
|------|---------|---------|
| `deno` | Runtime with built-in fmt, lint, test | `brew install deno` |

### Workflow (Bun + Biome)
```bash
mkdir myproject && cd myproject
bun init
bun add zod
bun add -d @biomejs/biome typescript

bun run index.ts
bun test
```

### Before Commit (Bun + Biome)
```bash
bun biome format --write .
bun biome check --fix .
bun tsc --noEmit
bun test
```

### Workflow (Deno)
```bash
deno init myproject && cd myproject
deno run main.ts
deno test
```

### Before Commit (Deno)
```bash
deno fmt
deno lint
deno check .
deno test
```

### Style
```typescript
import { z } from "zod";

const UserSchema = z.object({
  id: z.number(),
  name: z.string(),
});

type User = z.infer<typeof UserSchema>;

export async function fetchUser(userId: number): Promise<User> {
  const response = await fetch(`https://api.example.com/users/${userId}`);
  const data = await response.json();
  return UserSchema.parse(data);
}
```

- Always TypeScript, never `any`
- `async`/`await` over raw promises
- No inline comments

---

## Bash

### Tools
| Tool | Purpose | Install |
|------|---------|---------|
| `shellcheck` | Static analysis | `brew install shellcheck` |
| `shfmt` | Formatter | `brew install shfmt` |

### Before Commit
```bash
bash -n script.sh
shellcheck script.sh
```

### Style
```bash
#!/bin/bash
set -euo pipefail

readonly LOG_FILE="/var/log/app.log"

log() {
    local msg="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $msg" | tee -a "$LOG_FILE"
}

main() {
    local name="${1:-World}"
    log "Hello, $name!"
}

main "$@"
```

- Always `set -euo pipefail`
- Quote variables: `"$var"`
- `[[ ]]` over `[ ]`
- No inline comments

---

## Git

### Commit Format
```
type: short description
```

| Type | Use |
|------|-----|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation |
| `chore:` | Maintenance |
| `refactor:` | Restructure (no behavior change) |
| `test:` | Tests |

---

## Quick Reference

| Lang | Format | Lint | Type Check | Test |
|------|--------|------|------------|------|
| Python | `ruff format .` | `ruff check --fix .` | `ty check .` | `pytest` |
| Rust | `cargo fmt` | `cargo clippy` | (built-in) | `cargo test` |
| TS (Bun) | `biome format --write .` | `biome check --fix .` | `tsc --noEmit` | `bun test` |
| TS (Deno) | `deno fmt` | `deno lint` | `deno check .` | `deno test` |
| Bash | `shfmt -w` | `shellcheck` | `bash -n` | - |

---

**The Loop:** Change → Verify → Commit → Repeat

If it's not tested, it's not done.
