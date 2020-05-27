# See `man zshbuiltins` for help om autoload in ZSH
#    If you type "print -l $fpath" at the shell prompt, you should see a
#    list of those directories. For ordinary functions, those directories
#    are not scanned by default, you'll have to tell zsh which files to
#    load code from and that is done by using the `autoload' utility.
#    To have a function called `hello', as soon as we tell zsh to try to
#    load the code from a file in `$fpath' as soon as it is referenced for
#    the first time:
#
#                autoload -Uz hello

# TODO: prompt themes have to be looked into later on...
#autoload -Uz promptinit
#promptinit

# Enable colors and change prompt:
autoload -Uz colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

#PROMPT='%B%F{032}%~%f%b %# '
#RPROMPT='%F{105}%*'

# Basic auto/tab complete:
#   compinit is the completion initialization function used by compsys,
#   the 'newer' Z-Shell completion system
# NOTE: compinit is called by home-manager zsh module
#autoload -U compinit
#compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.

# Enable ..<TAB> -> ../
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'


# NOTE: vi mode defined by home-manager module
#bindkey -v

# 10ms for key sequences (near instantaneous switch into normal mode).
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
  zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


#autoload -Uz zmv # move function
#autoload -Uz zed # edit functions within zle
#zle_highlight=(isearch:underline)

#       WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'  # removed /
#typeset WORDCHARS="*?_-.~[]=&;!#$%^(){}<>"

#autoload select-word-style
#select-word-style normal


# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


# zsh has no help command to inspect bash builtins
help() { bash -c "help $@"; }


