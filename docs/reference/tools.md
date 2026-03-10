# Tools Reference

A comprehensive guide to all 100+ tools included in this dotfiles setup. Each tool is documented with its purpose and practical examples.

::: tip Interactive Browser
Run `tools --tui` in your terminal for an interactive tool browser with search!
:::

## Shell & Terminal

| Tool | Description | Example |
|------|-------------|---------|
| [zsh](https://www.zsh.org/) | Modern shell with plugins & completions | Tab-complete git branches, kubectl resources |
| [starship](https://starship.rs/) | Beautiful prompt showing git, python, node status | See branch, venv, node version at a glance |
| [tmux](https://github.com/tmux/tmux) | Split terminal into panes, persist sessions | `tmux new -s work` → detach → reattach anywhere |
| [sesh](https://github.com/joshmedeski/sesh) | Fuzzy-find and switch tmux sessions | `sesh connect` → pick project → instant switch |
| [ghostty](https://ghostty.org/) | GPU-rendered terminal, native feel | Smooth scrolling, ligatures, 60fps rendering |

## Editors & Writing

| Tool | Description | Example |
|------|-------------|---------|
| [neovim](https://neovim.io/) | Vim but modern: LSP, Treesitter, Lua | `<Space>ff` fuzzy find, `gd` go to definition |
| [dawn](https://github.com/andrewmd5/dawn) | Distraction-free writing, live markdown | `dawn notes.md` → headers scale, math renders |
| [glow](https://github.com/charmbracelet/glow) | Render markdown beautifully in terminal | `glow README.md` → styled output, no browser |

## Modern CLI Replacements

These tools replace classic Unix commands with faster, more intuitive alternatives:

| Classic | Modern | Why It's Better |
|---------|--------|-----------------|
| `cat` | [bat](https://github.com/sharkdp/bat) | Syntax highlighting, line numbers, git integration |
| `ls` | [eza](https://github.com/eza-community/eza) | Icons, git status, tree view built-in |
| `find` | [fd](https://github.com/sharkdp/fd) | Intuitive syntax, respects `.gitignore` |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | 10x faster, smart defaults, skips binaries |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) | Learns your habits, `z proj` jumps anywhere |
| `diff` | [difftastic](https://difftastic.wilfred.me.uk/) | Understands code structure, semantic diffs |
| `curl` | [httpie](https://httpie.io/) | Human-friendly, colored JSON output |
| `man` | [tldr](https://tldr.sh/) | Practical examples, not 50-page manuals |
| `top` | [btop](https://github.com/aristocratos/btop) | Beautiful, shows CPU/RAM/disk/network |
| `du` | [ncdu](https://dev.yorhel.nl/ncdu) | Interactive disk usage explorer |

## File Management

| Tool | Description | Example |
|------|-------------|---------|
| [yazi](https://yazi-rs.github.io/) | Fastest file manager, vim keys, previews | `yazi` → j/k navigate, preview images/PDFs |
| [broot](https://dystroy.org/broot/) | Navigate directories as tree, fuzzy search | `br` → type to filter, alt+enter to cd |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy find anything: files, history, processes | `Ctrl+r` → search command history |
| [stow](https://www.gnu.org/software/stow/) | Symlink manager for dotfiles | `stow nvim` → links config automatically |
| [rename](https://metacpan.org/pod/rename) | Batch rename with regex | `rename 's/IMG_/photo_/' *.jpg` |

## Version Control

| Tool | Description | Example |
|------|-------------|---------|
| [git](https://git-scm.com/) | Distributed version control | `git log --oneline --graph` |
| [gh](https://cli.github.com/) | GitHub from terminal: PRs, issues, Actions | `gh pr create` → PR without leaving terminal |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI: stage hunks, rebase visually | `lazygit` → space to stage, c to commit |
| [serie](https://github.com/lusingander/serie) | Beautiful git commit graph | `serie` → see branch topology with colors |
| [gitlogue](https://github.com/bensadeh/gitlogue) | Replay commits like a movie | `gitlogue` → watch project evolve |
| [git-lfs](https://git-lfs.github.com/) | Handle large files efficiently | `git lfs track '*.psd'` |
| [difftastic](https://difftastic.wilfred.me.uk/) | Structural diff tool | `difft old.py new.py` → semantic changes |

## Data & Databases

| Tool | Description | Example |
|------|-------------|---------|
| [jq](https://jqlang.github.io/jq/) | Query & transform JSON | `curl api \| jq '.items[].name'` |
| [harlequin](https://harlequin.sh/) | Full SQL IDE in terminal | `harlequin db.sqlite` → autocomplete, export |
| [tabiew](https://github.com/shshemi/tabiew) | View CSV/Parquet with SQL queries | `tw data.csv` → spreadsheet + SQL filtering |
| [dbt](https://www.getdbt.com/) | Analytics engineering tool | `dbt run` → transform raw data |
| [mongosh](https://www.mongodb.com/docs/mongodb-shell/) | MongoDB shell with autocomplete | `db.users.find({age: {$gt: 21}})` |
| [snowsql](https://docs.snowflake.com/en/user-guide/snowsql) | Snowflake CLI | `snowsql -q 'SELECT * FROM users'` |
| [sqlit](https://github.com/nicholassm/sqlit) | Lazygit for databases | `sqlit` → connect, query, vim keys |
| [lnav](https://lnav.org/) | Log file navigator | `lnav *.log` → time-synced, filterable |

## Development Tools

| Tool | Description | Example |
|------|-------------|---------|
| [watchexec](https://github.com/watchexec/watchexec) | Run command on file changes | `watchexec -e py pytest` → auto-test |
| [hyperfine](https://github.com/sharkdp/hyperfine) | Benchmark commands scientifically | `hyperfine 'fd' 'find'` → compare |
| [act](https://github.com/nektos/act) | Test GitHub Actions locally | `act -j test` → run without pushing |
| [vhs](https://github.com/charmbracelet/vhs) | Record terminal as GIF | `vhs demo.tape` → reproducible recordings |
| [scooter](https://github.com/thomasschafer/scooter) | Interactive find & replace | TUI for project-wide refactoring |
| [resterm](https://github.com/resterm/resterm) | Terminal API client | REST/GraphQL/gRPC/WebSocket testing |
| [direnv](https://direnv.net/) | Auto-load env vars per directory | `cd project` → `.envrc` loads automatically |

## Infrastructure & Cloud

| Tool | Description | Example |
|------|-------------|---------|
| [lima](https://lima-vm.io/) | Linux VMs on Mac, Docker alternative | `lima` → full Linux shell |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker TUI | Manage containers without flags |
| [slim](https://github.com/slimtoolkit/slim) | Minify containers by 30x | `slim build my-image` → optimized |
| [temporal](https://temporal.io/) | Durable execution platform | `temporal server start-dev` |
| [terraform](https://www.terraform.io/) | Infrastructure as code | `terraform apply` → provision cloud |
| [azure-cli](https://docs.microsoft.com/cli/azure/) | Manage Azure resources | `az vm list` |

## Languages & Runtimes

| Tool | Description | Example |
|------|-------------|---------|
| [uv](https://github.com/astral-sh/uv) | pip but 100x faster | `uv pip install pandas` → milliseconds |
| [pixi](https://prefix.dev/pixi) | Conda-compatible, fast | `pixi add numpy` → Python + system deps |
| [bun](https://bun.sh/) | Node.js but faster | `bun run dev` → 10x faster startup |
| [go](https://go.dev/) | Go programming language | `go run main.go` |
| [rust](https://www.rust-lang.org/) | Systems programming | `cargo run` |
| [gum](https://github.com/charmbracelet/gum) | Beautiful shell script prompts | `gum choose 'opt1' 'opt2'` |

## AI & LLM Tools

| Tool | Description | Example |
|------|-------------|---------|
| [opencode](https://opencode.ai/) | AI coding agent in terminal | `opencode` → Claude helps you code |
| [ollama](https://ollama.ai/) | Run LLMs locally | `ollama run llama2` → chat locally |
| [llamabarn](https://llamabarn.ai/) | Local LLM menu bar app | `localhost:2276/v1` → OpenAI-compatible |
| [llama.cpp](https://github.com/ggerganov/llama.cpp) | Efficient LLM inference | Run models on CPU |

## GNU Coreutils

GNU versions with more features than macOS defaults:

| Tool | Description | Example |
|------|-------------|---------|
| coreutils | GNU cp, mv, rm with progress | `gcp --progress file.iso /mnt` |
| gnu-sed | sed that works as expected | `gsed -i 's/old/new/g' file` |
| gawk | Full-featured awk | `gawk '{sum+=$1} END {print sum}'` |
| wget | Download & mirror websites | `wget -r site.com` |
| gnupg | Encrypt files & sign commits | `gpg -c secrets.txt` |

## Media & Documents

| Tool | Description | Example |
|------|-------------|---------|
| [ffmpeg](https://ffmpeg.org/) | Convert any media format | `ffmpeg -i vid.mov out.mp4` |
| [imagemagick](https://imagemagick.org/) | Batch process images | `convert -resize 50% img.png thumb.png` |
| [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) | Diagrams from text | `mmdc -i diagram.md -o out.png` |
| [slides](https://github.com/maaslalani/slides) | Terminal presentations | `slides deck.md` |
| [figlet](http://www.figlet.org/) | ASCII art text | `figlet 'Hello'` |

## Productivity Apps

| Tool | Description | Example |
|------|-------------|---------|
| [1password](https://1password.com/) | Password manager + CLI | `op item get 'AWS' --fields password` |
| [raycast](https://raycast.com/) | Spotlight replacement | Clipboard history, snippets, emoji |
| [cleanshot](https://cleanshot.com/) | Screenshot & annotate | Cmd+Shift+4 → draw → share |
| [espanso](https://espanso.org/) | Text expansion | `:sig` → full email signature |
| [shortcat](https://shortcat.app/) | Click UI with keyboard | Cmd+Shift+Space → type to click |

## Window Management

| Tool | Description | Example |
|------|-------------|---------|
| [aerospace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager | Alt+Enter → windows auto-tile |
| [skhd](https://github.com/koekeishiya/skhd) | Global hotkeys | Ctrl+Alt+T → terminal anywhere |
| [alt-tab](https://alt-tab-macos.netlify.app/) | Windows-style alt-tab | See window previews |

## System & Security

| Tool | Description | Example |
|------|-------------|---------|
| [wireguard](https://www.wireguard.com/) | Modern VPN | `wg-quick up vpn` |
| [lulu](https://objective-see.org/products/lulu.html) | Block outgoing connections | Firewall for outbound traffic |
| [aldente](https://apphousekitchen.com/) | Battery charge limiter | Stop at 80% for battery health |
| [jolt](https://github.com/jordond/jolt) | Battery & energy monitor | Track power-hungry processes |

## Exploring Tools

### CLI Commands

```bash
# Show all categories
tools

# Show tools in a category
tools -s vc          # Version control
tools -s cli         # Modern CLI tools
tools -s data        # Database tools

# Get details about a tool
tools -d lazygit

# Interactive TUI browser
tools --tui
```

### Version Management

```bash
# Show installed versions
update --versions

# Filter by package manager
update --versions brew
update --versions uv
update --versions cargo

# Check for updates
update --outdated

# Update a specific tool
update bat
```
