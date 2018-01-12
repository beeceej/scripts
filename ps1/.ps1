export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]"
PS1='\[\e]1;\s\$ \W\a\e]2;\u@\h\a\]'"$PS1"
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="$PS1""\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
