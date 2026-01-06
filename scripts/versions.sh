#!/bin/bash
# Version detection and display utilities

# =============================================================================
# Version Detection
# =============================================================================

get_version() {
    local tool="$1"
    case "$tool" in
        bun)         [[ -f "$HOME/.bun/bin/bun" ]] && "$HOME/.bun/bin/bun" --version 2>/dev/null ;;
        goose)       has_cmd goose && goose --version 2>/dev/null | tr -d ' ' ;;
        llm)         has_cmd llm && llm --version 2>/dev/null | awk '{print $3}' ;;
        repgrep)     has_cmd rgr && cargo install --list 2>/dev/null | awk '/^repgrep/{print $2}' | tr -d 'v:' ;;
        n)           has_cmd npm && npm list -g --depth=0 2>/dev/null | sed -n 's/.*n@//p' ;;
        tpm)         [[ -d "$HOME/.tmux/plugins/tpm/.git" ]] && git -C "$HOME/.tmux/plugins/tpm" rev-parse --short HEAD 2>/dev/null ;;
        yazi-flavors) [[ -d "$HOME/.config/yazi/flavors/.git" ]] && git -C "$HOME/.config/yazi/flavors" rev-parse --short HEAD 2>/dev/null ;;
        *)           get_version_by_type "$tool" ;;
    esac
}

get_version_by_type() {
    local tool="$1"
    for entry in "${TRACKED_TOOLS[@]}"; do
        IFS='|' read -r name _ type <<< "$entry"
        [[ "$name" != "$tool" ]] && continue
        case "$type" in
            uv)         uv tool list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v' ;;
            llm-plugin) has_cmd llm && llm plugins 2>/dev/null | jq -r ".[] | select(.name==\"$tool\") | .version" 2>/dev/null ;;
        esac
        return
    done
}

record_change() {
    local tool="$1" old="$2" new="$3"
    [[ "$old" == "$new" || (-z "$old" && -z "$new") ]] && return
    local status="Updated"
    [[ -z "$old" ]] && { status="New"; old="-"; }
    VERSION_CHANGES+=("$tool|$old|$new|$status")
}

track_version() {
    local tool="$1" old="$2"
    record_change "$tool" "$old" "$(get_version "$tool")"
}

# =============================================================================
# Version Display (--versions command)
# =============================================================================

readonly VERSION_GROUPS="brew|cask|uv|cargo|llm|git|other|all"

show_version_group_menu() {
    echo -e "\n${BOLD}Select a group to view:${NC}\n"
    echo -e "  ${GREEN}brew${NC}   - Homebrew Formulae"
    echo -e "  ${GREEN}cask${NC}   - Homebrew Casks"
    echo -e "  ${GREEN}uv${NC}     - UV Tools (Python)"
    echo -e "  ${GREEN}cargo${NC}  - Cargo Packages (Rust)"
    echo -e "  ${GREEN}llm${NC}    - LLM Plugins"
    echo -e "  ${GREEN}git${NC}    - Git Repositories"
    echo -e "  ${GREEN}other${NC}  - Other Tools (bun, n, goose)"
    echo -e "  ${GREEN}all${NC}    - All groups"
    echo ""
    echo -e "Usage: ${BOLD}./install.sh --versions <group>${NC}"
    echo ""
}

# Helper to collect versions from a command
collect_versions() {
    local cmd="$1"
    local -a items=()
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == " "* || "$line" == -* ]] && continue
        items+=("$line")
    done < <(eval "$cmd" 2>/dev/null)
    printf '%s\n' "${items[@]}"
}

get_brew_versions() {
    local -a items=()
    if has_cmd brew; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(brew list --formula --versions 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🍺" "Homebrew Formulae (${#items[@]})" "${items[@]}"
}

get_cask_versions() {
    local -a items=()
    if has_cmd brew; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(brew list --cask --versions 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🖥️" "Homebrew Casks (${#items[@]})" "${items[@]}"
}

get_uv_versions() {
    local -a items=()
    if has_cmd uv; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == -* ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}' | tr -d 'v')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(uv tool list 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🐍" "UV Tools (${#items[@]})" "${items[@]}"
}

get_cargo_versions() {
    local -a items=()
    if has_cmd cargo; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == " "* ]] && continue
            local name ver
            name=$(echo "$line" | awk -F' v' '{print $1}')
            ver=$(echo "$line" | awk -F' v' '{print $2}' | tr -d ':')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(cargo install --list 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🦀" "Cargo Packages (${#items[@]})" "${items[@]}"
}

get_llm_versions() {
    local -a items=()
    if has_cmd llm && has_cmd jq; then
        while IFS= read -r line; do
            [[ -n "$line" ]] && items+=("$line")
        done < <(llm plugins 2>/dev/null | jq -r '.[] | "\(.name)|\(.version)"' 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🤖" "LLM Plugins (${#items[@]})" "${items[@]}"
}

get_git_versions() {
    local -a items=()
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    local yazi_dir="$HOME/.config/yazi/flavors"
    
    [[ -d "$tpm_dir/.git" ]] && items+=("tpm|$(git -C "$tpm_dir" rev-parse --short HEAD 2>/dev/null)")
    [[ -d "$yazi_dir/.git" ]] && items+=("yazi-flavors|$(git -C "$yazi_dir" rev-parse --short HEAD 2>/dev/null)")
    
    [[ ${#items[@]} -gt 0 ]] && print_section "📦" "Git Repositories (${#items[@]})" "${items[@]}"
}

get_other_versions() {
    local -a items=()
    
    [[ -f "$HOME/.bun/bin/bun" ]] && items+=("bun|$("$HOME/.bun/bin/bun" --version 2>/dev/null)")
    has_cmd npm && {
        local n_ver
        n_ver=$(npm list -g --depth=0 2>/dev/null | sed -n 's/.*n@//p')
        [[ -n "$n_ver" ]] && items+=("n|$n_ver")
    }
    has_cmd goose && items+=("goose|$(goose --version 2>/dev/null | tr -d ' ')")
    
    [[ ${#items[@]} -gt 0 ]] && print_section "⚙️" "Other Tools (${#items[@]})" "${items[@]}"
}

show_installed_versions() {
    local group="${1:-}"
    
    if [[ -z "$group" ]]; then
        show_version_group_menu
        return 0
    fi
    
    echo -e "\n${BOLD}Installed Tool Versions${NC}\n"
    
    case "$group" in
        brew)  get_brew_versions ;;
        cask)  get_cask_versions ;;
        uv)    get_uv_versions ;;
        cargo) get_cargo_versions ;;
        llm)   get_llm_versions ;;
        git)   get_git_versions ;;
        other) get_other_versions ;;
        all)
            get_brew_versions
            get_cask_versions
            get_uv_versions
            get_cargo_versions
            get_llm_versions
            get_git_versions
            get_other_versions
            ;;
        *)
            echo -e "${RED}Unknown group: $group${NC}"
            echo -e "Valid groups: ${GREEN}${VERSION_GROUPS}${NC}"
            return 1
            ;;
    esac
}

print_version_summary() {
    [[ ${#VERSION_CHANGES[@]} -eq 0 ]] && { log_info "No version changes detected."; return; }
    
    local -a changes=()
    for entry in "${VERSION_CHANGES[@]}"; do
        IFS='|' read -r _ _ _ status <<< "$entry"
        [[ "$status" == "New" || "$status" == "Updated" ]] && changes+=("$entry")
    done
    
    [[ ${#changes[@]} -eq 0 ]] && { log_info "No version changes detected."; return; }

    local w_tool=6 w_prev=10 w_new=9 w_status=8
    for entry in "${changes[@]}"; do
        IFS='|' read -r tool old new status <<< "$entry"
        (( ${#tool} + 2 > w_tool )) && w_tool=$((${#tool} + 2))
        (( ${#old} + 2 > w_prev )) && w_prev=$((${#old} + 2))
        (( ${#new} + 2 > w_new )) && w_new=$((${#new} + 2))
        (( ${#status} + 2 > w_status )) && w_status=$((${#status} + 2))
    done

    local rows=""
    for entry in "${changes[@]}"; do rows+="$entry;"; done
    
    draw_table \
        --title "📊 Version Changes Summary:" \
        --headers "Tool,Previous,Current,Status" \
        --widths "$w_tool,$w_prev,$w_new,$w_status" \
        --rows "${rows%;}"
}
