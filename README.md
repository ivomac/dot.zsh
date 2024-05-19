# ZSH config

Set `ZDOTDIR` to this directory in the system-wide `zshenv`.

[Powerlevel10k](https://github.com/romkatv/powerlevel10k) needs to be installed separately.

Set additional local variables in `./env/secrets.sh`.

## Plugins

### My own

`fzf-nav`: A plugin to navigate the filesystem with fzf.

### As submodules

Run `git submodule update --init --recursive` to fetch the submodules:

```sh
fast-syntax-highlighting
fzf-tab
zsh-abbr
zsh-autosuggestions
zsh-completions
zsh-history-substring-search
```
