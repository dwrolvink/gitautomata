function gitp { git pull; git add --all .; git commit -m "${1}"; git push; }
function c { cd "$1"; clear; ls -1a; }
alias u="cd ..; clear; ls -1a"

alias ls="ls --color=auto -l" 
alias prun="php -S 0.0.0.0:8080"
alias gc="git clone"
alias rmf="rm -rf"
alias nano="nano -w"
