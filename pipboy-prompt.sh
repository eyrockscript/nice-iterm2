#!/bin/bash
# ============================================================================
#  PIP-BOY TERMINAL PROMPT - Fallout Style
#  Add this to your ~/.zshrc or ~/.bashrc:
#  source /path/to/pipboy-prompt.sh
# ============================================================================

# Colors (Pip-Boy Green)
GREEN='\033[38;2;26;255;89m'
DIM_GREEN='\033[38;2;13;128;45m'
BRIGHT_GREEN='\033[38;2;51;255;128m'
RESET='\033[0m'

# Get system stats
get_cpu_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        top -l 1 -s 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%'
    else
        grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}'
    fi
}

get_memory_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        memory_pressure 2>/dev/null | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | tr -d '%' || \
        vm_stat | awk '
            /Pages active/ {active=$3}
            /Pages wired/ {wired=$4}
            /Pages free/ {free=$3}
            END {
                used = (active + wired) * 4096 / 1073741824
                total_approx = (active + wired + free) * 4096 / 1073741824
                printf "%.0f", (used/total_approx)*100
            }
        ' | tr -d '.'
    else
        free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
    fi
}

get_disk_usage() {
    df -h / | awk 'NR==2 {print $5}' | tr -d '%'
}

get_battery() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pmset -g batt 2>/dev/null | grep -Eo "\d+%" | tr -d '%' || echo "AC"
    else
        cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "AC"
    fi
}

get_uptime_short() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}' | xargs
    else
        uptime -p | sed 's/up //'
    fi
}

# Progress bar function
progress_bar() {
    local percent=$1
    local width=15
    local filled=$((percent * width / 100))
    local empty=$((width - filled))

    printf "["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' '-'
    printf "]"
}

# Display the Pip-Boy interface
pipboy_display() {
    local cpu=$(get_cpu_usage 2>/dev/null || echo "0")
    local mem=$(get_memory_usage 2>/dev/null || echo "0")
    local disk=$(get_disk_usage 2>/dev/null || echo "0")
    local batt=$(get_battery 2>/dev/null || echo "100")
    local uptime_str=$(get_uptime_short 2>/dev/null || echo "N/A")
    local hostname=$(hostname -s)
    local user=$(whoami)

    # Ensure numeric values
    [[ ! "$cpu" =~ ^[0-9]+$ ]] && cpu=0
    [[ ! "$mem" =~ ^[0-9]+$ ]] && mem=0
    [[ ! "$disk" =~ ^[0-9]+$ ]] && disk=0
    [[ ! "$batt" =~ ^[0-9]+$ ]] && batt=100

    echo -e "${GREEN}"
    cat << 'VAULT'
    ╔══════════════════════════════════════════════════════════════════════╗
    ║  ╔═══════╗  ╔═══════╗  ╔═══════╗  ╔═══════╗  ╔═══════╗              ║
    ║  ║ STAT  ║  ║  INV  ║  ║ DATA  ║  ║  MAP  ║  ║ RADIO ║              ║
    ║  ╚═══════╝  ╚═══════╝  ╚═══════╝  ╚═══════╝  ╚═══════╝              ║
    ╠══════════════════════════════════════════════════════════════════════╣
VAULT

    # Vault Boy ASCII art with stats
    echo -e "    ║                                                                      ║"
    echo -e "    ║              ${BRIGHT_GREEN}    ██████╗ ██╗██████╗       ██████╗  ██████╗ ██╗   ██╗${GREEN}    ║"
    echo -e "    ║              ${BRIGHT_GREEN}    ██╔══██╗██║██╔══██╗      ██╔══██╗██╔═══██╗╚██╗ ██╔╝${GREEN}    ║"
    echo -e "    ║              ${BRIGHT_GREEN}    ██████╔╝██║██████╔╝█████╗██████╔╝██║   ██║ ╚████╔╝${GREEN}     ║"
    echo -e "    ║              ${BRIGHT_GREEN}    ██╔═══╝ ██║██╔═══╝ ╚════╝██╔══██╗██║   ██║  ╚██╔╝${GREEN}      ║"
    echo -e "    ║              ${BRIGHT_GREEN}    ██║     ██║██║           ██████╔╝╚██████╔╝   ██║${GREEN}       ║"
    echo -e "    ║              ${BRIGHT_GREEN}    ╚═╝     ╚═╝╚═╝           ╚═════╝  ╚═════╝    ╚═╝${GREEN}       ║"
    echo -e "    ║                                                                      ║"
    echo -e "    ║                        ${BRIGHT_GREEN}     ,---.${GREEN}                                  ║"
    echo -e "    ║                        ${BRIGHT_GREEN}    /     \\${GREEN}                                 ║"
    echo -e "    ║                        ${BRIGHT_GREEN}    | o o |${GREEN}                                 ║"
    echo -e "    ║                        ${BRIGHT_GREEN}    |  >  |${GREEN}                                 ║"
    echo -e "    ║                        ${BRIGHT_GREEN}     \\___/${GREEN}                                  ║"
    echo -e "    ║                        ${BRIGHT_GREEN}    /|   |\\${GREEN}                                 ║"
    echo -e "    ║                        ${BRIGHT_GREEN}   / |   | \\${GREEN}                                ║"
    echo -e "    ║                        ${BRIGHT_GREEN}      | |${GREEN}                                   ║"
    echo -e "    ║                        ${BRIGHT_GREEN}     /   \\${GREEN}                                  ║"
    echo -e "    ║                                                                      ║"
    printf "    ║                           ${BRIGHT_GREEN}%-20s${GREEN}                      ║\n" "$user@$hostname"
    echo -e "    ║                                                                      ║"
    echo -e "    ╠══════════════════════════════════════════════════════════════════════╣"

    # Status bars (like HP, Level, AP but with system stats)
    printf "    ║  ${BRIGHT_GREEN}CPU${GREEN} %3s%%  $(progress_bar $cpu)  " "$cpu"
    printf "${BRIGHT_GREEN}MEM${GREEN} %3s%%  $(progress_bar $mem)  " "$mem"
    printf "${BRIGHT_GREEN}DISK${GREEN} %3s%% $(progress_bar $disk)  ║\n" "$disk"

    echo -e "    ╠══════════════════════════════════════════════════════════════════════╣"
    printf "    ║  ${BRIGHT_GREEN}BATT${GREEN} %3s%%            ${BRIGHT_GREEN}UPTIME${GREEN} %-20s              ║\n" "$batt" "$uptime_str"
    echo -e "    ╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# Simpler prompt for everyday use
pipboy_prompt() {
    local cpu=$(get_cpu_usage 2>/dev/null || echo "0")
    local mem=$(get_memory_usage 2>/dev/null || echo "0")
    local disk=$(get_disk_usage 2>/dev/null || echo "0")

    [[ ! "$cpu" =~ ^[0-9]+$ ]] && cpu=0
    [[ ! "$mem" =~ ^[0-9]+$ ]] && mem=0
    [[ ! "$disk" =~ ^[0-9]+$ ]] && disk=0

    local dir=$(basename "$PWD")
    [[ "$PWD" == "$HOME" ]] && dir="~"

    echo -e "${DIM_GREEN}┌─[${GREEN}CPU:${cpu}%${DIM_GREEN}]─[${GREEN}MEM:${mem}%${DIM_GREEN}]─[${GREEN}DISK:${disk}%${DIM_GREEN}]${RESET}"
    echo -e "${DIM_GREEN}└─[${BRIGHT_GREEN}${dir}${DIM_GREEN}]─▶${RESET} "
}

# Function to show full Pip-Boy (call with 'pipboy' command)
pipboy() {
    clear
    pipboy_display
}

# MOTD - Show on terminal start
pipboy_motd() {
    pipboy_display
    echo ""
}

# ============================================================================
# ZSH Configuration
# ============================================================================
if [[ -n "$ZSH_VERSION" ]]; then
    # Use precmd for prompt
    precmd() {
        PROMPT="$(pipboy_prompt)"
    }

    # Show MOTD on first load
    if [[ -z "$PIPBOY_LOADED" ]]; then
        export PIPBOY_LOADED=1
        pipboy_motd
    fi
fi

# ============================================================================
# BASH Configuration
# ============================================================================
if [[ -n "$BASH_VERSION" ]]; then
    PROMPT_COMMAND='PS1="$(pipboy_prompt)"'

    # Show MOTD on first load
    if [[ -z "$PIPBOY_LOADED" ]]; then
        export PIPBOY_LOADED=1
        pipboy_motd
    fi
fi

# ============================================================================
# Alias for quick access
# ============================================================================
alias vault='pipboy'
alias stats='pipboy_display'
