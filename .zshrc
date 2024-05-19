# ZSH OPTIONS

unalias run-help && autoload run-help

# HISTORY CONFIG
## history is appended on terminal exit, no duplicates are allowed

setopt append_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

setopt auto_cd cd_silent

setopt menu_complete

setopt long_list_jobs

setopt notify

setopt hash_list_all

setopt glob_dots

# LOAD FZF NAVIGATION

source "$ZDOTDIR/plugins/fzf-nav/fzf-nav.zsh"

# EXECUTE AT STARTUP

## If zsh is run as RUN=... zsh, then run the command and exit
## If zsh is run as RUNI=... zsh, then run the command and continue
## Useful to launch a new terminal with a command:
## foot -D "$HOME/Downloads" -e env RUNI="nnn" zsh

if [[ -n "$RUN" ]]; then
	RUN1="$RUN"
	unset RUN
	eval $RUN1
	exit
fi

if [[ -n "$RUNI" ]]; then
	RUN1="$RUNI"
	unset RUNI
	eval $RUN1
fi

# POWERLINE10K INSTANT PROMPT

if [[ -r "$HOME/.cache/p10k-instant-prompt-$USER.zsh" ]]; then
  source "$HOME/.cache/p10k-instant-prompt-$USER.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# LOAD COMPLETIONS

fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)
autoload -Uz compinit && compinit -d "$ZDOTDIR/cache/completions"

# LOAD PLUGINS

bindkey -e

source "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-abbr/zsh-abbr.zsh"

# PLUGIN CONFIG

zstyle ':completion:*' regular true
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no

zstyle ':fzf-tab:complete:cd:*' fzf-preview "eza -1 --color=always \$realpath"

# SOURCE NNN FILE: AUTO CD ON EXIT

export NNN_TMPFILE="/tmp/autocd.$$"
function precmd() {
    if [[ -f "$NNN_TMPFILE" ]]; then
            source "$NNN_TMPFILE"
            rm "$NNN_TMPFILE"
    fi
}

# REPORT DIRECTORY CHANGES TO FOOT TERMINAL
## https://codeberg.org/dnkl/foot/wiki#spawning-new-terminal-instances-in-the-current-working-directory

function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

# SAVE DIRECTORY CHANGES IN A VARIABLE
## chpwd is called whenever the current directory changes:
## https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions

typeset -A PWD_HIST
PWD_HIST[$PWD]=1
function chpwd() {
	PWD_HIST[$PWD]=1
    (( ZSH_SUBSHELL )) || osc7-pwd
}

# PRINT THE CURRENT DIRECTORY CONTENTS ON CD

function cd() {
	if [[ "$PWD" != "$1" ]]; then
		builtin cd "$@" || return
	fi
	eza --icons=auto
}

# FUNCTION: cd ..

function _cd-up() {
	if [[ -z "$BUFFER" ]]; then
		BUFFER="cd .."
		zle accept-line
	fi
}
zle -N _cd-up

# FUNCTION: cd - binding

function _cd-back-and-forth() {
	if [[ -z "$BUFFER" ]]; then
		builtin cd - || return
		zle accept-line
	else
		zle  fzf-tab-complete
	fi
}
zle -N _cd-back-and-forth

# PYTHON VIRTUALENV CONVENIENCE FUNCTION

function pyenv() {
	[[ -z "$1" ]] && echo "Usage: pyenv <env-name>" && return
	if [[ ! -d ".$1" ]]; then
		python -m venv ".pyenv_$1"
	fi
	if [[ -n "$VIRTUAL_ENV" ]]; then
		deactivate
	else
		source ".pyenv_$1/bin/activate"
	fi
}

bindkey '^[[A' history-substring-search-up    # Up arrow
bindkey '^[[B' history-substring-search-down  # Down arrow
bindkey '^P' history-substring-search-up      # Ctrl+P
bindkey '^N' history-substring-search-down    # Ctrl+N
bindkey '^O' _fzf-open-from-history           # Ctrl+O
bindkey '^K' _fzf-cd-from-cd-history          # Ctrl+K
bindkey '^H' _fzf-run-command-from-history    # Ctrl+H
bindkey '^B' _fzf-go-to-nnn-bookmark          # Ctrl+B
bindkey '^I' _fzf-open                        # Ctrl+I
bindkey '^[[Z' _cd-back-and-forth             # Shift+Tab
bindkey '^[[27;5;46~' _cd-up                  # Ctrl+.

# POWERLEVEL10K LOAD

_P10K="$ZDOTDIR/config/p10k"
[[ -f "$_P10K" ]] && source "$_P10K"
