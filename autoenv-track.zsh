#!/usr/bin/env zsh

autoenv-track-pre() {
  emulate -L zsh
  setopt localoptions extendedglob
  
  typeset -g _AUTOENV_TRACK_ALIASES_PRE=(${(k)aliases})
  typeset -g _AUTOENV_TRACK_FUNCTIONS_PRE=(${(k)functions})
  typeset -g _AUTOENV_TRACK_EXPORTS_PRE=(${(k)parameters[(R)*export*]})
  
  if [[ -n "$AUTOENV_TRACK_DEBUG" ]]; then
    print -P "%F{cyan}pre-aliases:%f ${#_AUTOENV_TRACK_ALIASES_PRE}"
    print -P "%F{cyan}pre-functions:%f ${#_AUTOENV_TRACK_FUNCTIONS_PRE}"
    print -P "%F{cyan}pre-exports:%f ${#_AUTOENV_TRACK_EXPORTS_PRE}"
  fi
}

autoenv-track-post() {
  emulate -L zsh
  setopt localoptions extendedglob
  
  if [[ -z "$_AUTOENV_TRACK_ALIASES_PRE" ]]; then
    print -P "%F{yellow}[autoenv-track]%f Warning: no saved state foun. Call autoenv-track-pre first!" >&2
    return 1
  fi

  local post_aliases=(${(k)aliases})
  local post_functions=(${(k)functions})
  local post_exports=(${(k)parameters[(R)*export*]})
  if [[ -n "$AUTOENV_TRACK_DEBUG" ]]; then
    print -P "%F{cyan}post-aliases:%f ${#post_aliases}"
    print -P "%F{cyan}post-functions:%f ${#post_functions}"
    print -P "%F{cyan}post-exports:%f ${#post_exports}"
  fi
  
  typeset -g _AUTOENV_TRACK_ALIASES=(${post_aliases:|_AUTOENV_TRACK_ALIASES_PRE})
  typeset -g _AUTOENV_TRACK_FUNCTIONS=(${post_functions:|_AUTOENV_TRACK_FUNCTIONS_PRE})
  typeset -g _AUTOENV_TRACK_EXPORTS=(${post_exports:|_AUTOENV_TRACK_EXPORTS_PRE})
  if [[ -n "$AUTOENV_TRACK_DEBUG" ]]; then
    print -P "%F{cyan}added-aliases:%f ${_AUTOENV_TRACK_ALIASES[@]}"
    print -P "%F{cyan}added-functions:%f ${_AUTOENV_TRACK_FUNCTIONS[@]}"
    print -P "%F{cyan}added-exports:%f ${_AUTOENV_TRACK_EXPORTS[@]}"
  fi

  unset _AUTOENV_TRACK_ALIASES_PRE
  unset _AUTOENV_TRACK_FUNCTIONS_PRE
  unset _AUTOENV_TRACK_EXPORTS_PRE
}

autoenv-track-restore() {
  emulate -L zsh
  setopt localoptions extendedglob
  
  if [[ -z "$_AUTOENV_TRACK_ALIASES" ]]; then
    print -P "%F{yellow}[autoenv-track]%f Warning: no saved state found. Call autoenv-track-{pre,post} first!" >&2
    return 1
  fi
    
  {
    for p in "${_AUTOENV_TRACK_EXPORTS[@]}"; do
      unset -- "$p" 2>/dev/null || true
    done
    
    for f in "${_AUTOENV_TRACK_FUNCTIONS[@]}"; do
      unset -f -- "$f" 2>/dev/null || true
    done
    
   for a in "${_AUTOENV_TRACK_ALIASES[@]}"; do
      unalias -- "$a" 2>/dev/null || true
    done
  } always {
    if [[ -n "$AUTOENV_TRACK_DEBUG" ]]; then
      (( $#_AUTOENV_TRACK_ALIASES ))  && print -P "%F{cyan}unalias:%f $_AUTOENV_TRACK_ALIASES[@]"
      (( $#_AUTOENV_TRACK_FUNCTIONS )) && print -P "%F{cyan}unset-func:%f $_AUTOENV_TRACK_FUNCTIONS[@]"
      (( $#_AUTOENV_TRACK_EXPORTS ))   && print -P "%F{cyan}unset-var:%f $_AUTOENV_TRACK_EXPORTS[@]"
    fi
    
    unset _AUTOENV_TRACK_ALIASES
    unset _AUTOENV_TRACK_FUNCTIONS
    unset _AUTOENV_TRACK_EXPORTS
  }
}

autoenv-track_plugin_unload() {
  unfunction autoenv-track{-pre,-post,-restore,_plugin_unload}
}
