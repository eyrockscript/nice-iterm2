#!/bin/bash
# ============================================================================
#  PIP-BOY TERMINAL PROMPT - Fallout Style
#  source /path/to/pipboy-prompt.sh
# ============================================================================

# Get system stats
_pipboy_get_stats() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        _PB_CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s/8}' 2>/dev/null || echo "0")
        _PB_MEM=$(ps -A -o %mem | awk '{s+=$1} END {printf "%.0f", s}' 2>/dev/null || echo "0")
        _PB_BATT=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1 | tr -d '%' || echo "100")
    else
        _PB_CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}' 2>/dev/null || echo "0")
        _PB_MEM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}' 2>/dev/null || echo "0")
        _PB_BATT=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "100")
    fi
    _PB_DISK=$(df -h / 2>/dev/null | awk 'NR==2 {gsub(/%/,""); print $5}' || echo "0")

    [[ ! "$_PB_CPU" =~ ^[0-9]+$ ]] && _PB_CPU=0
    [[ ! "$_PB_MEM" =~ ^[0-9]+$ ]] && _PB_MEM=0
    [[ ! "$_PB_DISK" =~ ^[0-9]+$ ]] && _PB_DISK=0
    [[ ! "$_PB_BATT" =~ ^[0-9]+$ ]] && _PB_BATT=100
}

# Progress bar
_pb_bar() {
    local pct=$1 len=${2:-10}
    local filled=$((pct * len / 100))
    local empty=$((len - filled))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    echo "$bar"
}

# Full Pip-Boy display with Vault Boy
pipboy_display() {
    _pipboy_get_stats
    local user=$(whoami)
    local host=$(hostname -s)
    local G=$'\033[38;5;46m'
    local D=$'\033[38;5;22m'
    local R=$'\033[0m'

    clear
    echo ""
    cat << EOF
${G}  ╔═══════════════════════════════════════════════════════════════════════════════╗
${G}  ║${D}    STAT        INV        DATA        MAP        RADIO                        ${G}║
${G}  ╠═══════════════════════════════════════════════════════════════════════════════╣
${G}  ║                                                                               ║
${G}  ║  ${D}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠛⢶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣦⠀⣠⡾⠛⠙⠛⠋⠀⠀⠀⠈⠉⠛⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⡇⠙⠛⠋⢀⣤⣀⠀⣀⣤⣤⡀⠀⠀⠀⠈⠻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣧⡀⢀⡤⠋⠀⠈⠉⠉⠀⠉⠳⠤⠤⠴⢦⡄⠸⣷⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣀⡿⠿⠾⠀⠀⠀⠀⠀⢴⣦⡀⠀⠀⠀⣠⠟⠀⢹⡇⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠀⣴⡄⠀⢀⡄⠀⠀⣦⡈⠃⠀⠀⡾⣳⣄⠀⣼⡇⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⠀⣠⡶⠟⠻⠶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠀⠀⠿⠁⢀⡞⠁⠀⠀⣿⠗⠀⠀⠀⣟⢮⣿⣆⣿⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⢸⠏⠀⠀⠀⣰⡏⠀⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠀⠰⣯⡀⠀⠀⠀⠀⠀⠀⠀⠀⠪⣳⡵⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⢸⡀⠀⠀⢰⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣇⠀⣦⣀⠀⠈⠉⢀⣀⣰⣦⡀⠀⠀⠀⠀⠈⠉⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠀⠀⠘⣷⠀⠀⠘⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡆⠻⠦⣌⣉⣉⣁⡤⠔⠻⡇⠀⠀⠀⣀⣠⣼⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⢠⡾⠛⠉⠙⠛⠲⢦⣄⠀⠙⣦⡀⠀⠀⠀⠀⠀⠈⢿⣄⠀⠀⠲⠇⠀⠀⠀⠀⠀⠀⢀⣴⢏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⢸⣇⣀⣀⣀⡀⠀⠀⠈⣧⠀⠈⣿⣦⣄⡀⠀⠀⠀⢀⣻⣦⣄⠀⠀⠀⠀⠀⠀⡠⠔⣿⠓⢶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⢸⠟⠁⠀⠈⠉⠙⠳⢴⡏⠀⠀⣿⡇⠈⠙⠻⠶⠴⠶⠛⠋⠹⡀⠈⠻⣶⣤⣀⣠⠞⠁⠀⢸⠀⠈⠙⠳⢦⣄⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║  ${D}⠸⣧⣤⣤⣤⣤⣀⡀⠀⣷⢀⣼⠃⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⣀⠀⠉⠉⠀⠀⢀⣴⠏⠀⠀⠀⠀⠀⠉⠻⣦⣄⠀⠀⠀  ${G}║
${G}  ║  ${D}⢰⡏⠀⢠⠀⠀⠈⠉⢺⠁⢈⡞⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠒⢦⠀⢸⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⡄⠀  ${G}║
${G}  ║  ${D}⠀⠻⣦⣈⠙⠶⠤⠴⢞⣠⠞⢀⡞⠀⠀⠀⠀⠀⠀⠀⢀⣦⠀⠀⠀⠀⠀⠀⢸⠀⠈⡆⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠈⠻⣆  ${G}║
${G}  ║  ${D}⠀⠀⠈⠉⠉⠛⠛⠛⠯⢤⣤⣎⣀⠀⠀⠀⢀⣀⣠⣾⠛⠁⠀⠀⠀⠀⠀⠀⠀⡇⠀⢻⠀⠀⠀⠈⡆⠀⠀⡀⠀⠀⠀⠀⠀⠙  ${G}║
${G}  ║  ${D}⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠛⠛⠉⠉⠠⣿⠀⠀⠀⠀⠀⠀⠀⠀⢇⠀⠀⡇⠀⠀⠀⡇⠀⣰⠏⠀⠀⠀⠀⠀⠀  ${G}║
${G}  ║                                                                               ║
${G}  ╠═══════════════════════════════════════════════════════════════════════════════╣
${G}  ║                                                                               ║
${G}  ║    ${G}CPU ${D}$(_pb_bar $_PB_CPU 12) ${G}${_PB_CPU}%     ${G}MEM ${D}$(_pb_bar $_PB_MEM 12) ${G}${_PB_MEM}%     ${G}DISK ${D}$(_pb_bar $_PB_DISK 12) ${G}${_PB_DISK}%    ${G}║
${G}  ║                                                                               ║
${G}  ╠═══════════════════════════════════════════════════════════════════════════════╣
${G}  ║    ${G}BATT: ${_PB_BATT}%          ${D}USER: ${G}${user}@${host}                               ${G}║
${G}  ╚═══════════════════════════════════════════════════════════════════════════════╝${R}
EOF
    echo ""
}

# Compact Vault Boy (for smaller terminals)
pipboy_compact() {
    _pipboy_get_stats
    local G=$'\033[38;5;46m'
    local D=$'\033[38;5;22m'
    local R=$'\033[0m'

    clear
    cat << EOF
${G}╔═════════════════════════════════════════════════════╗
${G}║${D}  STAT     INV     DATA     MAP     RADIO           ${G}║
${G}╠═════════════════════════════════════════════════════╣
${G}║  ${D}        ⣠⡿⠛⢶⣦⣀                                ${G}║
${G}║  ${D}    ⣠⡾⠛⠙⠛⠋⠀⠀⠀⠈⠉⠛⣦⡀                          ${G}║
${G}║  ${D}   ⠛⠋⢀⣤⣀⠀⣀⣤⣤⡀⠀⠀⠀⠈⠻⣦                        ${G}║
${G}║  ${D}  ⡀⢀⡤⠋⠀⠈⠉⠉⠀⠉⠳⠤⠤⠴⢦⡄⠸⣷                       ${G}║
${G}║  ${D}  ⣀⡿⠿⠾⠀⠀⠀⠀⠀⢴⣦⡀⠀⠀⠀⣠⠟⠀⢹⡇                      ${G}║
${G}║  ${D}  ⡟⠀⣴⡄⠀⢀⡄⠀⠀⣦⡈⠃⠀⠀⡾⣳⣄⠀⣼⡇                      ${G}║
${G}║  ${D}  ⠀⠀⠿⠁⢀⡞⠁⠀⠀⣿⠗⠀⠀⠀⣟⢮⣿⣆⣿                       ${G}║
${G}║  ${D}  ⠀⠀⠀⠰⣯⡀⠀⠀⠀⠀⠀⠀⠀⠀⠪⣳⡵⡿⠁                       ${G}║
${G}╠═════════════════════════════════════════════════════╣
${G}║  ${G}CPU ${D}$(_pb_bar $_PB_CPU 8) ${G}${_PB_CPU}%  ${G}MEM ${D}$(_pb_bar $_PB_MEM 8) ${G}${_PB_MEM}%  ${G}DSK ${D}$(_pb_bar $_PB_DISK 8) ${G}${_PB_DISK}%  ${G}║
${G}╠═════════════════════════════════════════════════════╣
${G}║  ${G}BATT: ${_PB_BATT}%                                        ${G}║
${G}╚═════════════════════════════════════════════════════╝${R}
EOF
}

# ZSH prompt
_pipboy_zsh_prompt() {
    _pipboy_get_stats
    local dir="${PWD##*/}"
    [[ "$PWD" == "$HOME" ]] && dir="~"

    local G='%F{46}'
    local D='%F{22}'
    local R='%f'

    echo "${D}┌─[${G}CPU:${_PB_CPU}%%${D}]─[${G}MEM:${_PB_MEM}%%${D}]─[${G}DSK:${_PB_DISK}%%${D}]─[${G}BAT:${_PB_BATT}%%${D}]${R}"
    echo "${D}└─[${G}${dir}${D}]▶${R} "
}

# Bash prompt
_pipboy_bash_prompt() {
    _pipboy_get_stats
    local dir="${PWD##*/}"
    [[ "$PWD" == "$HOME" ]] && dir="~"

    local G=$'\033[38;5;46m'
    local D=$'\033[38;5;22m'
    local R=$'\033[0m'

    echo "${D}┌─[${G}CPU:${_PB_CPU}%${D}]─[${G}MEM:${_PB_MEM}%${D}]─[${G}DSK:${_PB_DISK}%${D}]─[${G}BAT:${_PB_BATT}%${D}]${R}"
    echo "${D}└─[${G}${dir}${D}]▶${R} "
}

# Commands
pipboy() {
    local cols=$(tput cols)
    if [[ $cols -lt 85 ]]; then
        pipboy_compact
    else
        pipboy_display
    fi
}

# ============================================================================
# Shell Configuration
# ============================================================================
if [[ -n "$ZSH_VERSION" ]]; then
    setopt PROMPT_SUBST
    precmd() {
        PROMPT="$(_pipboy_zsh_prompt)"
    }
    if [[ -z "$PIPBOY_LOADED" ]]; then
        export PIPBOY_LOADED=1
        pipboy
    fi
elif [[ -n "$BASH_VERSION" ]]; then
    PROMPT_COMMAND='PS1="$(_pipboy_bash_prompt)"'
    if [[ -z "$PIPBOY_LOADED" ]]; then
        export PIPBOY_LOADED=1
        pipboy
    fi
fi

alias vault='pipboy'
alias stats='pipboy'
