alias rspec="bundle exec rspec"
alias ls='ls -hF'

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PATH=$PATH:/myapp/bin

PS1="🚃($RAILS_ENV)🕎$(parse_git_branch)\[\033[00m\]\$: "