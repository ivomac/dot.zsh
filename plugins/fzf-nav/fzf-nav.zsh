
_FZF_DIR="$ZDOTDIR/plugins/fzf-nav"

export FZF_OUT="/tmp/fzf.$$.out"

common_opts=(
	"--color=always"
	"--follow"
	"--hidden"
	"--no-ignore"
)

exclude_dirs=(
	"**/nnn/bookmarks/**"
	"**/.steam/**"
	"**/.pyenv_**/**"
	"**/cache/**"
	"**/.local/share/**"
	"**/__pycache__/**"
	"**/.cache/**"
	"**/.pyenv/**"
	"**/.bib/**"
	"**/.cargo/**"
	"**/.git/**"
	"**/.ipython/**"
	"**/.mozilla/**"
	"**/*.svg"
	"**/.npm/**"
	"**/.pki/**"
	"undo"
)

FZF_FD_COMMAND="fd"

FZF_RG_COMMAND="rg \
	--line-number \
	--with-filename \
	--no-heading \
	--smart-case \
	'.'"

for opt in $common_opts; do
	FZF_FD_COMMAND+=" $opt"
	FZF_RG_COMMAND+=" $opt"
done

for dir in $exclude_dirs; do
	FZF_FD_COMMAND+=" --exclude=\"$dir\""
	FZF_RG_COMMAND+=" --glob=\"!$dir\""
done

export FZF_FD_COMMAND
export FZF_RG_COMMAND


export _FZF_PREVIEW_FILES_OPTS=(
	--preview="$_FZF_DIR/preview.zsh {1} {2}"
	--preview-window=down:50%:wrap:rounded
	--bind='ctrl-h:toggle-preview'
)

export _FZF_OPEN_HISTORY_OPTS=(
	--bind="enter:become(exec $_FZF_DIR/redir-out.zsh CD {1})"
)

export _FZF_BOOKMARK_OPTS=(
	--delimiter=' -> '
	--bind="enter:become(exec $_FZF_DIR/redir-out.zsh CD {1})"
)

S=" · "
export _FZF_OPEN_OPTS=(
	"${_FZF_PREVIEW_FILES_OPTS[@]}"
	--header="\:Jump${S}CR:Op+CD${S}O:Open${S}U:CD${S}G:Lazygit${S}D:Detach${S}E:Edit${S}L:Pager${S}Y:Yank${S}F:FD/Fil/Dir${S}R:RG"
	--ansi
	--scheme=path
	--delimiter=:
	--bind="ctrl-l:execute($PAGER -f {1})"
	--bind="ctrl-e:execute(nvim +{2} {1})"
	--bind="ctrl-f:transform:$_FZF_DIR/toggle-fd.zsh"
	--bind="ctrl-r:transform:$_FZF_DIR/go-rg.zsh"
	--bind="ctrl-d:execute-silent(\$TERMINAL env RUNI=\"\$OPEN {1}\" zsh)"
	--bind="ctrl-u:become($_FZF_DIR/redir-out.zsh CDONLY {1} {2})"
	--bind="enter:become(exec $_FZF_DIR/redir-out.zsh CD {1} {2})"
	--bind="ctrl-o:become(exec $_FZF_DIR/redir-out.zsh NO {1} {2})"
	--bind="ctrl-g:become(exec $_FZF_DIR/redir-out.zsh CDGIT {1} {2})"
)

export _FZF_NNN_PLUGIN_OPTS=(
	"${_FZF_PREVIEW_FILES_OPTS[@]}"
	--ansi
	--scheme=path
	--delimiter=:
)

export FZF_DEFAULT_OPTS="
	--height=100%
	--info=inline-right
	--algo=v2
	--tiebreak=begin,length
	--tabstop=2
	--reverse
	--no-mouse
	--no-hscroll
	--bind=change:top
	--bind='ctrl-\:jump'
	--bind='ctrl-y:execute-silent(echo {} | wl-copy)'
	"

source "$_FZF_DIR/colors/default.zsh"

function get_dir() {
	if [[ -d "$1" ]]; then
		echo "$1"
	else
		dirname "$1"
	fi
}

function _cd-and-open() {
	if [[ -f "$FZF_OUT" ]]; then
		in=$(<"$FZF_OUT")
		rm "$FZF_OUT"
		IFS=$'\0' read -r CD file line <<< "$in"
		if [[ -f "$file" ]] || [[ -d "$file" ]]; then
			file=$(realpath "$file")
			if [[ "$CD" =~ "CD" ]]; then
				builtin cd $(get_dir "$file")
				if [[ "$CD" == "CDGIT" ]]; then
					dir=$(git rev-parse --show-toplevel 2> /dev/null)
					builtin cd "$dir"
				fi
			fi
			if [[ "$CD" == "CDGIT" ]]; then
				BUFFER="lazygit"
			elif [[ "$CD" != "CDONLY" ]]; then
				opts="${line:++$line}"
				file=$(printf %q "$file")
				BUFFER="\$OPEN $file $opts"
			fi
			zle accept-line
		fi
	fi
}

function _fzf-go-to-nnn-bookmark() {
	if [[ -z "$BUFFER" ]]; then
		builtin cd "$HOME/.config/nnn/bookmarks/"
		eza -1A . | fzf --prompt=" BK > " ${_FZF_BOOKMARK_OPTS[@]}
		_cd-and-open
	else
		zle backward-char
	fi
}
zle -N _fzf-go-to-nnn-bookmark

function _fzf-open() {
	if [[ -z "$BUFFER" ]]; then
		eval $FZF_FD_COMMAND | fzf --prompt=" FD > " ${_FZF_OPEN_OPTS[@]}
		_cd-and-open
	else
		zle  fzf-tab-complete
	fi
}
zle -N _fzf-open

function _fzf-open-from-history() {
	if [[ -z "$BUFFER" ]]; then
		fc -n -l 1 | grep '^$OPEN' | cut -d' ' -f2- | fzf --tac +s ${_FZF_OPEN_HISTORY_OPTS[@]}
		_cd-and-open
		zle accept-line
	fi
}
zle -N _fzf-open-from-history

function _fzf-cd-from-cd-history() {
	if [[ -z "$BUFFER" ]]; then
		sels=$(printf "%s\n" "${(@k)PWD_HIST}" | fzf --tac +s)
		if [[ -n "$sels" ]]; then
			BUFFER+="cd $sels"
			zle accept-line
		fi
	else
		zle kill-line
	fi
}
zle -N _fzf-cd-from-cd-history

function _fzf-run-command-from-history() {
	if [[ -z "$BUFFER" ]]; then
		sels=$(fc -n -l 1 | fzf --tac +s)
		if [[ -n "$sels" ]]; then
			BUFFER+="$sels"
			zle accept-line
		fi
	fi
}
zle -N _fzf-run-command-from-history

