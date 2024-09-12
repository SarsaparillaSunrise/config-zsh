# Helper Functions:

fast-cat() {
	echo -E "$(< $1)"
}

print-git-branch() {
	if [[ -f ".git/HEAD" ]]; then
		echo -E ":${$(fast-cat .git/HEAD)#ref: refs/heads/}"
	fi
}

# Environment Variables:

setopt promptsubst # needed for \$ evaluation

# PS1=(BG_JOB_COUNT>0)PWD:GIT_BRANCH
PS1="\
$(print '%{\e[1;31m%}')%(1j.(%j) .)\
$(print '%{\e[0;36m%}')%d\
$(print '%{\e[1;31m%}')\$(print-git-branch)\
$(print '%{\e[0m%}') \
"

# Git Aliases:

alias gpr='git pull --rebase'
alias gb='git branch'
alias aggro='git gc --aggressive'
alias gd='git diff'
alias gbsu='git branch --set-upstream'
alias gs='git status'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -a -m'
