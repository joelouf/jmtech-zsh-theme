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