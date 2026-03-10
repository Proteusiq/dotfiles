# Git Configuration

Git is configured for a modern workflow with signed commits, delta for diffs, and lazygit for a terminal UI.

## Configuration

```bash
# git/.gitconfig
[user]
    name = Your Name
    email = your@email.com

[init]
    defaultBranch = main

[core]
    editor = nvim
    pager = delta

[pull]
    rebase = true

[push]
    autoSetupRemote = true

[merge]
    conflictStyle = diff3

[diff]
    colorMoved = default
```

## Delta (Better Diffs)

[Delta](https://github.com/dandavison/delta) provides syntax-highlighted diffs.

```bash
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    line-numbers = true
    side-by-side = false
    syntax-theme = Catppuccin Mocha
```

## Aliases

### Git Aliases

```bash
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    lg = log --oneline --graph --decorate
    cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d"
```

### Shell Aliases

```bash
# In .aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias gd="git diff"
alias gds="git diff --staged"
alias glog="git log --oneline --graph --decorate"
```

## Lazygit

[Lazygit](https://github.com/jesseduffield/lazygit) provides a terminal UI for git.

```bash
# Open lazygit
lg

# Or in Neovim
<Space>gg
```

### Key Bindings

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `Enter` | Select |
| `Space` | Stage/unstage |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branch menu |
| `m` | Merge |
| `r` | Rebase |
| `z` | Stash |
| `?` | Help |

## Commit Signing

### SSH Signing (Recommended)

```bash
# Generate key
ssh-keygen -t ed25519 -C "your@email.com"

# Configure git
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true

# Add to GitHub
cat ~/.ssh/id_ed25519.pub
# → Settings → SSH Keys → New SSH Key (Signing Key)
```

### 1Password SSH Agent

If using 1Password:

```bash
[gpg]
    format = ssh

[gpg "ssh"]
    program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"

[commit]
    gpgsign = true
```

## GitHub CLI

[GitHub CLI](https://cli.github.com) integrates GitHub into your terminal.

```bash
# Login
gh auth login

# Create PR
gh pr create

# View PRs
gh pr list

# Check out PR
gh pr checkout 123

# Create issue
gh issue create

# View repo
gh repo view --web
```

### Extensions

```bash
# gh-dash - Dashboard for PRs/issues
gh extension install dlvhdr/gh-dash
gh dash
```

## Workflow

### Feature Branch

```bash
# Start feature
git checkout -b feat/my-feature

# Work and commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push
gh pr create

# After review
git checkout main
git pull
git branch -d feat/my-feature
```

### Conventional Commits

```bash
feat:     # New feature
fix:      # Bug fix
docs:     # Documentation
chore:    # Maintenance
refactor: # Restructure (no behavior change)
test:     # Tests
```

### Useful Commands

```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Amend last commit
git commit --amend

# Interactive rebase
git rebase -i HEAD~3

# Clean up merged branches
git cleanup

# See what changed
git whatchanged -p

# Blame with better context
git blame -w -C -C -C
```

## .gitignore

Global gitignore at `~/.gitignore_global`:

```bash
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Editor
*.swp
*.swo
*~
.idea/
.vscode/

# Environment
.env
.env.local
*.pem

# Python
__pycache__/
*.pyc
.venv/
.mypy_cache/

# Node
node_modules/
```

Configure:

```bash
git config --global core.excludesfile ~/.gitignore_global
```
