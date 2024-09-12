### Helper Functions:

fast-cat() {
  echo -E "$(< $1)"
}

print-git-branch() {
  if [[ -f ".git/HEAD" ]]; then
    echo -E ":${$(fast-cat .git/HEAD)#ref: refs/heads/}"
  fi
}

function greet() {
  fortune | cowthink -f `ls /usr/share/cowsay/cows | shuf -n 1` | lolcat
}
greet


### System-wide Environment:

setopt promptsubst # needed for \$ evaluation

# PS1=(BG_JOB_COUNT>0)PWD:GIT_BRANCH
PS1="\
$(print '%{\e[1;31m%}')%(1j.(%j) .)\
$(print '%{\e[0;36m%}')%d\
$(print '%{\e[1;31m%}')\$(print-git-branch)\
$(print '%{\e[0m%}') \
"

# Need to be in a comma locale for sort -n to properly sort numbers with commas
export LANG=en_NZ.UTF-8

export PATH=$PATH:$HOME/.local/bin  # FHS executables, mostly Python

export EDITOR=nvim
export PAGER=less


### System Aliases:

alias gpr='git pull --rebase'
alias gb='git branch'
alias aggro='git gc --aggressive'
alias gd='git diff'
alias gbsu='git branch --set-upstream'
alias gs='git status'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -a -m'


### Application Config:

## FZF:
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## Python
export PYTHONDONTWRITEBYTECODE=1
alias pip="pip --disable-pip-version-check --require-virtualenv"

## Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

## Rust
PATH="$HOME/cargo/bin:$PATH"

## Javascript
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

## Start X server on login from TTY1:
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  startx
fi
