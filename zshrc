fast-cat() {
	echo -E "$(< $1)"
}

print-git-branch() {
	if [[ -f ".git/HEAD" ]]; then
		echo -E ":${$(fast-cat .git/HEAD)#ref: refs/heads/}"
	fi
}

setopt promptsubst # needed for \$ evaluation
# PS1=(BG_JOB_COUNT>0)PWD:GIT_BRANCH
PS1="\
$(print '%{\e[1;31m%}')%(1j.(%j) .)\
$(print '%{\e[0;36m%}')%d\
$(print '%{\e[1;31m%}')\$(print-git-branch)\
$(print '%{\e[0m%}') \
"
