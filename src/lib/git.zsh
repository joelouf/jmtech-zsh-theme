# Cache management.
function _get_cache() {
    local key="$1"
    local cached_time="${JMTECH_CACHE[$key:time]}"
    local current_time=$EPOCHSECONDS
    
    if [[ -n "$cached_time" && $(( current_time - cached_time )) -lt ${JMTECH_CACHE[timeout]} ]]; then
        echo "${JMTECH_CACHE[$key:value]}"
        return 0
    fi
    return 1
}

function _set_cache() {
    local key="$1"
    local value="$2"
    JMTECH_CACHE[$key:value]="$value"
    JMTECH_CACHE[$key:time]=$EPOCHSECONDS
}

function _jmtech_cached_git_status() {
    local repo_path
    repo_path=$(git rev-parse --git-dir 2>/dev/null) || return
    local cache_key="status:$repo_path"

    local cached_git_status
    if cached_git_status=$(_get_cache "$cache_key"); then
        echo "$cached_git_status"
        return
    fi

    local git_status_output
    git_status_output="$(git status --porcelain 2>/dev/null)"
    _set_cache "$cache_key" "$git_status_output"
    echo "$git_status_output"
}

function _jmtech_cached_git_branch() {
    local repo_path
    repo_path=$(git rev-parse --git-dir 2>/dev/null) || return
    local cache_key="branch:$repo_path"

    local cached_branch
    if cached_branch=$(_get_cache "$cache_key"); then
        echo "$cached_branch"
        return
    fi

    local branch
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    _set_cache "$cache_key" "$branch"
    echo "$branch"
}

function _jmtech_cached_git_upstream() {
    local repo_path
    repo_path=$(git rev-parse --git-dir 2>/dev/null) || return
    local cache_key="upstream:$repo_path"

    local cached_upstream
    if cached_upstream=$(_get_cache "$cache_key"); then
        echo "$cached_upstream"
        return
    fi

    local upstream
    upstream="$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)"
    _set_cache "$cache_key" "$upstream"
    echo "$upstream"
}

function _jmtech_cached_git_stash() {
    local repo_path
    repo_path=$(git rev-parse --git-dir 2>/dev/null) || return
    local cache_key="stash:$repo_path"

    local cached_stash
    if cached_stash=$(_get_cache "$cache_key"); then
        echo "$cached_stash"
        return
    fi

    local stash_count
    stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    _set_cache "$cache_key" "$stash_count"
    echo "$stash_count"
}

function _jmtech_cached_git_ahead_behind() {
    local repo_path
    repo_path=$(git rev-parse --git-dir 2>/dev/null) || return
    local cache_key="ahead_behind:$repo_path"

    local cached_ahead_behind
    if cached_ahead_behind=$(_get_cache "$cache_key"); then
        echo "$cached_ahead_behind"
        return
    fi

    local upstream
    upstream="$(_jmtech_cached_git_upstream)"
    local ahead=0
    local behind=0
    
    if [[ -n "$upstream" ]]; then
        ahead=$(git rev-list --count "$upstream"..HEAD 2>/dev/null)
        behind=$(git rev-list --count HEAD.."$upstream" 2>/dev/null)
    fi

    local result="$ahead $behind"
    _set_cache "$cache_key" "$result"
    echo "$result"
}

function _jmtech_cached_git_signing() {
    local repo_path
    repo_path=$(git rev-parse --git-dir 2>/dev/null) || return
    local cache_key="signing:$repo_path"

    local cached_signing
    if cached_signing=$(_get_cache "$cache_key"); then
        echo "$cached_signing"
        return
    fi

    local auto_sign
    auto_sign="$(git config --get commit.gpgSign 2>/dev/null)"
    local head_sig
    head_sig="$(git log -1 --pretty='%G?' HEAD 2>/dev/null)"
    
    local result="$auto_sign $head_sig"
    _set_cache "$cache_key" "$result"
    echo "$result"
}

function _jmtech_git_parse_status() {
    local git_status_str="$1"
    local git_staged
    local git_unstaged
    local git_untracked

    git_staged=$(grep -E '^[AMRCDU][[:space:]]' <<< "$git_status_str" | wc -l | tr -d ' ')
    git_unstaged=$(grep -E '^.[AMRCDU]' <<< "$git_status_str" | wc -l | tr -d ' ')
    git_untracked=$(grep -E '^\?\?' <<< "$git_status_str" | wc -l | tr -d ' ')

    echo "$git_staged $git_unstaged $git_untracked"
}

function _jmtech_git_info() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo ""
        return
    fi

    # Get branch info.
    local branch
    branch="$(_jmtech_cached_git_branch)"
    [[ "$branch" == "HEAD" ]] && branch="DETACHED"

    # Get status counts.
    local git_status
    git_status="$(_jmtech_cached_git_status)"
    local status_counts=($(_jmtech_git_parse_status "$git_status"))
    local git_staged=${status_counts[1]}
    local git_unstaged=${status_counts[2]}
    local git_untracked=${status_counts[3]}

    # Get stash count.
    local git_stash_count
    git_stash_count="$(_jmtech_cached_git_stash)"

    # Get ahead/behind counts.
    local ahead_behind
    ahead_behind=($(_jmtech_cached_git_ahead_behind))
    local git_ahead=${ahead_behind[1]}
    local git_behind=${ahead_behind[2]}

    # Get signing info
    local signing_info
    signing_info=($(_jmtech_cached_git_signing))
    local auto_sign=${signing_info[1]}
    local head_sig=${signing_info[2]}

    # Build status string.
    local result=""
    if [[ -n "$branch" ]]; then
        result=" ❯❯ ${JMTECH_COLOR[c_yellow]}${JMTECH_GIT[s_branch]}${branch}${JMTECH_COLOR[c_reset]}"
    fi

    (( git_staged > 0 )) && result+=" ${JMTECH_COLOR[c_green]}${JMTECH_GIT[s_staged]}${git_staged}${JMTECH_COLOR[c_reset]}"
    (( git_unstaged > 0 )) && result+=" ${JMTECH_COLOR[c_red]}${JMTECH_GIT[s_unstaged]}${git_unstaged}${JMTECH_COLOR[c_reset]}"
    (( git_untracked > 0 )) && result+=" ${JMTECH_COLOR[c_blue]}${JMTECH_GIT[s_untracked]}${git_untracked}${JMTECH_COLOR[c_reset]}"
    (( git_stash_count > 0 )) && result+=" ${JMTECH_COLOR[c_cyan]}${JMTECH_GIT[s_stashed]}${git_stash_count}${JMTECH_COLOR[c_reset]}"
    (( git_behind > 0 )) && result+=" ${JMTECH_COLOR[c_magenta]}${JMTECH_GIT[s_behind]}${git_behind}${JMTECH_COLOR[c_reset]}"
    (( git_ahead > 0 )) && result+=" ${JMTECH_COLOR[c_magenta]}${JMTECH_GIT[s_ahead]}${git_ahead}${JMTECH_COLOR[c_reset]}"

    if [[ -n "$head_sig" ]]; then
        case "$head_sig" in
            G)       result+=" ${JMTECH_COLOR[c_green]}${JMTECH_GIT[s_gpg_good]}${JMTECH_COLOR[c_reset]}" ;;
            B|R)     result+=" ${JMTECH_COLOR[c_red]}${JMTECH_GIT[s_gpg_bad]}${JMTECH_COLOR[c_reset]}" ;;
            U|X|Y|E) result+=" ${JMTECH_COLOR[c_yellow]}${JMTECH_GIT[s_gpg_unknown]}${JMTECH_COLOR[c_reset]}" ;;
        esac
    fi

    if [[ "$auto_sign" == "true" ]]; then
        result+=" ${JMTECH_COLOR[c_cyan]}${JMTECH_GIT[s_auto_sign]}${JMTECH_COLOR[c_reset]}"
    fi

    echo "$result"
}