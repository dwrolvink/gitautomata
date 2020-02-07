function gitp { git pull; git add --all .; git commit -m "${1}"; git push; }
function c { cd "$1"; clear; ls -1a; }
alias u="cd ..; clear; ls -1a"
