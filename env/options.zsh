## use run-help to get man pages of builtin zsh functions
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

