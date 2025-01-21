function _jmtech_init() {
    add-zsh-hook preexec _jmtech_preexec
    add-zsh-hook precmd _jmtech_precmd

    zle -N _jmtech_accept_line
    bindkey '^M' _jmtech_accept_line
}