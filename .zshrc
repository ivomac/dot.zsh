source "$ZDOTDIR/plugins/fzf/fzf.zsh"

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

if [[ -r "$HOME/.cache/p10k-instant-prompt-$USER.zsh" ]]; then
  source "$HOME/.cache/p10k-instant-prompt-$USER.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)
autoload -Uz compinit && compinit -d "$ZDOTDIR/cache/completions"

source "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-abbr/zsh-abbr.zsh"
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

zstyle ':completion:*' regular true

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview "eza -1 --color=always \$realpath"

export NNN_TMPFILE="/tmp/nnn.$$.lastd"
function precmd() {
    if [[ -f "$NNN_TMPFILE" ]]; then
            . "$NNN_TMPFILE"
            rm "$NNN_TMPFILE"
    fi
}

# NOT WHITESPACE! This is the Braille Pattern Blank unicode character
export SEP='⠀'
export SPAWN_TIME="($(date '+%H:%M'))"
export TITLE="$SEP"
export PREVCMD=""
function preexec() {
	BRANCH="${VCS_STATUS_LOCAL_BRANCH}"
	[[ -n $BRANCH ]] && BRANCH=" [$BRANCH]"

	segments=(
		"${PWD//$HOME/~}$BRANCH"
		"> $1"
		"< $(date '+%H:%M') $SPAWN_TIME"
	)

	[[ -n $PREVCMD ]] && segments+="prevcmd:$SEP> $PREVCMD"
	PREVCMD="$1"

	# Again the Braille character
    TITLE=${(j|⠀|)segments}

	echo -en "\e]0;${TITLE}\a"
}
preexec ""

function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

typeset -A PWD_HIST
PWD_HIST[$PWD]=1
function chpwd() {
	PWD_HIST[$PWD]=1
    (( ZSH_SUBSHELL )) || osc7-pwd
}

function edit-history() {
	$EDITOR "$HISTFILE"
}

function cd() {
	if [[ "$PWD" != "$1" ]]; then
		builtin cd "$@" || return
	fi
	eza --icons=auto
}

function _cd-up() {
	if [[ -z "$BUFFER" ]]; then
		BUFFER="cd .."
		zle accept-line
	fi
}
zle -N _cd-up

function _cd-back-and-forth() {
	if [[ -z "$BUFFER" ]]; then
		builtin cd - || return
		zle accept-line
	else
		zle  fzf-tab-complete
	fi
}
zle -N _cd-back-and-forth

function pyenv() {
	if [[ "$1" == "new" ]]; then
		python -m venv .pyenv
	fi
	if [[ -n "$VIRTUAL_ENV" ]]; then
		deactivate
	else
		source .pyenv/bin/activate
	fi
}

function dagster-reset() {
	[[ -d ".pyenv" ]] || return
	[[ -n "$VIRTUAL_ENV" ]] || source .pyenv/bin/activate
	[[ -n $(pgrep dagster) ]] && sudo pkill -f dagster
	psql -U postgres -c "DROP DATABASE dagster;"
	psql -U postgres -c "CREATE DATABASE dagster;"
	dagster dev
}

function memray-run() {
	BINFILE="./memray.bin"
	HTMLFILE="./memray.html"
	[[ -f $BINFILE ]] && rm "$BINFILE"
	[[ -f $HTMLFILE ]] && rm "$HTMLFILE"
	python -m memray run -o "$BINFILE" $@
	python -m memray flamegraph -o "$HTMLFILE" "$BINFILE"
	xdg-open "$HTMLFILE"
}

function mgit-pull() {
	mgit -e -d 3 | grep "Needs pull" | tee /dev/tty | awk -F':' '{print $1" pull"}' | xargs -n2 git -C
}

function zvm_after_init() {
	zvm_bindkey viins '^[[A' history-substring-search-up
	zvm_bindkey viins '^[[B' history-substring-search-down
	zvm_bindkey viins '^P' history-substring-search-up
	zvm_bindkey viins '^N' history-substring-search-down
	zvm_bindkey viins '^O' _fzf-open-from-history
	zvm_bindkey viins '^K' _fzf-cd-from-cd-history
	zvm_bindkey viins '^H' _fzf-run-command-from-history
	zvm_bindkey viins '^B' _fzf-go-to-nnn-bookmark
	zvm_bindkey viins '^I' _fzf-open
	zvm_bindkey viins '^[[Z' _cd-back-and-forth
	zvm_bindkey viins '^[[27;5;46~' _cd-up
}

alias gist='gist -u $GIST_KEY '

[[ ! -f "$ZDOTDIR/env/p10k.zsh" ]] || source "$ZDOTDIR/env/p10k.zsh" 
