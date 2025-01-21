function _jmtech_print_status() {
    local exit_status=$1

    if (( JMTECH_PROMPT[cmd_executed] )); then
        local marker="$(_jmtech_build_status "$exit_status")"
        local -i screen_width=$COLUMNS
        local -i marker_len=$(_jmtech_strlen "$marker")
        local -i spacing=$(( screen_width - marker_len - 7 ))
        
        (( spacing < 1 )) && spacing=1
        print -P "%{${(l:$spacing:: :)}%}${marker}"
        
        JMTECH_PROMPT[cmd_executed]=0
    fi
}