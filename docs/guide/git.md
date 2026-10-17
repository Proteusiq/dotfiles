# Git

Git reads its global config from `~/.config/git/config`, linked from `git/.config/git/config`. There is no `~/.gitconfig`.

::: warning
If a `~/.gitconfig` exists, Git reads it after `~/.config/git/config`, and its values win. Move anything you need from it into `~/.config/git/local.gitconfig`, then delete it.
:::

## Files

| File | Tracked | Purpose |
|------|---------|---------|
| `~/.config/git/config` | yes | Global settings, aliases, identity rules |
| `~/.config/git/ignore` | yes | Global ignore (Git's default excludes file) |
| `~/.config/git/personal.gitconfig` | no | Personal identity |
| `~/.config/git/work.gitconfig` | no | Work identity |
| `~/.config/git/local.gitconfig` | no | Machine-local overrides, included last |

`~/.config/git/` is a real directory (stow uses `--no-folding`), so the untracked files stay out of the repository.

## Identity by Remote

The config sets `user.useConfigOnly = true`. Git does not guess a name or email: a commit fails until an identity is configured. Work and personal identities never mix by accident.

The identity comes from the repository's remote URL:

| Remote URL starts with | Included file |
|------------------------|---------------|
| `git@github.com:proteusiq/` | `personal.gitconfig` |
| `git@github-personal:proteusiq/` | `personal.gitconfig` |
| `https://github.com/proteusiq/` | `personal.gitconfig` |
| `git@github.com:norlys-a-s/` | `work.gitconfig` |
| `git@github-work:norlys-a-s/` | `work.gitconfig` |
| `https://github.com/norlys-a-s/` | `work.gitconfig` |

The patterns accept a capital first letter (`[Pp]roteusiq`, `[Nn]orlys-[Aa]-[Ss]`). To use other owners, edit the `[includeIf]` sections in `git/.config/git/config`.

Create the identity files. For example, `~/.config/git/personal.gitconfig`:

```ini
[user]
    name = Your Name
    email = you@example.com
    signingkey = ~/.ssh/id_ed25519_signing.pub
```

`work.gitconfig` has the same shape. Check which identity a repository uses:

```bash
git config --show-origin user.email
```

A repository without a matching remote, such as a new local one, has no identity. Add the remote first, or set one for that repository:

```bash
git config user.email you@example.com
```

`update --doctor` reports missing identity files.

## Commit Signing (SSH)

Commits and tags are signed with an SSH key:

```ini
[gpg]
    format = ssh
[gpg "ssh"]
    allowedSignersFile = ~/.ssh/allowed_signers
[commit]
    gpgSign = true
[tag]
    gpgSign = true
```

Because signing is on, a commit fails until `user.signingkey` is set. Set it up once per identity:

1. Generate a key:
   ```bash
   ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519_signing
   ```
2. Point the identity file at the public key:
   ```ini
   [user]
       signingkey = ~/.ssh/id_ed25519_signing.pub
   ```
3. Add the key to GitHub as a **signing** key, so GitHub shows your commits as verified. `gh` needs the `admin:ssh_signing_key` scope for this:
   ```bash
   gh auth refresh -s admin:ssh_signing_key
   gh ssh-key add ~/.ssh/id_ed25519_signing.pub --type signing --title "MacBook signing"
   ```
4. Add the key to `~/.ssh/allowed_signers`, so Git can verify signatures locally. Each line is an email, the `namespaces` option, and the public key:
   ```bash
   echo "you@example.com namespaces=\"git\" $(cat ~/.ssh/id_ed25519_signing.pub)" >> ~/.ssh/allowed_signers
   ```
   A line looks like this:
   ```
   you@example.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... you@example.com
   ```
5. Make a commit and verify it:
   ```bash
   git log --show-signature -1
   ```
   The output starts with `Good "git" signature for you@example.com`.

## Multiple GitHub Accounts

With a personal and a work account on GitHub, use one SSH key per account and an SSH host alias for each. Add to `~/.ssh/config`:

```
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes
```

`IdentitiesOnly yes` makes SSH offer only that key, so GitHub sees the right account. Clone with the alias instead of `github.com`:

```bash
git clone git@github-work:Norlys-A-S/some-repo.git
```

The `[includeIf]` rules match `git@github-personal:` and `git@github-work:`, so the repository also gets the right identity.

## Diffs

### delta

[delta](https://github.com/dandavison/delta) is the pager for `diff`, `log` and `show`, and the filter for `git add -p`:

```ini
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true
    line-numbers = true
    syntax-theme = Catppuccin Mocha
```

`navigate = true` lets you jump between files with `n` and `N`.

### difftastic

[difftastic](https://difftastic.wilfred.me.uk) compares syntax, not lines. Use it on demand:

```bash
git dft            # git difftool with difft, no prompt
git dlog           # git log -p with difft
git dshow          # git show with difft
```

`diff.external` is not set, so `git diff` still prints a normal patch that `git apply` accepts.

## Defaults

| Setting | Value | Effect |
|---------|-------|--------|
| `diff.algorithm` | `histogram` | Clearer diffs |
| `diff.colorMoved` | `zebra` | Moved lines have their own color |
| `merge.conflictStyle` | `zdiff3` | Conflicts show the common ancestor |
| `rerere.enabled`, `rerere.autoUpdate` | `true` | Reuse recorded conflict resolutions |
| `fetch.prune` | `true` | Remove deleted remote branches on fetch |
| `pull.rebase` | `true` | Pull rebases instead of merging |
| `rebase.autoSquash` | `true` | `fixup!` commits are squashed in rebases |
| `rebase.autoStash` | `true` | Stash and restore local changes around a rebase |
| `rebase.updateRefs` | `true` | Move stacked branches along with a rebase |
| `push.default` | `current` | Push the current branch to a branch with the same name |
| `push.autoSetupRemote` | `true` | The first push sets the upstream |
| `push.followTags` | `true` | Push annotated tags with their commits |
| `branch.sort` | `-committerdate` | Recent branches first |
| `tag.sort` | `version:refname` | Version order |
| `commit.verbose` | `true` | The commit message editor shows the diff |
| `help.autocorrect` | `prompt` | Asks before it runs a corrected command |
| `init.defaultBranch` | `main` | |
| `core.abbrev` | `12` | Longer short hashes |
| `blame.coloring` | `highlightRecent` | Recent lines stand out in `git blame` |

### Credentials

`osxkeychain` stores credentials. For `https://github.com` and `https://gist.github.com`, Git uses `gh auth git-credential`, so run `gh auth login` once. Git LFS is configured as a filter; the installer runs `git lfs install`.

## Git Aliases

| Alias | Command |
|-------|---------|
| `git l` | `log --graph --oneline --decorate` |
| `git ld` | Graph log with colors, relative dates and authors |
| `git ll` | `log --stat --decorate --source -p` |
| `git branches` | Remote branches, most recent first, with date and author |
| `git delete-merged` | `fetch --prune`, then delete local branches merged into the current one. Keeps the current branch and `main`, `master`, `dev`, `develop`, `staging`. |
| `git dft`, `git dlog`, `git dshow` | difftastic, see [Diffs](#difftastic) |

## Shell Aliases

Some Git aliases from `aliases.zsh`:

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `gs` | `git status` |
| `gd` | `git diff` |
| `ga`, `gaa`, `gap` | `git add`, `git add .`, `git add --patch` |
| `gc` | `git commit -am` (commits all tracked changes) |
| `gcm` | `git commit --amend --message` |
| `gch`, `gcb` | `git checkout`, `git checkout -b` |
| `glo`, `glg` | `git log --oneline`, `git log --graph` |
| `gp`, `gpu`, `gpl` | `git push`, `git push -u origin`, `git pull` |
| `gst`, `gsp` | `git stash`, `git stash pop` |
| `undopush` | Moves the remote branch back one commit (`git push --force-with-lease origin HEAD^:<branch>`). The local branch keeps the commit. |
| `gpr`, `gbi` | `gh pr create`, `gh issue list --web` |

Functions from `functions.zsh`:

| Function | Effect |
|----------|--------|
| `gcl <url>` | `git clone`, then `cd` into the new repository |
| `gi <templates>` | Prints a `.gitignore` template, for example `gi macos,python > .gitignore` |
| `create-repo <name> [--public]` | Runs `git init` if needed, adds a `.gitignore` if missing, commits everything, then creates a private (or public) GitHub repository with `gh` and pushes |
| `rename-branch <old> <new>` | Renames a branch locally and on `origin` |

Run `aliases -s git` for the full list, or see the [Aliases Reference](/reference/aliases).

## Lazygit and gh-dash

| Tool | Open with |
|------|-----------|
| [lazygit](https://github.com/jesseduffield/lazygit) | `lazygit`; in tmux `prefix g` (full-screen popup); in Neovim `<leader>gg` |
| [gh-dash](https://github.com/dlvhdr/gh-dash) | `gh dash` |

## Global Ignore

`~/.config/git/ignore` is Git's default global excludes file, so `core.excludesFile` is not set. It ignores:

- macOS files (`.DS_Store`, `._*`, `.Spotlight-V100`, ...)
- secrets and local environment: `.env`, `.env.*` (except `.env.example` and `.env.sample`), `.envrc.local`, `*.pem`
- Python caches and `.venv/`
- `node_modules/`
- editor files (`*.swp`, `*~`, `.idea/`, `.vscode/`)
- agent files: `.aider*`, `.claude/settings.local.json`

## Hooks in This Repository

This repository uses [prek](https://prek.j178.dev), a faster drop-in for pre-commit. Install the hooks once per clone:

```bash
prek install
prek run --all-files   # run every hook now
```

| Hook | Checks |
|------|--------|
| built-in | trailing whitespace, end of file, merge conflict markers, YAML, TOML, JSON, private keys |
| `gitleaks` | secrets in staged changes |
| `shellcheck`, `shfmt` | `install.sh`, `run.sh`, `scripts/*.sh` (`shfmt -i 4`) |
| `zsh-syntax` | `zsh -n` on the zsh files |
| `stylua` | Lua formatting |
| `actionlint` | GitHub Actions workflows |
| `brewfile` | the `Brewfile` parses |
| `tool-catalog` | every `Brewfile` and mise tool has an entry in `bin/tools.py` |
| `ruff`, `ruff-format` | Python lint and format |

The tools come from the `Brewfile`. CI runs the same hooks.
