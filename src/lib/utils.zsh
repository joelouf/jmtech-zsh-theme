# Cross-platform timeout wrapper to prevent hanging commands.
function _jmtech_with_timeout() {
    local timeout_sec=$1
    shift
    
    # Try native timeout commands first.
    if command -v timeout &>/dev/null; then
        # Linux coreutils / Windows Git Bash.
        timeout "${timeout_sec}s" "$@" 2>/dev/null
        return $?
    elif command -v gtimeout &>/dev/null; then
        # macOS with Homebrew coreutils.
        gtimeout "${timeout_sec}s" "$@" 2>/dev/null
        return $?
    fi
    
    # POSIX fallback using background process with kill.
    (
        "$@" &
        local cmd_pid=$!
        
        (
            sleep "$timeout_sec"
            kill "$cmd_pid" 2>/dev/null
        ) &
        local killer_pid=$!
        
        wait "$cmd_pid" 2>/dev/null
        local exit_status=$?
        
        kill "$killer_pid" 2>/dev/null
        wait "$killer_pid" 2>/dev/null
        
        return $exit_status
    )
}

function _jmtech_strlen() {
    local string="$1"

    local stripped="${string//(%([KF1]|)\{*\}|%[Bbkf])/}"
    print ${#stripped}
}

function _jmtech_build_status() {
    local exit_status=$1

    if (( exit_status == 0 )); then
        echo "${JMTECH_COLOR[c_dim_grey]}╶|${JMTECH_COLOR[c_reset]}${JMTECH_COLOR[c_green]}${JMTECH_STATUS[s_success]}${JMTECH_COLOR[c_reset]}${JMTECH_COLOR[c_dim_grey]}|╯╯${JMTECH_COLOR[c_reset]}"
    else
        echo "${JMTECH_COLOR[c_dim_grey]}╶|${JMTECH_COLOR[c_reset]}${JMTECH_COLOR[c_red]}${JMTECH_STATUS[s_failure]}${JMTECH_COLOR[c_reset]}${JMTECH_COLOR[c_dim_grey]}|╯╯${JMTECH_COLOR[c_reset]}"
    fi
}

function _jmtech_colorize_path() {
    local path="$1"

    if [[ $path == */* ]]; then
        echo "${JMTECH_COLOR[c_white]}${path%/*}/${JMTECH_COLOR[c_orange]}${path##*/}${JMTECH_COLOR[c_reset]}"
    else
        echo "${JMTECH_COLOR[c_orange]}${path}${JMTECH_COLOR[c_reset]}"
    fi
}