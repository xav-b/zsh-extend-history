# Contextual shell history - Zsh Plugin

### Install

- Antigen: `antigen bundle xav-b/zsh-extend-history`
- ZPlug: `zplug "popstas/zsh-command-time"`
- oh-my-zsh:

```Shell
$ git clone https://github.com/xav-b/zsh-extend-history ~/.oh-my-zsh/custom/plugins/extend-history
```

And add `extend-history` to `plugins` in `.zshrc`.


### Configuration

```Zsh
# file to write history
export ZSH_EXTEND_HISTORY_FILE="/tmp/my-gi.history"
```


### Ideas

- Detect git repository and extract info and project
