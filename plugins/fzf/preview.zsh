#!/usr/bin/zsh

if [[ -d "$1" ]]; then
	flag=""
	if [[ -h "$1" ]]; then
		echo "Symlink: $1\n"
		flag="-H"
	else
		echo "Directory: $1\n"
	fi
	eza -Al $flag "$1"
elif [[ -f "$1" ]]; then
	if [[ -n "$2" ]]; then
		beg=$(( $2-10 ))
		if [[ $beg -le 0 ]]; then
			beg=1
		fi
		bat --theme=gruvbox-dark --style=full --color=always --line-range="$beg:" --highlight-line "$2" "$1"
	else
		bat --theme=gruvbox-dark --style=full --color=always $1
	fi
fi

