# Global state management.
typeset -gA JMTECH_PROMPT=(
    [last_status]=0
    [cmd_executed]=0
    [min_path_width]=60
    [max_path_dirs]=3
)

# Colors.
typeset -gA JMTECH_COLOR=(
    [c_red]='%F{red}'
    [c_yellow]='%F{yellow}'
    [c_green]='%F{green}'
    [c_blue]='%F{blue}'
    [c_cyan]='%F{cyan}'
    [c_magenta]='%F{magenta}'
    [c_white]='%F{white}'
    [c_light_grey]='%F{248}'
    [c_dim_grey]='%F{240}'
    [c_orange]='%F{172}'

    # Color reset.
    [c_reset]='%f'
)

# Status symbols.
typeset -gA JMTECH_STATUS=(
    [s_success]='∵ ∵ ∵'
    [s_failure]='∴ ∴ ∴'
)

# Git symbols.
typeset -gA JMTECH_GIT
if [[ "$JMTECH_USE_NERD_FONTS" == "false" ]]; then
    JMTECH_GIT=(
        [s_branch]='='
        [s_staged]='✱'
        [s_unstaged]='✚'
        [s_untracked]='…'
        [s_stashed]='⚑'
        [s_ahead]='↑'
        [s_behind]='↓'
        [s_gpg_good]='✔'
        [s_gpg_bad]='✘'
        [s_gpg_unknown]='?'
        [s_auto_sign]='✎'
    )
else
    JMTECH_GIT=(
        [s_branch]=' '
        [s_staged]=' '
        [s_unstaged]=' '
        [s_untracked]=' '
        [s_stashed]=' '
        [s_ahead]=' '
        [s_behind]=' '
        [s_gpg_good]=''
        [s_gpg_bad]=''
        [s_gpg_unknown]='' 
        [s_auto_sign]=' '
    )
fi

# Cache config.
typeset -gA JMTECH_CACHE
JMTECH_CACHE[timeout]=5