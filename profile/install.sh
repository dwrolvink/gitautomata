GIT_FOLDER="$HOME/git/gitautomata/profile"
GIT_FUNCTIONS_FOLDER="$GIT_FOLDER/functions"
GIT_CFG_FOLDER="$GIT_FOLDER/config"
FUNCTIONS_FOLDER="$HOME/.local/bin"

# Get commandline options
# -f: Force, or "redo all", even if e.g. a file already exists. Used for updating mostly
# -u: Uninstall, remove gitautomata from the environment

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
function exists {
    ([ -L $1 ] || [ -f $1 ]) && return 0
    return 1
}
function link_file {
    replacing=0
    [ ! -f $1 ] && print_error "ERROR: File $1 does not exist! Skipped." && return 1
    [ $REPLACE -eq 1 ] && exists $2 && rm $2 && echo "Reapplying: $2" && replacing=1
    [ $REPLACE -eq 0 ] && exists $2 && print_verbose "Skipped: File or symlink $2 already exists. Use -f to replace." && return
    [ $replacing -eq 0 ] && ([ ! -L $2 ] && [ ! -f $2 ]) && echo "Installing: $2"

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
    [ $1 -eq 1 ] && link_file $2 $3 && [ $4 -eq 1 ] && chmod +x $2
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
set_file    1   $GIT_FUNCTIONS_FOLDER/reload_profile    $FUNCTIONS_FOLDER/reload_profile        1
set_file    1   $GIT_FUNCTIONS_FOLDER/switch_to         $FUNCTIONS_FOLDER/switch_to             1
set_file    1   $GIT_FUNCTIONS_FOLDER/vv                $FUNCTIONS_FOLDER/vv                    1
set_file    1   $GIT_FUNCTIONS_FOLDER/supload           $FUNCTIONS_FOLDER/supload               1
#set_file   0   $GIT_FUNCTIONS_FOLDER/test              $FUNCTIONS_FOLDER/test                  1

# Insert shell additions to shell rc files
# ========================================
function update_additions {

    # skip if file does not exist
    ! exists $1 && return 

    # remove previous block if exists
    sed -i '/^# <GITAUTOMATA TOP>/,/^# <GITAUTOMATA BOTTOM>/{d}' $1

    # remove newline at end of file if exists
    [ -z "$(tail -n 1 $1)" ] && sed '$d' < ~/.zshrc > /tmp/__gitautomata_temp__ && mv /tmp/__gitautomata_temp__ $1

    # exit now if -u
    [ $UNINSTALL_ALL -eq 1 ] && echo "Removed custom code inclusion @ $1" && return

    # add top marker
    echo -e "\n# <GITAUTOMATA TOP>\n# --------------------------" >> $1

    # add additions
    cat $GIT_CFG_FOLDER/shell_additions.sh >> $1

    # add bottom marker
    echo -e "\n# --------------------------\n# <GITAUTOMATA BOTTOM>" >> $1

    echo "(Re)applied custom code inclusion @ $1"
}

update_additions $HOME/.zshrc