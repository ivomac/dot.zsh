
for file in $ZDOTDIR/env/*.sh; do
	# file is wayland.sh and WAYLAND_DISPLAY is not set, skip
	if [[ "$file" == "*wayland.sh" && -z "$WAYLAND_DISPLAY" ]]; then
		continue
	fi
	source "$file"
done

# LOAD LS COLORS

[[ -x "$(command -v dircolors)" ]] && eval "$(dircolors)"

