ERRORMSG=1
NOTIFMSG=2
printstepLOG=""

printstep(){
        
        message=${1}
        messageType=${2}
        printOption=${3}
        
        # Colors
        BLUE='\033[0;34m'
        YELLOW='\033[0;33m'
        REEE='\033[0;31m'
        NC='\033[0m' # No Color

        # Message type constants
        ERROR=1
        NOTIFICATION=2
        
        # Printoptions
        # 0/not set     normal behavior
        # 1             don't save to log
                        
        # Build string out
        if [[ $2 -eq $ERROR ]]; 
        then
              strout="${REEE} ${message} ${NC}"
        elif [[ $2 -eq $NOTIFICATION ]];
        then
              strout="${YELLOW} ${1} ${NC}"
        else
              strout="${BLUE} ${1} ${NC}"
        fi
        
        # Save message to log, for later viewing
        if [ "$printOption" != "1" ] ; then
                printstepLOG+="${strout}\n"
        fi
       
       # Echo to console
       echo -e "$strout"
        
}

