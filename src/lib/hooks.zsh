function _jmtech_preexec() {
    JMTECH_PROMPT[cmd_executed]=1
}

function _jmtech_precmd() {
    local exit_status=$?
    JMTECH_PROMPT[last_status]=$exit_status
    
    _jmtech_print_status "$exit_status"
    
    # Prompt components.
    local dir_path="$(_jmtech_format_path "$PWD")"
    local git_info="$(_jmtech_git_info)"
    local timestamp="${JMTECH_COLOR[c_light_grey]}%D{%H:%M:%S}${JMTECH_COLOR[c_reset]}"
    
    # Multi-line prompt.
    PROMPT="${JMTECH_COLOR[c_dim_grey]}╭╭─${JMTECH_COLOR[c_reset]} ${dir_path}${git_info}"$'\n'
    PROMPT+="${JMTECH_COLOR[c_dim_grey]}│${JMTECH_COLOR[c_reset]} ${timestamp}"$'\n'
    PROMPT+="${JMTECH_COLOR[c_dim_grey]} ╰╰${JMTECH_COLOR[c_reset]} ❯❯ "
}

function _jmtech_accept_line() {
    zle .reset-prompt
    zle accept-line
}