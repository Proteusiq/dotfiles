# Development Conventions

## Workflow Philosophy

### Commit Early, Commit Often
- Make small, focused commits after each logical change
- Each commit should be a single, coherent unit of work
- Commit messages: `type: description` (e.g., `fix:`, `feat:`, `docs:`, `chore:`)
- Don't batch multiple unrelated changes into one commit

### Verify Before Commit
- Always verify changes work before committing
- If it's not tested, it's not done

### Test After Changes
- Run the actual commands/scripts to verify behavior
- Don't just assume code works—execute it
- Check edge cases when relevant

### Document As You Go
- Update documentation alongside code changes
- If you change behavior, update the relevant README/docs in the same commit

---

## Python

### Tools
| Tool | Purpose | Install |
|------|---------|---------|
| `uv` | Package manager, project manager, Python version manager | `brew install uv` |
| `ruff` | Linter & formatter (replaces black, isort, flake8) | `uv tool install ruff` |
| `ty` | Type checker (from Astral, ruff creators) | `uv tool install ty` |
| `pytest` | Testing framework | `uv add --dev pytest` |
| `pytest-asyncio` | Async test support | `uv add --dev pytest-asyncio` |

### Workflow
```bash
# Create project
uv init myproject && cd myproject

# Add dependencies
uv add requests
uv add --dev pytest ruff

# Run commands in project environment
uv run python script.py
uv run pytest

# One-off tool execution (no install)
uvx ruff check .
uvx ty check .

# Before committing
uv run ruff format .
uv run ruff check --fix .
uv run ty check .
uv run pytest
```

### Verification Checklist
```bash
uv run ruff format .          # Format code
uv run ruff check --fix .     # Lint & auto-fix
uv run ty check .             # Type check
uv run pytest                 # Run tests
```

### Code Style
- **Type annotations**: Always, using Python 3.12+ syntax
  ```python
  def fetch(url: str, timeout: float = 30.0) -> dict[str, Any] | None: ...
  ```
- **Docstrings**: Google-style for public APIs
- **Imports**: stdlib → third-party → local (blank lines between)
- **Async**: Prefer `async`/`await` for I/O-bound operations

### Example
```python
async def fetch_users(ids: list[int]) -> list[User]:
    """Fetch users by their IDs.

    Args:
        ids: List of user IDs to fetch.

    Returns:
        List of User objects.

    Raises:
        httpx.HTTPError: If the request fails.
    """
    async with httpx.AsyncClient() as client:
        tasks = [client.get(f"/users/{id}") for id in ids]
        responses = await asyncio.gather(*tasks)
        return [User(**r.json()) for r in responses]
```

---

## Rust

### Tools
| Tool | Purpose | Install |
|------|---------|---------|
| `cargo` | Package manager, build tool | `brew install rust` |
| `rustfmt` | Formatter | Included with rustup |
| `clippy` | Linter | Included with rustup |
| `cargo-watch` | Auto-rebuild on changes | `cargo install cargo-watch` |

### Workflow
```bash
# Create project
cargo new myproject && cd myproject

# Add dependencies
cargo add serde tokio

# Run
cargo run
cargo run --release

# Before committing
cargo fmt
cargo clippy -- -D warnings
cargo test
```

### Verification Checklist
```bash
cargo fmt                     # Format code
cargo clippy -- -D warnings   # Lint (treat warnings as errors)
cargo test                    # Run tests
cargo build --release         # Verify release build
```

### Code Style
- **Error handling**: Use `Result<T, E>` and `?` operator, avoid `.unwrap()` in production
- **Documentation**: `///` for public items, `//!` for module docs
- **Naming**: `snake_case` for functions/variables, `PascalCase` for types

### Example
```rust
use anyhow::Result;
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct User {
    pub id: u64,
    pub name: String,
}

/// Fetches a user by ID from the API.
///
/// # Errors
/// Returns an error if the HTTP request fails or response is invalid.
pub async fn fetch_user(id: u64) -> Result<User> {
    let url = format!("https://api.example.com/users/{id}");
    let user = reqwest::get(&url).await?.json().await?;
    Ok(user)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_fetch_user() {
        let user = fetch_user(1).await.unwrap();
        assert_eq!(user.id, 1);
    }
}
```

---

## TypeScript / JavaScript

### Tools
| Tool | Purpose | Install |
|------|---------|---------|
| `bun` | Runtime, package manager, bundler, test runner | `brew install bun` |
| `biome` | Linter & formatter (replaces eslint + prettier) | `bun add -d @biomejs/biome` |
| `tsc` | Type checker | `bun add -d typescript` |

### Workflow
```bash
# Create project
mkdir myproject && cd myproject
bun init

# Add dependencies
bun add zod
bun add -d typescript @biomejs/biome

# Run
bun run index.ts
bun run build

# Before committing
bun biome format --write .
bun biome check --fix .
bun tsc --noEmit
bun test
```

### Verification Checklist
```bash
bun biome format --write .    # Format code
bun biome check --fix .       # Lint & auto-fix
bun tsc --noEmit              # Type check (no output)
bun test                      # Run tests
```

### Code Style
- **Types**: Always use TypeScript, avoid `any`
- **Imports**: Use ES modules (`import`/`export`)
- **Async**: Use `async`/`await` over raw promises

### Example
```typescript
import { z } from "zod";

const UserSchema = z.object({
  id: z.number(),
  name: z.string(),
});

type User = z.infer<typeof UserSchema>;

/** Fetches a user by ID from the API. */
export async function fetchUser(id: number): Promise<User> {
  const response = await fetch(`https://api.example.com/users/${id}`);
  const data = await response.json();
  return UserSchema.parse(data);
}

// test
import { expect, test } from "bun:test";

test("fetchUser returns valid user", async () => {
  const user = await fetchUser(1);
  expect(user.id).toBe(1);
});
```

---

## Bash / Shell

### Tools
| Tool | Purpose | Install |
|------|---------|---------|
| `shellcheck` | Static analysis | `brew install shellcheck` |
| `shfmt` | Formatter | `brew install shfmt` |

### Workflow
```bash
# Before committing
bash -n script.sh             # Syntax check
shellcheck script.sh          # Lint
shfmt -w script.sh            # Format (optional)

# Run
bash script.sh
./script.sh                   # If executable
```

### Verification Checklist
```bash
bash -n script.sh             # Syntax check (no execution)
shellcheck script.sh          # Static analysis
```

### Code Style
- **Strict mode**: Always start with `set -euo pipefail`
- **Quoting**: Always quote variables `"$var"`
- **Conditionals**: Use `[[ ]]` over `[ ]`
- **Functions**: Use for reusable logic

### Example
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

---

## Git Conventions

### Commit Messages
```
type: short description

Optional longer explanation if needed.
```

**Types:**
| Type | Use for |
|------|---------|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation only |
| `chore:` | Maintenance, cleanup |
| `refactor:` | Code restructuring (no behavior change) |
| `test:` | Adding/updating tests |

### Workflow
```
1. Make change
2. Verify (format, lint, type check, test)
3. Commit with descriptive message
4. Push when logical unit is complete
```

---

## Quick Reference

| Language | Format | Lint | Type Check | Test |
|----------|--------|------|------------|------|
| Python | `uv run ruff format .` | `uv run ruff check --fix .` | `uv run ty check .` | `uv run pytest` |
| Rust | `cargo fmt` | `cargo clippy` | (built-in) | `cargo test` |
| TypeScript | `bun biome format --write .` | `bun biome check --fix .` | `bun tsc --noEmit` | `bun test` |
| Bash | `shfmt -w` | `shellcheck` | `bash -n` | - |

---

## Summary

**The Loop:** Change → Verify → Commit → Repeat

If it's not tested, it's not done.
