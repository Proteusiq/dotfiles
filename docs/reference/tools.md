# Tools Reference

Every tool installed by this setup, grouped by the categories of the `tools` command (`bin/tools.py`).

Sources of truth:

- `Brewfile`: Homebrew formulae and casks, `uv` tools and `cargo` crates.
- `mise/.config/mise/config.toml`: language runtimes and npm-based tools.
- `bin/tools.py`: the catalog behind `tools` and `update --info`. A prek hook (`scripts/check_catalog.py`) fails if a Brewfile or mise tool has no catalog entry.

::: tip Interactive browser
Run `tools --tui` for a searchable browser, or `tools -s <category>` for one category.
:::

The **Source** column shows how a tool is installed: `brew`, `cask`, `uv`, `cargo`, `mise`, or `installer` (a third-party install script run by `update --only utils`).

## Shell (`shell`)

Terminal, prompt, multiplexer.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [zsh](https://www.zsh.org/) | brew | Shell with plugins and completions | Tab-complete git branches, ssh hosts |
| [antidote](https://github.com/mattmc3/antidote) | brew | zsh plugin manager, static bundle | Edit `~/.config/zsh/plugins.txt`, open a new shell |
| [starship](https://starship.rs/) | brew | Prompt with git, Python and Node status | Branch, venv and Node version at a glance |
| [tmux](https://github.com/tmux/tmux) | brew | Split the terminal into panes, persist sessions | `tmux new -s work`, detach, reattach later |
| [sesh](https://github.com/joshmedeski/sesh) | brew | Fuzzy-find and switch tmux sessions | `sesh connect` → pick a project |
| [tmux-expose](https://github.com/cesarferreira/tmux.expose) | cargo | Mission Control-style tmux session switcher | `Alt+e` → grid of live session previews |
| [atuin](https://github.com/atuinsh/atuin) | brew | Searchable shell history with context | `Ctrl+R` → search every command |
| [ghostty](https://ghostty.org/) | cask | GPU-rendered terminal | Default terminal; starts tmux automatically |
| [herdr](https://herdr.dev) | installer | Herdr | `herdr --help` |

## Editors (`edit`)

Text editors and writing.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [neovim](https://neovim.io/) | brew | Editor with LSP, Treesitter, Lua config (LazyVim) | `<Space>ff` find files, `gd` go to definition |
| [dawn](https://github.com/andrewmd5/dawn) | brew (tap `andrewmd5/tap`) | Distraction-free writing, live markdown render | `dawn notes.md` |
| [glow](https://github.com/charmbracelet/glow) | brew | Render markdown in the terminal | `glow README.md` |
| leaf-markdown-viewer | brew | Markdown previewer with TOC, watch mode, themes | `leaf -w notes.md` → live reload |

## Modern CLI (`cli`)

Modern Unix replacements. Several are aliased over the classic command (see [Aliases](./aliases.md)).

| Classic | Tool | Source | Description | Example |
|---------|------|--------|-------------|---------|
| `cat` | [bat](https://github.com/sharkdp/bat) | brew | Syntax highlighting and line numbers | `bat script.py` |
| `ls` | [eza](https://github.com/eza-community/eza) | brew | Icons, git status, tree view | `eza -la --git` |
| `find` | [fd](https://github.com/sharkdp/fd) | brew | Simple syntax, respects `.gitignore` | `fd 'test.*py'` |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | brew | Fast recursive search, skips binaries and `.git` | `rg 'TODO'` |
| | [repgrep](https://github.com/acheronfail/repgrep) | cargo | Interactive find and replace on ripgrep results | `rgr 'old_name'` |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) | brew | `cd` that learns your habits | `z proj` |
| `curl` | [httpie](https://httpie.io/) | brew | HTTP client with coloured JSON output | `http GET api.github.com/users/octocat` |
| `man` | [tlrc](https://github.com/tldr-pages/tlrc) | brew | tldr pages client (command: `tldr`) | `tldr tar` |
| | [pay-respects](https://github.com/iffse/pay-respects) | cargo | Fix the last mistyped command (replaces thefuck) | `git brach` → `f` |

## Files (`files`)

File management and navigation.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [yazi](https://yazi-rs.github.io/) | brew | Terminal file manager with previews | `yy` → yazi, then cd to where you left it |
| [broot](https://dystroy.org/broot/) | brew | Navigate directories as a tree | `br` → type to filter |
| [fzf](https://github.com/junegunn/fzf) | brew | Fuzzy finder | `Ctrl+T` → pick a file into the command line |
| [ncdu](https://dev.yorhel.nl/ncdu) | brew | Interactive disk usage (alias `du`) | `ncdu ~` |
| [btop](https://github.com/aristocratos/btop) | brew | System monitor (alias `top`) | `btop` |
| [stow](https://www.gnu.org/software/stow/) | brew | Symlink manager for dotfiles | `update --only stow` |
| [rename](https://metacpan.org/pod/rename) | brew | Batch rename with regex | `rename 's/IMG_/photo_/' *.jpg` |
| rsync | brew | Fast incremental file copy and sync | `rsync -avh src/ dst/` |
| [croc](https://github.com/schollz/croc) | brew | Encrypted device-to-device file transfer | `croc send file.zip` |

## Version control (`vc`)

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [git](https://git-scm.com/) | brew | Version control | `git l` → graph log (git alias) |
| [git-lfs](https://git-lfs.github.com/) | brew | Large file storage | `git lfs track '*.psd'` |
| [git-filter-repo](https://github.com/newren/git-filter-repo) | brew | Rewrite git history | `git filter-repo --path secrets.env --invert-paths` |
| [git-delta](https://github.com/dandavison/delta) | brew | Pager for `git diff`, `git log`, `git show` | `git diff` → `n`/`N` jump between files |
| [difftastic](https://difftastic.wilfred.me.uk/) | brew | Syntax-aware diff, on demand | `git dft`, `git dlog`, `git dshow` |
| [gh](https://cli.github.com/) | brew | GitHub CLI; also the git credential helper for github.com | `gh pr create` |
| [lazygit](https://github.com/jesseduffield/lazygit) | brew | Git TUI | `lazygit`, or `prefix g` in tmux |
| [serie](https://github.com/lusingander/serie) | brew | Git commit graph | `serie` |
| [gitlogue](https://github.com/unhappychoice/gitlogue) | brew | Cinematic commit replay | `gitlogue` |

`update --only utils` also installs the `gh` extension `dlvhdr/gh-dash` (`gh dash`).

## Quality (`quality`)

Linters, formatters and secret scanning. The repository's git hooks (`.pre-commit-config.yaml`) use these through prek.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [prek](https://prek.j178.dev) | brew | Git hooks runner, pre-commit compatible | `prek install` |
| [gitleaks](https://github.com/gitleaks/gitleaks) | brew | Find secrets in code and git history | `gitleaks git .` |
| [shellcheck](https://github.com/koalaman/shellcheck) | brew | Shell linter | `shellcheck install.sh` |
| [shfmt](https://github.com/mvdan/sh) | brew | Shell formatter | `shfmt -i 4 -w script.sh` |
| [stylua](https://github.com/JohnnyMorganz/StyLua) | brew | Lua formatter | `stylua nvim/` |
| [actionlint](https://github.com/rhysd/actionlint) | brew | GitHub Actions workflow linter | `actionlint` |
| [ruff](https://github.com/astral-sh/ruff) | brew | Python linter and formatter | `ruff check --fix . && ruff format .` |
| [ty](https://github.com/astral-sh/ty) | brew | Python type checker | `ty check .` |
| [biome](https://biomejs.dev/) | brew | JS/TS linter and formatter | `biome check --write .` |
| [bacon](https://github.com/Canop/bacon) | brew | Background Rust checker | `bacon clippy` |

## Data (`data`)

Databases and data processing.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [jq](https://jqlang.github.io/jq/) | brew | Query and transform JSON | `curl api \| jq '.items[].name'` |
| [yq](https://github.com/mikefarah/yq) | brew | jq for YAML | `yq '.parameters' main.params.yaml` |
| [duckdb](https://duckdb.org/) | brew | In-process analytical SQL on files | `duckdb -c "select * from 'data/*.parquet' limit 5"` |
| [tabiew](https://github.com/shshemi/tabiew) | brew | View CSV/Parquet/JSON with SQL (command: `tw`) | `tw data.csv` |
| [dbt](https://www.getdbt.com/) | brew (tap `dbt-labs/dbt-cli`) | dbt Cloud CLI | `dbt run` |
| [snowflake-cli](https://github.com/snowflakedb/snowflake-cli) | brew | Snowflake CLI (command: `snow`; replaces SnowSQL) | `snow sql -q 'select current_role()'` |
| [sqlfluff](https://github.com/sqlfluff/sqlfluff) | brew | SQL linter and formatter (dbt, Snowflake) | `sqlfluff lint models/ --dialect snowflake` |
| [harlequin](https://harlequin.sh/) | uv | SQL IDE in the terminal (duckdb, mysql, postgres, sqlite adapters) | `harlequin db.duckdb` |
| sqlit-tui | uv | Database TUI (command: `sqlit`) | `sqlit` → pick a connection |
| [mongosh](https://www.mongodb.com/docs/mongodb-shell/) | brew | MongoDB shell | `mongosh` |
| [lnav](https://lnav.org/) | brew | Log file viewer | `lnav /var/log/*.log` |

## Dev (`dev`)

Development and build tools.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [watchexec](https://github.com/watchexec/watchexec) | brew | Run a command when files change | `watchexec -e py pytest` |
| [hyperfine](https://github.com/sharkdp/hyperfine) | brew | Benchmark commands | `hyperfine 'fd' 'find'` |
| [act](https://github.com/nektos/act) | brew | Run GitHub Actions locally | `act -j test` |
| [vhs](https://github.com/charmbracelet/vhs) | brew | Record terminal sessions as GIFs | `vhs demo.tape` |
| [scooter](https://github.com/thomasschafer/scooter) | brew | Interactive find and replace across files | `scooter` |
| [resterm](https://github.com/resterm/resterm) | brew | Terminal API client (REST/GraphQL/gRPC) | `resterm` |
| [universal-ctags](https://github.com/universal-ctags/ctags) | brew | Index symbols for editors | `ctags -R .` |
| [postman](https://www.postman.com/) | cask | API client GUI | Collections, environments, tests |
| [gum](https://github.com/charmbracelet/gum) | brew | Prompts and spinners for shell scripts | `gum choose 'opt1' 'opt2'` |

## Infra (`infra`)

Containers, infrastructure and cloud.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [orbstack](https://orbstack.dev/) | cask | Docker and Linux VMs for macOS (default engine) | `docker run --rm hello-world` |
| [colima](https://github.com/abiosoft/colima) | brew | Open-source container runtime on Lima (alternative) | `colima start` |
| [lima](https://lima-vm.io/) | brew | Linux VMs on macOS | `limactl start` |
| [docker](https://www.docker.com/) | brew | Docker CLI (engine from OrbStack or colima) | `docker compose up` |
| [docker-compose](https://github.com/docker/compose) | brew | Multi-container apps | `docker compose logs -f api` |
| [docker-buildx](https://github.com/docker/buildx) | brew | Multi-platform image builds | `docker buildx build --platform linux/amd64 .` |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | brew | Docker TUI | `lazydocker`, or `prefix D` in tmux |
| [mintoolkit](https://github.com/mintoolkit/mint) | brew | Container image minifier (formerly docker-slim; command: `mint`) | `mint slim my-image` |
| [opentofu](https://opentofu.org/) | brew | Open-source Terraform (command: `tofu`; replaces terraform) | `tofu plan` |
| [azure-cli](https://docs.microsoft.com/cli/azure/) | brew | Azure CLI (`az`); Bicep via `az bicep install` | `az bicep build -f main.bicep` |
| [azd](https://github.com/Azure/azure-dev) | brew (tap `azure/azd`) | Azure Developer CLI | `azd up` |
| [temporal](https://temporal.io/) | brew | Durable execution platform CLI | `temporal server start-dev` |

## Languages (`lang`)

Runtimes and toolchains. Rule from `mise/.config/mise/config.toml`: language runtimes and npm-based tools live in mise; Python is managed by uv, Rust by rustup.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [mise](https://mise.jdx.dev/) | brew | Runtime manager for node, go, bun, pnpm; per-project versions | `mise use node@24` |
| [uv](https://github.com/astral-sh/uv) | brew | Python packages, tools and versions | `uv add pandas` |
| [pixi](https://prefix.dev/pixi) | brew | Conda-compatible environment manager | `pixi add numpy` |
| [rustup](https://rustup.rs/) | brew | Rust toolchain manager (`rustup default stable`) | `rustup update` |
| [node](https://nodejs.org/) | mise (`lts`) | JavaScript runtime | `node --version` |
| [go](https://go.dev/) | mise (`latest`) | Go toolchain | `go run .` |
| [bun](https://bun.sh/) | mise (`latest`) | JavaScript runtime and bundler | `bun run dev` |
| [pnpm](https://pnpm.io/) | mise (`latest`) | Disk-efficient npm | `pnpm install` |

## AI (`ai`)

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [opencode](https://opencode.ai/) | brew | AI coding agent in the terminal | `opencode` |
| pi | mise (`npm:@earendil-works/pi-coding-agent`) | Earendil's coding agent | `pi` |
| [llama.cpp](https://github.com/ggerganov/llama.cpp) | brew | Run GGUF models locally | `llama-server -m model.gguf` |
| [ollama-app](https://ollama.ai/) | cask | Run LLMs locally | `ollama run llama3` |
| hf | brew | Hugging Face Hub CLI | `hf download org/model` |
| [unsloth](https://unsloth.ai/) | installer | Fine-tune LLMs locally (Unsloth Studio, in `~/unsloth_studio`) | `unsloth studio` |

## GNU (`gnu`)

Interactive zsh puts the GNU versions of coreutils, findutils, sed, tar, grep and awk first on `PATH` under their usual names (see `zsh/.zshrc`). Scripts keep the BSD tools.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| coreutils | brew | GNU `cp`, `ls`, `date`, ... | `cp --backup=numbered a b` |
| gnu-sed | brew | GNU sed as `sed` | `sed -i 's/old/new/g' file` |
| gawk | brew | GNU awk as `awk` | `awk '{sum+=$1} END {print sum}'` |
| wget | brew | Download files, mirror websites | `wget -r site.com` |
| gnupg | brew | Encrypt and sign files | `gpg -c secrets.txt` |

Also installed, not catalogued: findutils, diffutils, binutils (keg-only), moreutils, gnu-tar, gnu-time, gnu-which, grep, gzip.

## Media (`media`)

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [ffmpeg](https://ffmpeg.org/) | brew | Convert media formats | `ffmpeg -i vid.mov out.mp4` |
| [gifsicle](https://www.lcdf.org/gifsicle/) | brew | Optimize GIFs (used by `gifify`) | `gifify demo.mov` |
| [imagemagick](https://imagemagick.org/) | brew | Image processing | `magick img.png -resize 50% thumb.png` |
| [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) | brew | Diagrams from text | `mmdc -i diagram.md -o out.png` |
| [slides](https://github.com/maaslalani/slides) | brew | Terminal presentations | `slides deck.md` |
| [figlet](http://www.figlet.org/) | brew | ASCII art banners | `figlet 'Hello'` |
| toilet | brew | Coloured ASCII art text | `toilet -f mono12 -F metal Hi` |

## Apps (`apps`)

Productivity applications and browsers.

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [1password](https://1password.com/) | cask | Password manager | |
| 1password-cli | cask | 1Password CLI (`op`) | `envrun python app.py` → secrets for one command |
| [raycast](https://raycast.com/) | cask | Spotlight replacement | Clipboard history, snippets |
| [cleanshot](https://cleanshot.com/) | manual | Screenshots. **Not in the Brewfile**: frozen at v4 (the license does not cover v5); install v4 manually | |
| [hiddenbar](https://github.com/dwarvesf/hidden) | cask | Hide menu bar icons | |
| [shortcat](https://shortcat.app/) | cask | Keyboard-driven UI navigation | |
| [mas](https://github.com/mas-cli/mas) | brew | Mac App Store CLI | `mas outdated` |
| [arc](https://arc.net/) | cask | Browser | |
| [zen](https://zen-browser.app/) | cask | Firefox-based privacy browser | |

## Windows (`wm`)

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [aerospace](https://github.com/nikitabobko/AeroSpace) | cask (tap `nikitabobko/tap`) | Tiling window manager; config `~/.config/aerospace/aerospace.toml` | `Alt+h/j/k/l` focus |
| [alt-tab](https://alt-tab-macos.netlify.app/) | cask | Windows-style alt-tab with previews | |

## System (`sys`)

| Tool | Source | Description | Example |
|------|--------|-------------|---------|
| [jolt](https://github.com/jordond/jolt) | brew (tap `jordond/tap`) | Battery and energy monitor TUI | `jolt` |
| [wireguard-tools](https://www.wireguard.com/) | brew | VPN | `wg-quick up vpn` |
| [lulu](https://objective-see.org/products/lulu.html) | cask | Outbound firewall | |
| [aldente](https://apphousekitchen.com/) | cask | Battery charge limiter | |

## Supporting packages

Installed by the Brewfile but not catalogued in `bin/tools.py` (`NOT_CATALOGUED` in `scripts/check_catalog.py`):

| Package | Why it is installed |
|---------|---------------------|
| pam-reattach | Touch ID for `sudo` inside tmux |
| unar, poppler, ffmpegthumbnailer, font-symbols-only-nerd-font | Yazi requirements |
| ghostscript, tectonic | snacks.nvim rendering (PDF, LaTeX) |
| graphviz | Graph visualization (PyMC) |
| font-hack-nerd-font | Hack Nerd Font |
| portaudio | Audio I/O (pyaudio) |
| zlib | Compression library |
| usage | Listed in the mise config |

## Removed

No longer installed: antigen, zplug (→ antidote), n, yarn (→ mise, pnpm), thefuck (→ pay-respects, alias `f`), terraform (→ opentofu `tofu`), SnowSQL (→ snowflake-cli `snow`), direnv (→ mise), skhd, screen, ack, flux-app, font-hack, gh-tran. docker-slim is now `mintoolkit`.

## Exploring tools

```bash
tools                 # categories and counts
tools -s vc           # one category
tools -d lazygit      # one tool
tools -j lazygit      # one tool as JSON (used by update --info)
tools --tui           # interactive browser

update --info bat     # catalog entry + installed source and version
update --versions     # installed versions (see CLI reference for groups)
update --outdated     # available updates
update bat            # update one tool
```

See the [CLI reference](./cli.md) for every flag.
