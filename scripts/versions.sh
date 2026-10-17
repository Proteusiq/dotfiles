#!/bin/bash
# Version detection and display utilities

# =============================================================================
# Outdated Tools (--outdated command)
# =============================================================================

show_outdated() {
    echo -e "${BOLD}Checking for outdated packages...${NC}\n"

    local has_outdated=false

    # Homebrew formulae
    if has_cmd brew; then
        echo -e "${CYAN}Homebrew formulae:${NC}"
        local brew_outdated
        brew_outdated=$(brew outdated --formula 2>/dev/null)
        if [[ -n "$brew_outdated" ]]; then
            has_outdated=true
            echo "$brew_outdated" | while read -r line; do
                echo -e "  ${YELLOW}$line${NC}"
            done
        else
            echo -e "  ${GREEN}All up to date${NC}"
        fi
        echo ""

        echo -e "${CYAN}Homebrew casks:${NC}"
        local cask_outdated
        cask_outdated=$(brew outdated --cask 2>/dev/null)
        if [[ -n "$cask_outdated" ]]; then
            has_outdated=true
            echo "$cask_outdated" | while read -r line; do
                echo -e "  ${YELLOW}$line${NC}"
            done
        else
            echo -e "  ${GREEN}All up to date${NC}"
        fi
        echo ""
    fi

    # UV tools
    if has_cmd uv; then
        echo -e "${CYAN}UV tools:${NC}"
        # uv doesn't have a built-in outdated check, so we check PyPI
        local uv_tools
        uv_tools=$(uv tool list 2>/dev/null | grep -v "^-" | awk '{print $1, $2}')
        local uv_has_outdated=false
        while read -r name ver; do
            [[ -z "$name" ]] && continue
            ver=$(echo "$ver" | tr -d 'v')
            local latest
            latest=$(curl -s "https://pypi.org/pypi/$name/json" 2>/dev/null | jq -r '.info.version // empty' 2>/dev/null)
            if [[ -n "$latest" && "$ver" != "$latest" ]]; then
                has_outdated=true
                uv_has_outdated=true
                echo -e "  ${YELLOW}$name $ver → $latest${NC}"
            fi
        done <<<"$uv_tools"
        [[ "$uv_has_outdated" == false ]] && echo -e "  ${GREEN}All up to date${NC}"
        echo ""
    fi

    # mise runtimes
    if has_cmd mise; then
        echo -e "${CYAN}mise runtimes:${NC}"
        local mise_outdated
        mise_outdated=$(mise outdated --no-header 2>/dev/null)
        if [[ -n "$mise_outdated" ]]; then
            has_outdated=true
            echo "$mise_outdated" | while read -r line; do
                echo -e "  ${YELLOW}$line${NC}"
            done
        else
            echo -e "  ${GREEN}All up to date${NC}"
        fi
        echo ""
    fi

    # Summary
    if [[ "$has_outdated" == true ]]; then
        echo -e "${DIM}Run 'update --all' to update everything, or 'update <tool>' for specific tools${NC}"
    else
        echo -e "${GREEN}Everything is up to date!${NC}"
    fi
}

# =============================================================================
# Update All (--all command)
# =============================================================================

# Cargo crates declared in the Brewfile, e.g. `cargo "repgrep"`
brewfile_cargo_crates() {
    sed -nE 's/^cargo "([^"]+)".*/\1/p' "$DOTFILES_DIR/Brewfile"
}

update_all() {
    echo -e "${BOLD}Updating all packages...${NC}\n"

    if has_cmd brew; then
        echo -e "${CYAN}Updating Homebrew...${NC}"
        brew update --quiet
        echo -e "${CYAN}Upgrading formulae and casks...${NC}"
        brew upgrade 2>&1 | grep -v "^$" || echo -e "  ${GREEN}All up to date${NC}"
        echo ""
    fi

    if has_cmd uv; then
        echo -e "${CYAN}Upgrading uv tools...${NC}"
        uv tool upgrade --all 2>&1 | grep -v "^$" || true
        echo ""
    fi

    if has_cmd cargo; then
        echo -e "${CYAN}Upgrading cargo crates...${NC}"
        local crate
        while read -r crate; do
            cargo install --locked "$crate" 2>&1 | tail -1
        done < <(brewfile_cargo_crates)
        echo ""
    fi

    if has_cmd mise; then
        echo -e "${CYAN}Upgrading mise runtimes...${NC}"
        mise upgrade 2>&1 | grep -v "^$" || true
        echo ""
    fi

    echo -e "${CYAN}Updating git repos...${NC}"
    [[ -x "$HOME/.tmux/plugins/tpm/bin/update_plugins" ]] && {
        echo -n "  tmux plugins: "
        "$HOME/.tmux/plugins/tpm/bin/update_plugins" all >/dev/null 2>&1 && echo -e "${GREEN}updated${NC}" || echo -e "${YELLOW}failed${NC}"
    }
    [[ -d "$HOME/.config/yazi/flavors" ]] && {
        echo -n "  yazi-flavors: "
        git -C "$HOME/.config/yazi/flavors" pull --ff-only --quiet 2>&1 && echo -e "${GREEN}updated${NC}" || echo -e "${YELLOW}unchanged${NC}"
    }
    echo ""

    if has_cmd brew; then
        echo -e "${CYAN}Cleaning up...${NC}"
        brew cleanup --prune=all --quiet 2>/dev/null
        brew autoremove --quiet 2>/dev/null
    fi

    echo -e "\n${GREEN}✓ All updates complete${NC}"
}

# =============================================================================
# Tool Update (update <tool> command)
# =============================================================================

# A mise tool by name (node) or by the command it provides (pi)
is_mise_tool() {
    has_cmd mise && mise which "$1" &>/dev/null
}

# Which package manager owns a tool: brew | cask | uv | cargo | mise | herdr | git-tpm | git-yazi
detect_tool_source() {
    local tool="$1"
    if has_cmd brew && brew list --formula "$tool" &>/dev/null; then
        echo brew
    elif has_cmd brew && brew list --cask "$tool" &>/dev/null; then
        echo cask
    elif has_cmd uv && uv tool list 2>/dev/null | grep -q "^$tool "; then
        echo uv
    elif has_cmd cargo && cargo install --list 2>/dev/null | grep -q "^$tool "; then
        echo cargo
    elif is_mise_tool "$tool"; then
        echo mise
    elif [[ "$tool" == "herdr" ]] && has_cmd herdr; then
        echo herdr
    elif [[ "$tool" == "tpm" && -d "$HOME/.tmux/plugins/tpm" ]]; then
        echo git-tpm
    elif [[ "$tool" == "yazi-flavors" && -d "$HOME/.config/yazi/flavors" ]]; then
        echo git-yazi
    else
        return 1
    fi
}

tool_version() {
    local tool="$1" source="$2"
    case "$source" in
    brew) brew list --formula --versions "$tool" 2>/dev/null | awk '{print $2}' ;;
    cask) brew list --cask --versions "$tool" 2>/dev/null | awk '{print $2}' ;;
    uv) uv tool list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v' ;;
    cargo) cargo install --list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v:' ;;
    mise) mise which --version "$tool" 2>/dev/null ;;
    herdr) herdr --version 2>&1 ;;
    git-tpm) git -C "$HOME/.tmux/plugins/tpm" rev-parse --short HEAD 2>/dev/null ;;
    git-yazi) git -C "$HOME/.config/yazi/flavors" rev-parse --short HEAD 2>/dev/null ;;
    esac
}

update_tool() {
    local tool="$1" source
    source="$(detect_tool_source "$tool")" || {
        echo -e "${RED}Tool '$tool' not found${NC}"
        echo -e "${DIM}Searched: brew, cask, uv, cargo, mise, herdr, tpm, yazi-flavors${NC}"
        return 1
    }

    echo -e "${BLUE}Updating${NC} ${BOLD}$tool${NC} ${DIM}($source)${NC}"
    local old_ver new_ver rc=0
    old_ver="$(tool_version "$tool" "$source")"

    case "$source" in
    brew) brew upgrade "$tool" 2>&1 || rc=$? ;;
    cask) brew upgrade --cask "$tool" 2>&1 || rc=$? ;;
    uv) uv tool upgrade "$tool" 2>&1 || rc=$? ;;
    cargo) cargo install --locked "$tool" 2>&1 || rc=$? ;;
    mise) mise upgrade "$(mise which --plugin "$tool")" 2>&1 || rc=$? ;;
    herdr) herdr update 2>&1 || rc=$? ;;
    git-tpm) git -C "$HOME/.tmux/plugins/tpm" pull --ff-only --quiet 2>&1 || rc=$? ;;
    git-yazi) git -C "$HOME/.config/yazi/flavors" pull --ff-only --quiet 2>&1 || rc=$? ;;
    esac

    if [[ $rc -ne 0 ]]; then
        echo -e "${RED}Update failed${NC}"
        return $rc
    fi

    new_ver="$(tool_version "$tool" "$source")"
    if [[ "$old_ver" == "$new_ver" ]]; then
        echo -e "${GREEN}✓${NC} $tool ${DIM}already at $new_ver${NC}"
    else
        echo -e "${GREEN}✓${NC} $tool ${DIM}$old_ver${NC} → ${GREEN}$new_ver${NC}"
    fi
}

# =============================================================================
# Tool Info (--info command)
# =============================================================================

# Detect which package manager owns a tool and get its info
get_tool_info() {
    local tool="$1"
    local found=false
    local source="" version="" description="" example="" category=""

    # Check tools.py for curated description first
    local tools_script="$DOTFILES_DIR/bin/tools.py"
    if [[ -x "$tools_script" ]]; then
        local tools_json
        tools_json=$("$tools_script" --json "$tool" 2>/dev/null)
        if [[ -n "$tools_json" ]] && has_cmd jq; then
            description=$(echo "$tools_json" | jq -r '.description // empty')
            example=$(echo "$tools_json" | jq -r '.example // empty')
            category=$(echo "$tools_json" | jq -r '.category_title // empty')
        fi
    fi

    if source="$(detect_tool_source "$tool")"; then
        found=true
        version="$(tool_version "$tool" "$source")"
    fi
    if [[ "$found" == true && -z "$description" ]]; then
        case "$source" in
        brew) description=$(brew info --json=v2 "$tool" 2>/dev/null | jq -r '.formulae[0].desc // empty') ;;
        cask) description=$(brew info --cask --json=v2 "$tool" 2>/dev/null | jq -r '.casks[0].desc // empty') ;;
        uv) description=$(curl -s "https://pypi.org/pypi/$tool/json" 2>/dev/null | jq -r '.info.summary // empty') ;;
        esac
    fi

    if [[ "$found" == false ]]; then
        echo -e "${RED}Tool '$tool' not found${NC}"
        echo -e "${DIM}Searched: brew, cask, uv, cargo, mise, herdr, tpm, yazi-flavors${NC}"
        return 1
    fi

    # Display info box
    # Truncate/pad value to fit
    fit() {
        local str="$1" len="$2"
        if [[ ${#str} -gt $len ]]; then
            echo "${str:0:$len}"
        else
            printf "%-${len}s" "$str"
        fi
    }

    local hline="───────────────────────────────────────────────────────────"

    echo ""
    echo -e "${BLUE}┌${hline}┐${NC}"
    echo -e "${BLUE}│${NC} ${BOLD}$(fit "$tool" 57)${NC} ${BLUE}│${NC}"
    echo -e "${BLUE}├${hline}┤${NC}"
    echo -e "${BLUE}│${NC} ${CYAN}Source:     ${NC} $(fit "$source" 44) ${BLUE}│${NC}"
    echo -e "${BLUE}│${NC} ${CYAN}Version:    ${NC} ${GREEN}$(fit "$version" 44)${NC} ${BLUE}│${NC}"

    # Description with word wrap (44 char width)
    local desc_w=44
    if [[ -n "$description" ]]; then
        local first=true
        local desc_copy="$description"
        while [[ ${#desc_copy} -gt 0 ]]; do
            local chunk="${desc_copy:0:$desc_w}"
            desc_copy="${desc_copy:$desc_w}"
            # Trim leading space from continuation chunks
            desc_copy="${desc_copy# }"
            if [[ "$first" == true ]]; then
                echo -e "${BLUE}│${NC} ${CYAN}Description:${NC} $(fit "$chunk" 44) ${BLUE}│${NC}"
                first=false
            else
                echo -e "${BLUE}│${NC}              $(fit "$chunk" 44) ${BLUE}│${NC}"
            fi
        done
    else
        echo -e "${BLUE}│${NC} ${CYAN}Description:${NC} $(fit "-" 44) ${BLUE}│${NC}"
    fi

    # Show example if from tools.py (curated) with word wrap
    if [[ -n "$example" ]]; then
        local first=true
        local ex_copy="$example"
        while [[ ${#ex_copy} -gt 0 ]]; do
            local chunk="${ex_copy:0:$desc_w}"
            ex_copy="${ex_copy:$desc_w}"
            ex_copy="${ex_copy# }"
            if [[ "$first" == true ]]; then
                echo -e "${BLUE}│${NC} ${CYAN}Example:    ${NC} ${GREEN}$(fit "$chunk" 44)${NC} ${BLUE}│${NC}"
                first=false
            else
                echo -e "${BLUE}│${NC}              ${GREEN}$(fit "$chunk" 44)${NC} ${BLUE}│${NC}"
            fi
        done
    fi

    # Show category if from tools.py
    if [[ -n "$category" ]]; then
        echo -e "${BLUE}│${NC} ${CYAN}Category:   ${NC} $(fit "$category" 44) ${BLUE}│${NC}"
    fi

    echo -e "${BLUE}└${hline}┘${NC}"
    echo ""
}

# =============================================================================
# Version Detection
# =============================================================================

# Version of a tool installed outside Homebrew, used for the change summary
get_version() {
    local tool="$1"
    case "$tool" in
    herdr) has_cmd herdr && herdr --version 2>&1 ;;
    tpm) [[ -d "$HOME/.tmux/plugins/tpm/.git" ]] && git -C "$HOME/.tmux/plugins/tpm" rev-parse --short HEAD 2>/dev/null ;;
    yazi-flavors) [[ -d "$HOME/.config/yazi/flavors/.git" ]] && git -C "$HOME/.config/yazi/flavors" rev-parse --short HEAD 2>/dev/null ;;
    esac
    return 0
}

record_change() {
    local tool="$1" old="$2" new="$3"
    [[ "$old" == "$new" || (-z "$old" && -z "$new") ]] && return
    local status="Updated"
    [[ -z "$old" ]] && {
        status="New"
        old="-"
    }
    VERSION_CHANGES+=("$tool|$old|$new|$status")
}

track_version() {
    local tool="$1" old="$2"
    record_change "$tool" "$old" "$(get_version "$tool")"
}

# =============================================================================
# Version Display (--versions command)
# =============================================================================

readonly VERSION_GROUPS="brew|cask|uv|cargo|mise|git|other"

# Collect all versions into a unified list: "group|name|version"
collect_all_versions() {
    local filter="${1:-}"

    # Homebrew formulae
    if [[ -z "$filter" || "$filter" == "brew" ]] && has_cmd brew; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}')
            [[ -n "$name" && -n "$ver" ]] && echo "brew|$name|$ver"
        done < <(brew list --formula --versions 2>/dev/null)
    fi

    # Homebrew casks
    if [[ -z "$filter" || "$filter" == "cask" ]] && has_cmd brew; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}')
            [[ -n "$name" && -n "$ver" ]] && echo "cask|$name|$ver"
        done < <(brew list --cask --versions 2>/dev/null)
    fi

    # UV tools
    if [[ -z "$filter" || "$filter" == "uv" ]] && has_cmd uv; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == -* ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}' | tr -d 'v')
            [[ -n "$name" && -n "$ver" ]] && echo "uv|$name|$ver"
        done < <(uv tool list 2>/dev/null)
    fi

    # Cargo packages
    if [[ -z "$filter" || "$filter" == "cargo" ]] && has_cmd cargo; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == " "* ]] && continue
            local name ver
            name=$(echo "$line" | awk -F' v' '{print $1}')
            ver=$(echo "$line" | awk -F' v' '{print $2}' | tr -d ':')
            [[ -n "$name" && -n "$ver" ]] && echo "cargo|$name|$ver"
        done < <(cargo install --list 2>/dev/null)
    fi

    # Git repos
    if [[ -z "$filter" || "$filter" == "git" ]]; then
        local tpm_dir="$HOME/.tmux/plugins/tpm"
        local yazi_dir="$HOME/.config/yazi/flavors"
        [[ -d "$tpm_dir/.git" ]] && echo "git|tpm|$(git -C "$tpm_dir" rev-parse --short HEAD 2>/dev/null)"
        [[ -d "$yazi_dir/.git" ]] && echo "git|yazi-flavors|$(git -C "$yazi_dir" rev-parse --short HEAD 2>/dev/null)"
    fi

    # mise runtimes
    if [[ -z "$filter" || "$filter" == "mise" ]] && has_cmd mise; then
        mise ls --global --json 2>/dev/null | jq -r 'to_entries[] | "mise|\(.key)|\(.value[0].version)"'
    fi

    # Other tools
    if [[ -z "$filter" || "$filter" == "other" ]]; then
        has_cmd herdr && echo "other|herdr|$(herdr --version 2>&1)"
    fi
}

# Print unified table with Group | Tool | Version columns
print_version_table() {
    local filter="${1:-}"
    local -a rows=()

    # Collect versions
    while IFS= read -r line; do
        [[ -n "$line" ]] && rows+=("$line")
    done < <(collect_all_versions "$filter")

    [[ ${#rows[@]} -eq 0 ]] && {
        echo -e "${YELLOW}No tools found${NC}"
        return
    }

    # Calculate column widths
    local w_group=7 w_tool=6 w_ver=9
    for row in "${rows[@]}"; do
        IFS='|' read -r grp name ver <<<"$row"
        ((${#grp} + 2 > w_group)) && w_group=$((${#grp} + 2))
        ((${#name} + 2 > w_tool)) && w_tool=$((${#name} + 2))
        ((${#ver} + 2 > w_ver)) && w_ver=$((${#ver} + 2))
    done

    local hc="─" vc="│"

    # Title
    local title="Installed Tools"
    [[ -n "$filter" ]] && title="Installed Tools ($filter)"
    echo -e "\n${BOLD}$title${NC} (${#rows[@]} packages)\n"

    # Top border
    printf "${BLUE}┌%${w_group}s┬%${w_tool}s┬%${w_ver}s┐${NC}\n" "" "" "" | tr ' ' "$hc"

    # Header
    printf "${BLUE}${vc}${NC} ${BOLD}%-$((w_group - 1))s${NC}${BLUE}${vc}${NC} ${BOLD}%-$((w_tool - 1))s${NC}${BLUE}${vc}${NC} ${BOLD}%-$((w_ver - 1))s${NC}${BLUE}${vc}${NC}\n" "Group" "Tool" "Version"

    # Header separator
    printf "${BLUE}├%${w_group}s┼%${w_tool}s┼%${w_ver}s┤${NC}\n" "" "" "" | tr ' ' "$hc"

    # Data rows
    local prev_group=""
    for row in "${rows[@]}"; do
        IFS='|' read -r grp name ver <<<"$row"
        # Show group only on first occurrence
        local display_grp="$grp"
        [[ "$grp" == "$prev_group" ]] && display_grp=""
        prev_group="$grp"
        printf "${BLUE}${vc}${NC} ${YELLOW}%-$((w_group - 1))s${NC}${BLUE}${vc}${NC} %-$((w_tool - 1))s${BLUE}${vc}${NC} ${GREEN}%-$((w_ver - 1))s${NC}${BLUE}${vc}${NC}\n" "$display_grp" "$name" "$ver"
    done

    # Bottom border
    printf "${BLUE}└%${w_group}s┴%${w_tool}s┴%${w_ver}s┘${NC}\n" "" "" "" | tr ' ' "$hc"
    echo ""
}

show_installed_versions() {
    local group="${1:-}"
    [[ "$group" == "all" ]] && group=""

    # Validate group if specified
    if [[ -n "$group" ]]; then
        case "$group" in
        brew | cask | uv | cargo | mise | git | other) ;;
        *)
            echo -e "${RED}Unknown group: $group${NC}"
            echo -e "Valid groups: ${GREEN}${VERSION_GROUPS}${NC}"
            return 1
            ;;
        esac
    fi

    # Pipe through less with colors preserved, quit if output fits on screen
    print_version_table "$group" | less -RFX
}

print_version_summary() {
    [[ ${#VERSION_CHANGES[@]} -eq 0 ]] && return

    local -a changes=()
    for entry in "${VERSION_CHANGES[@]}"; do
        IFS='|' read -r _ _ _ status <<<"$entry"
        [[ "$status" == "New" || "$status" == "Updated" ]] && changes+=("$entry")
    done

    [[ ${#changes[@]} -eq 0 ]] && return

    local w_tool=6 w_prev=10 w_new=9 w_status=8
    for entry in "${changes[@]}"; do
        IFS='|' read -r tool old new status <<<"$entry"
        ((${#tool} + 2 > w_tool)) && w_tool=$((${#tool} + 2))
        ((${#old} + 2 > w_prev)) && w_prev=$((${#old} + 2))
        ((${#new} + 2 > w_new)) && w_new=$((${#new} + 2))
        ((${#status} + 2 > w_status)) && w_status=$((${#status} + 2))
    done

    local row_list=""
    for entry in "${changes[@]}"; do row_list+="$entry;"; done

    # Always show version changes table (not just in verbose mode)
    echo ""
    echo -e "${GREEN}📊 Version Changes:${NC}"
    echo ""

    draw_table \
        --headers "Tool,Previous,Current,Status" \
        --widths "$w_tool,$w_prev,$w_new,$w_status" \
        --rows "${row_list%;}"
}
