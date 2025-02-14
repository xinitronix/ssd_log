#!/usr/local/bin/bash

# Execution of virtual machines requires root previleges
if test "$(id -u)" -ne 0; then
	printf "%s must be run as root\n" "${0##*/}"
	exit 1
fi

LOG_PATH=$HOME/ssd
LOG_FILE=$(date '+%Y-%m-%d').log

print_TBW () {
                 mkdir -p $LOG_PATH
                 echo "$i=$tbw_gb GB" >> $LOG_PATH/$LOG_FILE
                 echo "$i=$tbw    TB"       

}

get_TBW () {

disk="
/dev/ada0
/dev/ada1
/dev/ada3
/dev/ada4
"             
              echo $(date +"%T") >>   $LOG_PATH/$LOG_FILE
              for i in ${disk};do  
                 size=$(smartctl -a $i | grep Total_LBAs_Written | awk '{print $10}')
                 let tbw=$size*512/1024/1024/1024/1024
                 let tbw_gb=$size*512/1024/1024/1024
                 print_TBW
              done 
}

get_TBW