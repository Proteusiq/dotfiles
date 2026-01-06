#!/bin/bash
# UI utilities - table drawing and formatting

# =============================================================================
# Table Drawing
# =============================================================================

draw_table() {
    local -a headers=() widths=() rows=()
    local title=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --title)   title="$2"; shift 2 ;;
            --headers) IFS=',' read -ra headers <<< "$2"; shift 2 ;;
            --widths)  IFS=',' read -ra widths <<< "$2"; shift 2 ;;
            --rows)    IFS=';' read -ra rows <<< "$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    [[ ${#rows[@]} -eq 0 ]] && return 1

    local hc="─" vc="│" tl="┌" tr="┐" bl="└" br="┘" ml="├" mr="┤" tm="┬" bm="┴" xc="┼"

    draw_hline() {
        local l="$1" m="$2" r="$3"
        local last_idx=$((${#widths[@]} - 1))
        local idx=0
        printf "${BLUE}%s" "$l"
        for w in "${widths[@]}"; do
            printf '%*s' "$w" '' | tr ' ' "$hc"
            [[ $idx -lt $last_idx ]] && printf "%s" "$m"
            ((idx++))
        done
        printf "%s${NC}\n" "$r"
    }

    draw_row() {
        local -a cells
        IFS='|' read -ra cells <<< "$1"
        local colors=("${@:2}")
        printf "${BLUE}%s${NC}" "$vc"
        for i in "${!cells[@]}"; do
            local color="${colors[$i]:-$NC}"
            printf " ${color}%-*s${NC}${BLUE}%s${NC}" "$((${widths[$i]} - 2))" "${cells[$i]}" "$vc"
        done
        printf "\n"
    }

    [[ -n "$title" ]] && { echo ""; echo -e "${GREEN}$title${NC}"; echo ""; }
    
    draw_hline "$tl" "$tm" "$tr"
    
    local header_str="" hdr
    for hdr in "${headers[@]}"; do header_str+="$hdr|"; done
    draw_row "${header_str%|}" "$BOLD" "$BOLD" "$BOLD" "$BOLD"
    
    draw_hline "$ml" "$xc" "$mr"
    
    for row in "${rows[@]}"; do
        IFS='|' read -r _ _ _ status <<< "$row"
        local sc="$NC"
        [[ "$status" == "New" ]] && sc="$GREEN"
        [[ "$status" == "Updated" ]] && sc="$YELLOW"
        draw_row "$row" "$NC" "$RED" "$GREEN" "$sc"
    done
    
    draw_hline "$bl" "$bm" "$br"
    echo ""
}

print_section() {
    local icon="$1" title="$2"
    shift 2
    local -a items=()
    [[ $# -gt 0 ]] && items=("$@")
    
    [[ ${#items[@]} -eq 0 ]] && return
    
    # Calculate max widths
    local w1=4 w2=7
    for item in "${items[@]}"; do
        IFS='|' read -r name ver <<< "$item"
        (( ${#name} > w1 )) && w1=${#name}
        (( ${#ver} > w2 )) && w2=${#ver}
    done
    ((w1 += 2)); ((w2 += 2))
    
    local hc="─" vc="│"
    
    # Section header
    echo -e "${BOLD}${icon} ${title}${NC}"
    
    # Top border
    printf "${BLUE}┌%${w1}s┬%${w2}s┐${NC}\n" "" "" | tr ' ' "$hc"
    
    # Column headers
    printf "${BLUE}${vc}${NC} ${BOLD}%-$((w1-1))s${NC}${BLUE}${vc}${NC} ${BOLD}%-$((w2-1))s${NC}${BLUE}${vc}${NC}\n" "Tool" "Version"
    
    # Separator
    printf "${BLUE}├%${w1}s┼%${w2}s┤${NC}\n" "" "" | tr ' ' "$hc"
    
    # Data rows
    for item in "${items[@]}"; do
        IFS='|' read -r name ver <<< "$item"
        printf "${BLUE}${vc}${NC} %-$((w1-1))s${BLUE}${vc}${NC} ${GREEN}%-$((w2-1))s${NC}${BLUE}${vc}${NC}\n" "$name" "$ver"
    done
    
    # Bottom border
    printf "${BLUE}└%${w1}s┴%${w2}s┘${NC}\n" "" "" | tr ' ' "$hc"
    echo ""
}
