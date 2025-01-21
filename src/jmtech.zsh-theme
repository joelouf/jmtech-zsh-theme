#!/usr/bin/env zsh

JMTECH_ROOT="${0:A:h}"

setopt PROMPT_SUBST
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

source "${JMTECH_ROOT}/lib/config.zsh"
source "${JMTECH_ROOT}/lib/utils.zsh"
source "${JMTECH_ROOT}/lib/git.zsh"
source "${JMTECH_ROOT}/lib/path.zsh"
source "${JMTECH_ROOT}/lib/status.zsh"
source "${JMTECH_ROOT}/lib/hooks.zsh"
source "${JMTECH_ROOT}/lib/prompt.zsh"

_jmtech_init