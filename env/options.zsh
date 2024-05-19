# use run-help to get man pages of builtin zsh functions
unalias run-help && autoload run-help

setopt append_history
setopt inc_append_history
setopt inc_append_history_time
setopt extended_history
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_no_functions
setopt hist_ignore_all_dups
setopt hist_save_no_dups

setopt auto_cd cd_silent

setopt auto_pushd pushd_ignore_dups
setopt pushd_silent pushd_to_home

setopt menu_complete

setopt long_list_jobs

setopt notify

setopt hash_list_all

setopt glob_dots

