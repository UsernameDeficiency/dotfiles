# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [[ -f /usr/bin/fastfetch ]]; then
    fastfetch
fi

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# Don't put common commands in history
HISTIGNORE="clear:exit:history:l:l[alst]:rm*"

# Append to the history file, don't overwrite it
shopt -s histappend
# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "${TERM}" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+(${debian_chroot})}\u@\h: \w\a\]${PS1}"
    ;;
*)
    ;;
esac

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features. Might not be necessary.
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

# Make touch screen scrolling work in Firefox
if [[ "${XDG_SESSION_TYPE}" == "wayland" ]]; then
    export MOZ_ENABLE_WAYLAND=1
else
    export MOZ_USE_XINPUT2=1
fi

# Add root only applications to PATH
export PATH="/sbin:${PATH}"

# Init oh-my-posh. Themes I like: catppuccin_frappe, amro, craver, tiwahu, pure
#eval "$(~/.local/bin/oh-my-posh init bash --config ~/.cache/oh-my-posh/themes/catppuccin_frappe.omp.json)"

# Editor for sudoedit (sudo -e)
export EDITOR=nvim
export VISUAL=nvim

