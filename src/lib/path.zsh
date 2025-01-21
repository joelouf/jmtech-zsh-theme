function _jmtech_format_path() {
    local full_path="$1"

    # Root directory.
    if [[ "$full_path" == "/" ]]; then
        echo "${JMTECH_COLOR[c_orange]}/${JMTECH_COLOR[c_reset]}"
        return
    fi

    # Replace $HOME with ~
    full_path=${full_path/#$HOME/\~}

    # Split path.
    local -a path_parts
    path_parts=(${(s:/:)full_path})
    local num_parts=${#path_parts}
    local formatted=""

    # Handle path truncation.
    if (( COLUMNS < JMTECH_PROMPT[min_path_width] )); then
        if (( num_parts > 2 )); then
            formatted="…/${path_parts[-2]}/${path_parts[-1]}"
        else
            formatted="$full_path"
        fi
    elif (( num_parts > JMTECH_PROMPT[max_path_dirs] + 1 )); then
        local prefix="${path_parts[1]}"
        local suffix="${path_parts[-3]}/${path_parts[-2]}/${path_parts[-1]}"
        formatted="${prefix}/…/${suffix}"
    else
        formatted="$full_path"
    fi

    _jmtech_colorize_path "$formatted"
}