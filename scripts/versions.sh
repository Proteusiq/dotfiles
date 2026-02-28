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
        done <<< "$uv_tools"
        [[ "$uv_has_outdated" == false ]] && echo -e "  ${GREEN}All up to date${NC}"
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

update_all() {
    echo -e "${BOLD}Updating all packages...${NC}\n"
    
    # Homebrew
    if has_cmd brew; then
        echo -e "${CYAN}Updating Homebrew...${NC}"
        brew update --quiet
        
        echo -e "${CYAN}Upgrading formulae...${NC}"
        brew upgrade --formula 2>&1 | grep -v "^$" || echo -e "  ${GREEN}All formulae up to date${NC}"
        
        echo -e "${CYAN}Upgrading casks...${NC}"
        brew upgrade --cask 2>&1 | grep -v "^$" || echo -e "  ${GREEN}All casks up to date${NC}"
        echo ""
    fi
    
    # UV tools
    if has_cmd uv; then
        echo -e "${CYAN}Upgrading UV tools...${NC}"
        uv tool list 2>/dev/null | grep -v "^-" | awk '{print $1}' | while read -r tool; do
            [[ -z "$tool" ]] && continue
            uv tool upgrade "$tool" 2>&1 | grep -v "^$" || true
        done
        echo ""
    fi
    
    # Cargo
    if has_cmd cargo; then
        echo -e "${CYAN}Upgrading Cargo packages...${NC}"
        # Only update packages we explicitly track
        for pkg in repgrep; do
            if cargo install --list 2>/dev/null | grep -q "^$pkg "; then
                cargo install "$pkg" 2>&1 | tail -1
            fi
        done
        echo ""
    fi
    
    # Git repos
    echo -e "${CYAN}Updating git repos...${NC}"
    [[ -d "$HOME/.tmux/plugins/tpm" ]] && {
        echo -n "  tpm: "
        git -C "$HOME/.tmux/plugins/tpm" pull --quiet 2>&1 && echo -e "${GREEN}updated${NC}" || echo -e "${YELLOW}unchanged${NC}"
    }
    [[ -d "$HOME/.config/yazi/flavors" ]] && {
        echo -n "  yazi-flavors: "
        git -C "$HOME/.config/yazi/flavors" pull --quiet 2>&1 && echo -e "${GREEN}updated${NC}" || echo -e "${YELLOW}unchanged${NC}"
    }
    echo ""
    
    # Cleanup
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

# Update a single tool using the appropriate package manager
update_tool() {
    local tool="$1"
    local source=""
    
    # Detect package manager
    if has_cmd brew && brew list --formula "$tool" &>/dev/null; then
        source="brew"
    elif has_cmd brew && brew list --cask "$tool" &>/dev/null; then
        source="cask"
    elif has_cmd uv && uv tool list 2>/dev/null | grep -q "^$tool "; then
        source="uv"
    elif has_cmd cargo && cargo install --list 2>/dev/null | grep -q "^$tool "; then
        source="cargo"
    elif has_cmd npm && npm list -g --depth=0 2>/dev/null | grep -q " $tool@"; then
        source="npm"
    elif [[ "$tool" == "bun" && -f "$HOME/.bun/bin/bun" ]]; then
        source="bun"
    elif [[ "$tool" == "snowsql" && -f "/Applications/SnowSQL.app/Contents/MacOS/snowsql" ]]; then
        source="snowsql"
    elif [[ "$tool" == "tpm" && -d "$HOME/.tmux/plugins/tpm" ]]; then
        source="git-tpm"
    elif [[ "$tool" == "yazi-flavors" && -d "$HOME/.config/yazi/flavors" ]]; then
        source="git-yazi"
    fi
    
    if [[ -z "$source" ]]; then
        echo -e "${RED}Tool '$tool' not found${NC}"
        echo -e "${DIM}Searched: brew, cask, uv, cargo, npm, bun, snowsql${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Updating${NC} ${BOLD}$tool${NC} ${DIM}($source)${NC}"
    
    # Get version before update
    local old_ver=""
    case "$source" in
        brew)      old_ver=$(brew list --formula --versions "$tool" 2>/dev/null | awk '{print $2}') ;;
        cask)      old_ver=$(brew list --cask --versions "$tool" 2>/dev/null | awk '{print $2}') ;;
        uv)        old_ver=$(uv tool list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v') ;;
        cargo)     old_ver=$(cargo install --list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v:') ;;
        npm)       old_ver=$(npm list -g --depth=0 2>/dev/null | sed -n "s/.*$tool@//p") ;;
        bun)       old_ver=$("$HOME/.bun/bin/bun" --version 2>/dev/null) ;;
        snowsql)   old_ver=$(/Applications/SnowSQL.app/Contents/MacOS/snowsql -v 2>/dev/null | awk '{print $2}') ;;
        git-tpm)   old_ver=$(git -C "$HOME/.tmux/plugins/tpm" rev-parse --short HEAD 2>/dev/null) ;;
        git-yazi)  old_ver=$(git -C "$HOME/.config/yazi/flavors" rev-parse --short HEAD 2>/dev/null) ;;
    esac
    
    # Run update command
    local rc=0
    case "$source" in
        brew)
            brew upgrade "$tool" 2>&1 || rc=$?
            ;;
        cask)
            brew upgrade --cask "$tool" 2>&1 || rc=$?
            ;;
        uv)
            uv tool upgrade "$tool" 2>&1 || rc=$?
            ;;
        cargo)
            cargo install "$tool" 2>&1 || rc=$?
            ;;
        npm)
            npm update -g "$tool" 2>&1 || rc=$?
            ;;
        bun)
            "$HOME/.bun/bin/bun" upgrade 2>&1 || rc=$?
            ;;
        snowsql)
            local snowsql_pkg="/tmp/snowsql.pkg"
            curl -fsSL -o "$snowsql_pkg" \
                "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/darwin_x86_64/snowsql-1.3.2-darwin_x86_64.pkg" 2>&1 || rc=$?
            if [[ $rc -eq 0 ]]; then
                installer -pkg "$snowsql_pkg" -target CurrentUserHomeDirectory 2>&1 || rc=$?
                rm -f "$snowsql_pkg"
            fi
            ;;
        git-tpm)
            git -C "$HOME/.tmux/plugins/tpm" pull --quiet 2>&1 || rc=$?
            ;;
        git-yazi)
            git -C "$HOME/.config/yazi/flavors" pull --quiet 2>&1 || rc=$?
            ;;
    esac
    
    if [[ $rc -ne 0 ]]; then
        echo -e "${RED}Update failed${NC}"
        return $rc
    fi
    
    # Get version after update
    local new_ver=""
    case "$source" in
        brew)      new_ver=$(brew list --formula --versions "$tool" 2>/dev/null | awk '{print $2}') ;;
        cask)      new_ver=$(brew list --cask --versions "$tool" 2>/dev/null | awk '{print $2}') ;;
        uv)        new_ver=$(uv tool list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v') ;;
        cargo)     new_ver=$(cargo install --list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v:') ;;
        npm)       new_ver=$(npm list -g --depth=0 2>/dev/null | sed -n "s/.*$tool@//p") ;;
        bun)       new_ver=$("$HOME/.bun/bin/bun" --version 2>/dev/null) ;;
        snowsql)   new_ver=$(/Applications/SnowSQL.app/Contents/MacOS/snowsql -v 2>/dev/null | awk '{print $2}') ;;
        git-tpm)   new_ver=$(git -C "$HOME/.tmux/plugins/tpm" rev-parse --short HEAD 2>/dev/null) ;;
        git-yazi)  new_ver=$(git -C "$HOME/.config/yazi/flavors" rev-parse --short HEAD 2>/dev/null) ;;
    esac
    
    # Report result
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
    
    # Check Homebrew formula
    if has_cmd brew && brew list --formula "$tool" &>/dev/null; then
        found=true
        source="brew"
        version=$(brew list --formula --versions "$tool" 2>/dev/null | awk '{print $2}')
        [[ -z "$description" ]] && description=$(brew info "$tool" 2>/dev/null | sed -n '2p')
    # Check Homebrew cask
    elif has_cmd brew && brew list --cask "$tool" &>/dev/null; then
        found=true
        source="cask"
        version=$(brew list --cask --versions "$tool" 2>/dev/null | awk '{print $2}')
        if [[ -z "$description" ]]; then
            description=$(brew info --cask --json=v2 "$tool" 2>/dev/null | jq -r '.casks[0].desc // empty' 2>/dev/null)
            [[ -z "$description" ]] && description="macOS application"
        fi
    # Check UV tools
    elif has_cmd uv && uv tool list 2>/dev/null | grep -q "^$tool "; then
        found=true
        source="uv"
        version=$(uv tool list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v')
        if [[ -z "$description" ]]; then
            description=$(curl -s "https://pypi.org/pypi/$tool/json" 2>/dev/null | jq -r '.info.summary // empty' 2>/dev/null)
            [[ -z "$description" ]] && description="Python tool installed via uv"
        fi
    # Check Cargo
    elif has_cmd cargo && cargo install --list 2>/dev/null | grep -q "^$tool "; then
        found=true
        source="cargo"
        version=$(cargo install --list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v:')
        [[ -z "$description" ]] && description=$(cargo search "$tool" --limit 1 2>/dev/null | head -1 | sed 's/.*# //' | sed 's/"$//' || echo "Rust package")
    # Check npm global
    elif has_cmd npm && npm list -g --depth=0 2>/dev/null | grep -q " $tool@"; then
        found=true
        source="npm"
        version=$(npm list -g --depth=0 2>/dev/null | sed -n "s/.*$tool@//p")
        [[ -z "$description" ]] && description=$(npm info "$tool" description 2>/dev/null || echo "Node.js package")
    # Check special tools
    elif [[ "$tool" == "bun" && -f "$HOME/.bun/bin/bun" ]]; then
        found=true
        source="standalone"
        version=$("$HOME/.bun/bin/bun" --version 2>/dev/null)
        [[ -z "$description" ]] && description="All-in-one JavaScript runtime & toolkit"
    elif [[ "$tool" == "snowsql" && -f "/Applications/SnowSQL.app/Contents/MacOS/snowsql" ]]; then
        found=true
        source="standalone"
        version=$(/Applications/SnowSQL.app/Contents/MacOS/snowsql -v 2>/dev/null | awk '{print $2}')
        [[ -z "$description" ]] && description="Snowflake command-line client"
    elif [[ "$tool" == "tpm" && -d "$HOME/.tmux/plugins/tpm" ]]; then
        found=true
        source="git"
        version=$(git -C "$HOME/.tmux/plugins/tpm" rev-parse --short HEAD 2>/dev/null)
        [[ -z "$description" ]] && description="Tmux Plugin Manager"
    elif [[ "$tool" == "yazi-flavors" && -d "$HOME/.config/yazi/flavors" ]]; then
        found=true
        source="git"
        version=$(git -C "$HOME/.config/yazi/flavors" rev-parse --short HEAD 2>/dev/null)
        [[ -z "$description" ]] && description="Color schemes for Yazi file manager"
    fi
    
    if [[ "$found" == false ]]; then
        echo -e "${RED}Tool '$tool' not found${NC}"
        echo -e "${DIM}Searched: brew, cask, uv, cargo, npm${NC}"
        return 1
    fi
    
    # Display info box - simpler approach with fixed strings
    local w=58  # Inner content width
    
    # Pad string to width
    pad() {
        local str="$1" len="$2"
        printf "%-${len}s" "$str"
    }
    
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

get_version() {
    local tool="$1"
    case "$tool" in
        bun)         [[ -f "$HOME/.bun/bin/bun" ]] && "$HOME/.bun/bin/bun" --version 2>/dev/null ;;
        snowsql)     [[ -f "/Applications/SnowSQL.app/Contents/MacOS/snowsql" ]] && /Applications/SnowSQL.app/Contents/MacOS/snowsql -v 2>/dev/null | awk '{print $2}' ;;
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

readonly VERSION_GROUPS="brew|cask|uv|cargo|git|other"

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
    
    # Other tools
    if [[ -z "$filter" || "$filter" == "other" ]]; then
        [[ -f "$HOME/.bun/bin/bun" ]] && echo "other|bun|$("$HOME/.bun/bin/bun" --version 2>/dev/null)"
        has_cmd npm && {
            local n_ver
            n_ver=$(npm list -g --depth=0 2>/dev/null | sed -n 's/.*n@//p')
            [[ -n "$n_ver" ]] && echo "other|n|$n_ver"
        }
        [[ -f "/Applications/SnowSQL.app/Contents/MacOS/snowsql" ]] && echo "other|snowsql|$(/Applications/SnowSQL.app/Contents/MacOS/snowsql -v 2>/dev/null | awk '{print $2}')"
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
    
    [[ ${#rows[@]} -eq 0 ]] && { echo -e "${YELLOW}No tools found${NC}"; return; }
    
    # Calculate column widths
    local w_group=7 w_tool=6 w_ver=9
    for row in "${rows[@]}"; do
        IFS='|' read -r grp name ver <<< "$row"
        (( ${#grp} + 2 > w_group )) && w_group=$((${#grp} + 2))
        (( ${#name} + 2 > w_tool )) && w_tool=$((${#name} + 2))
        (( ${#ver} + 2 > w_ver )) && w_ver=$((${#ver} + 2))
    done
    
    local hc="─" vc="│"
    local total_w=$((w_group + w_tool + w_ver + 4))
    
    # Title
    local title="Installed Tools"
    [[ -n "$filter" ]] && title="Installed Tools ($filter)"
    echo -e "\n${BOLD}$title${NC} (${#rows[@]} packages)\n"
    
    # Top border
    printf "${BLUE}┌%${w_group}s┬%${w_tool}s┬%${w_ver}s┐${NC}\n" "" "" "" | tr ' ' "$hc"
    
    # Header
    printf "${BLUE}${vc}${NC} ${BOLD}%-$((w_group-1))s${NC}${BLUE}${vc}${NC} ${BOLD}%-$((w_tool-1))s${NC}${BLUE}${vc}${NC} ${BOLD}%-$((w_ver-1))s${NC}${BLUE}${vc}${NC}\n" "Group" "Tool" "Version"
    
    # Header separator
    printf "${BLUE}├%${w_group}s┼%${w_tool}s┼%${w_ver}s┤${NC}\n" "" "" "" | tr ' ' "$hc"
    
    # Data rows
    local prev_group=""
    for row in "${rows[@]}"; do
        IFS='|' read -r grp name ver <<< "$row"
        # Show group only on first occurrence
        local display_grp="$grp"
        [[ "$grp" == "$prev_group" ]] && display_grp=""
        prev_group="$grp"
        printf "${BLUE}${vc}${NC} ${YELLOW}%-$((w_group-1))s${NC}${BLUE}${vc}${NC} %-$((w_tool-1))s${BLUE}${vc}${NC} ${GREEN}%-$((w_ver-1))s${NC}${BLUE}${vc}${NC}\n" "$display_grp" "$name" "$ver"
    done
    
    # Bottom border
    printf "${BLUE}└%${w_group}s┴%${w_tool}s┴%${w_ver}s┘${NC}\n" "" "" "" | tr ' ' "$hc"
    echo ""
}

show_installed_versions() {
    local group="${1:-}"
    
    # Validate group if specified
    if [[ -n "$group" ]]; then
        case "$group" in
            brew|cask|uv|cargo|git|other) ;;
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
        IFS='|' read -r _ _ _ status <<< "$entry"
        [[ "$status" == "New" || "$status" == "Updated" ]] && changes+=("$entry")
    done
    
    [[ ${#changes[@]} -eq 0 ]] && return

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
    
    # Always show version changes table (not just in verbose mode)
    echo ""
    echo -e "${GREEN}📊 Version Changes:${NC}"
    echo ""
    
    draw_table \
        --headers "Tool,Previous,Current,Status" \
        --widths "$w_tool,$w_prev,$w_new,$w_status" \
        --rows "${rows%;}"
}
