# shellcheck shell=bash
# shellcheck disable=SC2034 # ignore unused variables, this is a color library, they're for use elsewhere
# =============================================================================
# colorize.sh :: mdunbar :: 2023 sep 06
# =============================================================================
export TERM=xterm-256color

red=$(tput bold; tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput bold; tput setaf 3)
blue=$(tput bold; tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput bold; tput setaf 7)
normal=$(tput sgr0)

# ------------------------------------------------------------
# Add extended colors
# ------------------------------------------------------------
#function EXT_COLOR () { echo -ne "\033[38;5;$1m"; }
