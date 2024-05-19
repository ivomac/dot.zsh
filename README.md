# ZSH config

My personal ZSH configuration.

## Needed configuration

Set the `ZDOTDIR` to this directory in your `.zshenv`:

[Powerlevel10k](https://github.com/romkatv/powerlevel10k) needs to be installed separately.

## Plugins

### My own

`fzf-nav`: A plugin to navigate the filesystem with fzf. See included README for more information.

### As submodules

Run `git submodule update --init --recursive` to fetch the submodules:

```sh
fast-syntax-highlighting
fzf-tab
zsh-abbr
zsh-autosuggestions
zsh-completions
zsh-history-substring-search
zsh-vi-mode
```
