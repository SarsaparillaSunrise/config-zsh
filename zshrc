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
  fortune | cowthink -f `ls /usr/share/cowsay/cows | rg -v cupcake | shuf -n 1` | lolcat
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

# http://www.zsh.org/mla/workers/1996/msg00615.html
HISTSIZE=21000
SAVEHIST=20000
mkdir -p ~/.config/zsh
touch    ~/.config/zsh/history
HISTFILE=~/.config/zsh/history

# Make history instantly available in sibling shells
setopt share_history  # TODO: See if append_history or inc_append_history are preferable

# Remove unnecessary spaces in shell commands before saving
setopt HIST_REDUCE_BLANKS

# Prevent commands from entering history when preceded by a space
setopt hist_ignore_space

# Ignore "# comments" typed or pasted into an interactive shell
setopt interactivecomments

# Don't limit `history` output to 16 lines
alias history="fc -l 1"

# Exclude `history` from shell history
setopt HIST_NO_STORE

# Need to be in a comma locale for sort -n to properly sort numbers with commas
export LANG=en_NZ.UTF-8

export PATH=$PATH:$HOME/.local/bin  # FHS executables, mostly Python
export EDITOR=nvim
bindkey -e  # Use emacs keybindings even if EDITOR is set to vi
# -I / --IGNORE-CASE       - Make search ignore case, even if the pattern contains uppercase letters
# -M / --LONG-PROMPT       - Show line position at the bottom
# -x4                      - Set tab stops to multiples of 4
# -R / --RAW-CONTROL-CHARS - Show ANSI color escapes in raw form.  We use this
#                            with `git log` and `paged-with-color`.
# -X / --no-init           - Behave like `cat` if output is fewer than one screen
# -F / --quit-if-one-screen
export LESS="-IMx4RXF"
export LESSHISTFILE=-

# LS_COLORS is used by the :completion: setup below
# inlined eval "$(/usr/bin/dircolors -b)" with some modifications
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=03;34;38:st=37;44:ex=03;31;38:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

autoload -Uz compinit
compinit

### Mostly essential stock settings from /etc/zsh/newuser.zshrc.recommended
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Don't exclude dotfiles when tab-completing
_comp_options+=(globdots)


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

## FZF
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## Emacs
alias emacs="emacs -nw"
alias magit="emacs --eval '(magit-status)'"

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
