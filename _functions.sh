ERRORMSG=1
NOTIFMSG=2

printstep(){
        BLUE='\033[0;34m'
        YELLOW='\033[0;33m'
        REEE='\033[0;31m'
        NC='\033[0m' # No Color

        ERROR=1
        NOTIFICATION=2

        if [[ $2 -eq $ERROR ]]; 
        then
              echo -e "${REEE} ${1} ${NC}"
              
        elif [[ $2 -eq $NOTIFICATION ]];
        then
              echo -e "${YELLOW} ${1} ${NC}"
        else
              echo -e "${BLUE} ${1} ${NC}"
        fi
}

