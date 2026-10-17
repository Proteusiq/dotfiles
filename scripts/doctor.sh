#!/bin/bash
# Health check for the dotfiles setup: links, PATH order, configs, Brewfile, identity.
# Usage: update --doctor   (or scripts/doctor.sh)

set -uo pipefail

readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
readonly STOW_PACKAGES=(aerospace atuin ghostty git mise nvim sesh starship tmux yazi zsh)
readonly MAX_STARTUP_MS=300

source "$DOTFILES_DIR/scripts/logging.sh"

FAILURES=0
WARNINGS=0

pass() { echo -e "  ${GREEN}✓${NC} $*"; }
warn() {
    echo -e "  ${YELLOW}!${NC} $*"
    WARNINGS=$((WARNINGS + 1))
}
fail() {
    echo -e "  ${RED}✗${NC} $*"
    FAILURES=$((FAILURES + 1))
}
section() { echo -e "\n${BOLD}$*${NC}"; }

# Usage: expect "label" "hint shown on failure" command [args...]
expect() {
    local label="$1" hint="$2"
    shift 2
    if "$@" &>/dev/null; then
        pass "$label"
    else
        fail "$label: $hint"
    fi
}

# Symlinks that stow may own: top level of $HOME and anything under ~/.config
list_home_links() {
    find "$HOME" -maxdepth 1 -type l 2>/dev/null
    find "$HOME/.config" -maxdepth 5 -type l 2>/dev/null
}

check_links() {
    section "Links"
    local output
    output="$(stow --no --no-folding --restow -d "$DOTFILES_DIR" -t "$HOME" "${STOW_PACKAGES[@]}" 2>&1)"
    if grep -q "conflicts" <<<"$output"; then
        fail "stow conflicts (fix with: update --only stow):"
        grep '^\s*\*' <<<"$output" | sed 's/^/      /'
    else
        pass "all stow packages link cleanly"
    fi

    local link stale=0
    while IFS= read -r link; do
        [[ "$(readlink "$link")" == *dotfiles/* && ! -e "$link" ]] || continue
        fail "stale link: $link"
        stale=1
    done < <(list_home_links)
    [[ $stale -eq 0 ]] && pass "no stale links into the repository"
}

check_repo_clean() {
    section "Repository"
    local changes
    changes="$(git -C "$DOTFILES_DIR" status --porcelain)"
    if [[ -n "$changes" ]]; then
        warn "uncommitted changes (an installer may have edited a linked file):"
        while IFS= read -r line; do echo "      $line"; done <<<"$changes"
    else
        pass "working tree is clean"
    fi
}

# Run in a fresh interactive zsh so the result matches what you get in a terminal.
check_path_order() {
    section "PATH"
    local prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"
    local tool resolved
    for tool in git rsync python3 node; do
        resolved="$(DOTFILES_NO_TMUX=1 zsh -i -c "whence -p $tool" 2>/dev/null)"
        case "$resolved" in
        "") warn "$tool not found" ;;
        /usr/bin/* | /bin/*) fail "$tool resolves to the macOS copy: $resolved" ;;
        *) pass "$tool → $resolved" ;;
        esac
    done
    [[ ":$PATH:" == *":$prefix/bin:"* ]] || warn "$prefix/bin is not on PATH in this shell"
}

check_startup_time() {
    section "Shell startup"
    local start end elapsed_ms
    start="$(perl -MTime::HiRes=time -e 'printf "%d", time * 1000')"
    DOTFILES_NO_TMUX=1 zsh -i -c exit &>/dev/null
    end="$(perl -MTime::HiRes=time -e 'printf "%d", time * 1000')"
    elapsed_ms=$((end - start))
    if [[ $elapsed_ms -gt $MAX_STARTUP_MS ]]; then
        warn "interactive zsh starts in ${elapsed_ms}ms (target < ${MAX_STARTUP_MS}ms)"
    else
        pass "interactive zsh starts in ${elapsed_ms}ms"
    fi
}

check_configs() {
    section "Configs"
    local file
    for file in "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zshrc" "$HOME"/.config/zsh/*.zsh; do
        expect "zsh syntax: ${file#"$HOME"/}" "run zsh -n $file" zsh -n "$file"
    done
    has_cmd ghostty && expect "ghostty config" "run ghostty +validate-config" ghostty +validate-config
    has_cmd tmux && expect "tmux config" "run tmux source-file -n ~/.tmux.conf" \
        tmux -L doctor -f /dev/null start-server \; source-file -n "$HOME/.tmux.conf" \; kill-server
    has_cmd yazi && expect "yazi config" "run yazi --version" yazi --version
    expect "aerospace config" "missing at ~/.config/aerospace/aerospace.toml" test -f "$HOME/.config/aerospace/aerospace.toml"
}

check_brewfile() {
    section "Brewfile"
    if ! has_cmd brew; then
        fail "Homebrew is not installed"
        return
    fi
    if brew bundle check --no-upgrade --file="$DOTFILES_DIR/Brewfile" &>/dev/null; then
        pass "everything in the Brewfile is installed"
    else
        fail "missing Brewfile entries (see: brew bundle check --verbose --file=$DOTFILES_DIR/Brewfile)"
    fi
    local undeclared
    undeclared="$(brew bundle cleanup --file="$DOTFILES_DIR/Brewfile" 2>/dev/null | grep -vE '^(Would|Run )')"
    if [[ -n "$undeclared" ]]; then
        warn "installed but not declared in the Brewfile:"
        fold -s -w 90 <<<"$undeclared" | sed 's/^/      /'
    else
        pass "nothing installed outside the Brewfile"
    fi
}

check_git_identity() {
    section "Git identity"
    local file email
    for file in personal work; do
        if [[ -f "$HOME/.config/git/$file.gitconfig" ]]; then
            pass "$file identity: .config/git/$file.gitconfig"
        else
            warn "$file identity missing: create .config/git/$file.gitconfig (see docs/guide/git.md)"
        fi
    done
    email="$(git -C "$DOTFILES_DIR" config user.email)"
    if [[ -n "$email" ]]; then
        pass "this repository commits as $email"
    else
        fail "no identity for this repository"
    fi
}

check_runtimes() {
    section "Runtimes"
    expect "mise doctor" "run mise doctor" mise doctor
    expect "rust toolchain" "run rustup default stable" rustup default
}

main() {
    echo -e "${BOLD}🩺 Dotfiles doctor${NC}"
    check_links
    check_repo_clean
    check_path_order
    check_startup_time
    check_configs
    check_brewfile
    check_git_identity
    check_runtimes

    echo ""
    if [[ $FAILURES -gt 0 ]]; then
        echo -e "${RED}$FAILURES problem(s), $WARNINGS warning(s)${NC}"
        return 1
    fi
    echo -e "${GREEN}Healthy${NC} ($WARNINGS warning(s))"
}

main "$@"
