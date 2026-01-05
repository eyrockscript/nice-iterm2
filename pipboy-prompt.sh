#!/bin/bash
# ============================================================================
#  PIP-BOY TERMINAL PROMPT - Fallout Style
#  Add this to your ~/.zshrc or ~/.bashrc:
#  source /path/to/pipboy-prompt.sh
# ============================================================================

# Get system stats (cached for performance)
_pipboy_get_stats() {
    # CPU
    if [[ "$OSTYPE" == "darwin"* ]]; then
        _PB_CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s/8}' 2>/dev/null || echo "0")
    else
        _PB_CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}' 2>/dev/null || echo "0")
    fi

    # Memory
    if [[ "$OSTYPE" == "darwin"* ]]; then
        _PB_MEM=$(ps -A -o %mem | awk '{s+=$1} END {printf "%.0f", s}' 2>/dev/null || echo "0")
    else
        _PB_MEM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}' 2>/dev/null || echo "0")
    fi

    # Disk
    _PB_DISK=$(df -h / 2>/dev/null | awk 'NR==2 {gsub(/%/,""); print $5}' || echo "0")

    # Battery
    if [[ "$OSTYPE" == "darwin"* ]]; then
        _PB_BATT=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | tr -d '%' || echo "100")
    else
        _PB_BATT=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "100")
    fi

    # Ensure numeric
    [[ ! "$_PB_CPU" =~ ^[0-9]+$ ]] && _PB_CPU=0
    [[ ! "$_PB_MEM" =~ ^[0-9]+$ ]] && _PB_MEM=0
    [[ ! "$_PB_DISK" =~ ^[0-9]+$ ]] && _PB_DISK=0
    [[ ! "$_PB_BATT" =~ ^[0-9]+$ ]] && _PB_BATT=100
}

# Progress bar (simple)
_pipboy_bar() {
    local pct=$1
    local len=10
    local filled=$((pct * len / 100))
    local empty=$((len - filled))
    printf '%.0s█' $(seq 1 $filled 2>/dev/null)
    printf '%.0s░' $(seq 1 $empty 2>/dev/null)
}

# Full Pip-Boy display
pipboy_display() {
    _pipboy_get_stats
    local user=$(whoami)
    local host=$(hostname -s)
    local G=$'\033[38;5;46m'      # Bright green
    local D=$'\033[38;5;22m'      # Dark green
    local R=$'\033[0m'            # Reset

    echo ""
    echo "${G}╔════════════════════════════════════════════════════════════════╗${R}"
    echo "${G}║${D}  STAT     INV     DATA     MAP     RADIO                      ${G}║${R}"
    echo "${G}╠════════════════════════════════════════════════════════════════╣${R}"
    echo "${G}║                                                                ║${R}"
    echo "${G}║                         ${G}██████╗ ██╗██████╗ ${D} ██████╗  ██████╗ ██╗   ██╗${G}  ║${R}"
    echo "${G}║                         ${G}██╔══██╗██║██╔══██╗${D} ██╔══██╗██╔═══██╗╚██╗ ██╔╝${G}  ║${R}"
    echo "${G}║                         ${G}██████╔╝██║██████╔╝${D} ██████╔╝██║   ██║ ╚████╔╝ ${G}  ║${R}"
    echo "${G}║                         ${G}██╔═══╝ ██║██╔═══╝ ${D} ██╔══██╗██║   ██║  ╚██╔╝  ${G}  ║${R}"
    echo "${G}║                         ${G}██║     ██║██║     ${D} ██████╔╝╚██████╔╝   ██║   ${G}  ║${R}"
    echo "${G}║                         ${G}╚═╝     ╚═╝╚═╝     ${D} ╚═════╝  ╚═════╝    ╚═╝   ${G}  ║${R}"
    echo "${G}║                                                                ║${R}"
    echo "${G}║                            ${G}⣀⣀⣀⣀⣀⣀⣀${R}                            ${G}║${R}"
    echo "${G}║                          ${G}⣿⣿⣿⣿⣿⣿⣿⣿⣿${R}                          ${G}║${R}"
    echo "${G}║                          ${G}⣿⣿${R}⬤${G}⣿⣿⣿${R}⬤${G}⣿⣿${R}                          ${G}║${R}"
    echo "${G}║                          ${G}⣿⣿⣿⣿⣿⣿⣿⣿⣿${R}                          ${G}║${R}"
    echo "${G}║                          ${G}⣿⣿⣿${R}⌣⌣⌣${G}⣿⣿⣿${R}                          ${G}║${R}"
    echo "${G}║                            ${G}⣿⣿⣿⣿⣿⣿⣿${R}                            ${G}║${R}"
    echo "${G}║                          ${G}⣿⣿${R}       ${G}⣿⣿${R}                          ${G}║${R}"
    echo "${G}║                          ${G}⣿⣿⣿⣿⣿⣿⣿⣿⣿${R}                          ${G}║${R}"
    echo "${G}║                            ${G}⣿⣿${R}   ${G}⣿⣿${R}                            ${G}║${R}"
    echo "${G}║                           ${G}⣿⣿${R}     ${G}⣿⣿${R}                           ${G}║${R}"
    echo "${G}║                                                                ║${R}"
    printf "${G}║                        ${G}%-20s${G}                    ║${R}\n" "$user@$host"
    echo "${G}║                                                                ║${R}"
    echo "${G}╠════════════════════════════════════════════════════════════════╣${R}"
    printf "${G}║  ${G}CPU ${G}%3s%% ${D}$(_pipboy_bar $_PB_CPU)${G}  MEM ${G}%3s%% ${D}$(_pipboy_bar $_PB_MEM)${G}  DISK ${G}%3s%% ${D}$(_pipboy_bar $_PB_DISK)${G} ║${R}\n" "$_PB_CPU" "$_PB_MEM" "$_PB_DISK"
    echo "${G}╠════════════════════════════════════════════════════════════════╣${R}"
    printf "${G}║  ${G}BATT ${G}%3s%%                                                   ║${R}\n" "$_PB_BATT"
    echo "${G}╚════════════════════════════════════════════════════════════════╝${R}"
    echo ""
}

# Simple prompt
pipboy_simple_prompt() {
    _pipboy_get_stats
    local dir="${PWD##*/}"
    [[ "$PWD" == "$HOME" ]] && dir="~"

    # For display
    local G=$'\033[38;5;46m'
    local D=$'\033[38;5;22m'
    local R=$'\033[0m'

    echo "${D}┌─[${G}CPU:${_PB_CPU}%${D}]─[${G}MEM:${_PB_MEM}%${D}]─[${G}DSK:${_PB_DISK}%${D}]─[${G}BAT:${_PB_BATT}%${D}]${R}"
    echo "${D}└─[${G}${dir}${D}]▶${R} "
}

# ZSH prompt
_pipboy_zsh_prompt() {
    _pipboy_get_stats
    local dir="${PWD##*/}"
    [[ "$PWD" == "$HOME" ]] && dir="~"

    # ZSH prompt colors
    local G='%F{46}'   # Green
    local D='%F{22}'   # Dark green
    local R='%f'       # Reset

    echo "${D}┌─[${G}CPU:${_PB_CPU}%%${D}]─[${G}MEM:${_PB_MEM}%%${D}]─[${G}DSK:${_PB_DISK}%%${D}]─[${G}BAT:${_PB_BATT}%%${D}]${R}"
    echo "${D}└─[${G}${dir}${D}]▶${R} "
}

# Commands
pipboy() {
    clear
    pipboy_display
}

# ============================================================================
# Shell Configuration
# ============================================================================
if [[ -n "$ZSH_VERSION" ]]; then
    setopt PROMPT_SUBST
    precmd() {
        PROMPT="$(_pipboy_zsh_prompt)"
    }
    # Show on first load
    if [[ -z "$PIPBOY_LOADED" ]]; then
        export PIPBOY_LOADED=1
        pipboy_display
    fi
elif [[ -n "$BASH_VERSION" ]]; then
    PROMPT_COMMAND='PS1="$(pipboy_simple_prompt)"'
    if [[ -z "$PIPBOY_LOADED" ]]; then
        export PIPBOY_LOADED=1
        pipboy_display
    fi
fi

alias vault='pipboy'
alias stats='pipboy_display'
