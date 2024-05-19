
prompt="ERR"
if [[ $FZF_PROMPT =~ FD ]]; then
	flags="--type=d"
	prompt=" Dirs > "
elif [[  $FZF_PROMPT =~ Dirs ]]; then
	flags="--type=f"
	prompt=" Files > "
else
	flags=""
	prompt=" FD > "
fi
echo "change-prompt($prompt)+reload(eval \$FZF_FD_COMMAND $flags)"

