# Development Conventions

## Dotfiles: Adding New Tools

**Never run `brew install` directly.** Always add tools via Brewfile.

When adding a new tool/package, update all three locations:

1. **`Brewfile`** — Add installation entry, then run `brew bundle`
2. **`Tools.md`** — Add documentation with examples and use cases
3. **`bin/tools.py`** — Add to appropriate category in the TUI explorer

```bash
# Example: adding 'noti'

# 1. Brewfile - add entry
brew "noti"                              # Process notifications (M4/Sequoia)

# 2. Install via bundle
brew bundle --file=~/dotfiles/Brewfile

# 3. Tools.md - add full docs with examples, flags, use cases

# 4. bin/tools.py - add to appropriate *_TOOLS list
("noti", "Notify when process completes (M4/Sequoia)", "make build; noti → notification when done"),
```

---

## Philosophy

- **Simplicity is king** — the simplest solution that works is the best solution
- **Self-documenting code** — if it needs comments, refactor it
- **Functional over OOP** — pure functions, composition, immutability
- **Commit early, commit often** — small, focused, verified commits

---

## Cross-Language Design Principles

These rules apply **to all languages**, regardless of tooling.

### Code Design
- Prefer **pure functions** where feasible; isolate side effects.
- Organize code so changes are easy and predictable.
- Avoid hidden state and mutable globals.

### Types & Data
- Declare types explicitly at *module boundaries*.
- Use language-specific type features to model domain constraints (e.g., Rust enums, TS `zod` schemas).

### Error Handling
- Treat errors as structured data, not control flow.
- Add contextual information when propagating errors.
- Avoid swallowing errors silently.

### Testing
- Prefer **unit tests** for pure logic and **integration tests** for I/O boundaries.
- Assert behavior, not implementation details.
- Aim for reproducibility and determinism.
- Follow the **AAA pattern**: Arrange, Act, Assert.

### Comments & Docs
- Use comments to explain *why* something is needed.
- Public APIs must have documentation; internal helper functions usually do not.
- If code needs lots of comments, **refactor** instead.

### Git & Collaboration
- Use a *feature-branch workflow* with clear naming (e.g., `feat/…`, `fix/…`, `refactor/…`).
- Rebase or squash commits to maintain clean history.
- Use PRs with reviews, tests, and clear descriptions.

### Architecture & Boundaries
- Divide code into *layers* (core logic, side effects, interfaces).
- Keep modules small and focused.
- Separate business logic from runtime and framework concerns.

### Project Structure (Functional Core, Imperative Shell)

```
┌─────────────────────────────────┐
│         Interfaces              │  ← CLI, API, UI (thin)
├─────────────────────────────────┤
│         Side Effects            │  ← I/O, database, network
├─────────────────────────────────┤
│         Core Logic              │  ← Pure functions (testable)
└─────────────────────────────────┘
```

**Recommended layout:**
```
src/
  core/       # Pure business logic (no I/O)
  services/   # Side effects (DB, HTTP, filesystem)
  api/        # HTTP handlers
  cli/        # CLI commands
tests/
  unit/       # Tests for core/
  integration/ # Tests for services/
```

**Why this works:**
- Core logic is **pure** → easy to test, no mocks needed
- Side effects are **isolated** → easy to swap implementations
- Interfaces are **thin** → easy to add new entry points

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

### Best Practices Checklist
- [ ] **Tools**: Using `uv`, `ruff`, `ty`, `pytest`
- [ ] **Types**: All functions have type annotations
- [ ] **Async**: Using `asyncio` for I/O (not blocking `subprocess.run()`, `requests`, etc.)
- [ ] **Data structures**: Using `dataclass` or `pydantic` for structured data
- [ ] **HTTP**: Using `httpx` (async) instead of `requests` (sync)
- [ ] **Validation**: Using `pydantic` or manual validation for external input
- [ ] **Error handling**: Returning structured errors, not raising exceptions for control flow
- [ ] **Imports**: Absolute imports, no circular dependencies
- [ ] **Config**: Environment variables via `os.environ` or config files, not hardcoded

### PEP 8 Essentials (enforced by ruff)
- 4 spaces indentation, no tabs
- `snake_case` for functions/variables, `PascalCase` for classes, `UPPER_CASE` for constants
- Use `is` / `is not` for `None` comparisons (not `==`)
- Prefer `''.join()` for string concatenation in loops
- Use context managers (`with`) for resource management
- Avoid mutable default arguments (`def f(x=[])` is bad)
- Keep functions small and focused (pure functions preferred)

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

## macOS

### Tools
| Tool | Purpose |
|------|---------|
| `noti` | Notifications (works on M4/Sequoia) |

### Usage
```bash
# Notify when command finishes
noti -t "Build" -m "Complete"

# Notify after long-running command
make build; noti -t "Build" -m "Done"

# Watch a process
noti --pwatch 1234
```

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

### Pull Requests
- **Title**: same format as commits (`type: description`)
- **Description**: explain the *why*, not just the *what*
- **Before/after**: show output changes when relevant
- **Link issues**: reference related issues/discussions
- Keep PRs focused—one logical change per PR

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
