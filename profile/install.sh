GIT_FOLDER="$HOME/git/gitautomata/profile"
GIT_FUNCTIONS_FOLDER="$GIT_FOLDER/functions"
FUNCTIONS_FOLDER="$HOME/.local/bin"

# Get commandline options
REPLACE=0
UNINSTALL_ALL=0
while getopts fu flag
do
    case "${flag}" in
        f) REPLACE=1;;
        u) UNINSTALL_ALL=1;;
    esac
done

# Functions
function link_file {
    [ ! -f $1 ] && print_error "ERROR: File $1 does not exist! Skipped." && return
    [ $REPLACE -eq 1 ] && ([ -L $2 ] || [ -f $2 ]) && rm $2 && echo "Replacing: $2"
    [ $REPLACE -eq 0 ] && [ -L $2 ] || [ -f $2 ] && print_verbose "Skipped: File or symlink $2 already exists. Use -f to replace." && return
    ([ ! -L $2 ] && [ ! -f $2 ]) && echo "Installing: $2"

    ln -s $1 $2
    return 0
}
function unlink_file {
    ([ ! -L $2 ] && [ ! -f $2 ]) && print_verbose "Checked absence: $2"
    ([ -L $2 ] || [ -f $2 ]) && rm $2 && echo "Removed: $2"
    return 0
}
function set_file {
    [ $UNINSTALL_ALL -eq 1 ] && unlink_file $2 $3 && return
    [ $1 -eq 1 ] && link_file $2 $3
    [ $1 -eq 0 ] && unlink_file $2 $3
    return 0
}

function print_error {
    echo -e "\e[0;38;5;197m$1\e[0m"
}
function print_verbose {
    echo -e "\e[0;38;5;241m$1\e[0m"
}

# Create target folders if not exist
[ ! -d $FUNCTIONS_FOLDER ] && mkdir -p $FUNCTIONS_FOLDER

# Links programs/scripts
set_file 1 $GIT_FUNCTIONS_FOLDER/switch_to      $FUNCTIONS_FOLDER/switch_to
set_file 1 $GIT_FUNCTIONS_FOLDER/vv             $FUNCTIONS_FOLDER/vv
set_file 0 $GIT_FUNCTIONS_FOLDER/test           $FUNCTIONS_FOLDER/test