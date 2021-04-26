# Description
# Starts / Stops / Checks Mining process
# Can also be used as a cronjob.
# -----------------------------------------------------------------------------

export DISPLAY=:0

if [ "$(id -u)" != "0" ]; then
  echo "You don't have sufficient privileges to run this script."
  exit
fi

# Here you specify the start cmd of your favorite miner.
# Keep as many as you want but remember to have only one uncommented at time
#
# start_lbl     keeps the executable name of your miner
# start_cmd     keeps the whole invocation command of your miner
#               you may want to refer to settings.conf for
#               a list of variables you may use
# stop_sig      keeps the signal to be used for killing miner process
#

# <!-- Begin Editing Area -->

start_lbl="t-rex" 
start_cmd="/root/trex/ETH-2miners.sh
stop_sig="9"
logfile="/home/temp"
pidfile="/home/temp"

# <!-- End Editing Area -->


# Do not change anything below this point unless you know what you're doing

main_status(){
    if [ -s $pidfile ];
    then
        pid=`cat "$pidfile"`
        kill -s 0 $pid >/dev/null 2>&1
        if [ "$?" = "0" ];
        then
            printf "\\n%s is running with process id %s\\n\\n" $start_lbl $pid
            ps -p $pid -o pid,comm,etime,args
            printf "\\n== Last ten entries ==\\n\\n"
            tail -10 $logfile
            echo
            exit 0
        else
            printf "\\n%s with process id %s is not running\\n\\n" $start_lbl $pid
            exit 1
        fi;
    else
        printf "\\n%s appears to be stopped\\n\\n" $start_lbl
    fi;
}

main_start(){
    if [ -s $pidfile ];
    then
        pid=`cat "$pidfile"`
        kill -s 0 $pid >/dev/null 2>&1
        if [ "$?" = "0" ];
        then
            printf "\\n%s is already running with process id %s\\n\\n" $start_lbl $pid
            exit 0
        fi;
    fi;
    
    printf "\\nStarting %s ...\\n\\n" $start_lbl
    touch $logfile
    
    # Set environment variables for EthMiner (mainly needed only for AMD cards)
    #export GPU_FORCE_64BIT_PTR=0
    export GPU_MAX_HEAP_SIZE=100
    export GPU_USE_SYNC_OBJECTS=1
    export GPU_MAX_ALLOC_PERCENT=100
    export GPU_SINGLE_ALLOC_PERCENT=100
    
    # Disable colors
    export NO_COLOR=1
    
    # Start the miner
    nohup $start_cmd > $logfile 2>&1 </dev/null & echo $! > $pidfile & sleep 1;
}

main_stop(){

    if [ -s $pidfile ];
    then
        pid=`cat "$pidfile"`
        kill -s 0 $pid >/dev/null 2>&1
        if [ "$?" = "0" ];
        then
            printf "\\nKilling %s with process id %s \\n" $start_lbl $pid
            while true; 
            do
                read -p "Do you wish to close the program [Y/n] ?" yn
                case $yn in
                [Yy]* ) kill -s $stop_sig $pid >/dev/null 2>&1; exit $?;;
                [Nn]* ) exit;;
                * );;
                esac
            done
        else
            printf "\\n%s is bound to process id %s but the process is not running\\n" $start_lbl $pid
            while true; 
            do
                read -p "Do you want to try with 'killall $start_lbl' [Y/n] ? " yn
                case $yn in
                [Yy]* ) killall -s $stop_sig $start_lbl; exit $?;;
                [Nn]* ) exit;;
                * );;
                esac
            done
        fi;
    else
        printf "\\nCould not find %s process id %s \\n" $start_lbl $pid
        while true; 
        do
            read -p "Do you want to try with 'killall $start_lbl' [Y/n] ? " yn
            case $yn in
            [Yy]* ) killall -s $stop_sig $start_lbl; exit $?;;
            [Nn]* ) exit;;
            * );;
            esac
        done
    fi;
    
}
case "$1" in
-status)    main_status
            ;;
-start)     main_start
            ;;
-stop)      main_stop
            ;;
-help)      clear
            echo " Name "
            echo "      miner.sh"
            echo
            echo " Synopsis"
            echo "      miner.sh -start | -stop | -status | -help"
            echo
            echo " Description"
            echo "      Starts / stops / checks mining process"
            echo
            echo " Options"
            echo "      -start  to start the miner"
            echo "      -stop   to stop the miner"
            echo "      -status to check the status"
            echo "      -help   displays this text"
            echo
            ;;
*)          echo
            echo "Usage : miner.sh -start | -stop | -status | -help"
            echo
            exit 2
            ;;
esac
exit 0
