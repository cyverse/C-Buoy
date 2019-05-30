#! /bin/bash

exist(){
    command -v "$1" >/dev/null 2>&1
}

use_curl(){
    COUNTER=0
    BOOL=0
    PORT=19999
    PORT_ERROR=00000
    while [[ $COUNTER -lt 402 ]]; do
        if [[ $COUNTER = 0 ]]
        then
            curl --connect-timeout 5 http://cbuoy.cyverse.org:1247 >& /dev/null
            if [ $? -gt 0 ]
            then
                BOOL=1
                PORT_ERROR=1247
                break
            fi
        # COUNTER should be > 0 here
        else
            NUM=$(( $PORT + $COUNTER ))
            echo $NUM
            curl --connect-timeout 5 http://cbuoy.cyverse.org:$NUM >& /dev/null
            echo $?
            if [[ $? -ne 0 ]]
            then
                echo "bad"
                BOOL=1
                PORT_ERROR=$NUM
                break
            fi
        fi
        let COUNTER=COUNTER+1
    done



    if [ $BOOL -eq 0 ]
    then
        echo "You are connected!"
    else
        echo "ERROR: Port connection error found."
        IP=$(curl -s ifconfig.co)
        echo "IP Address ($IP) cannot establish connection with port $PORT_ERROR."
    fi
}



CMD1=curl
CMD2=wget

# checking if curl exist
if exist $CMD1
then
    use_curl
# if curl doesn't exist
#
else
    # checking if wget exist
    if exist $CMD2
    then
        use_wget
    # if both are not available
    else
        echo "ERROR: $CMD1 does not exist!"
        echo "Please install curl, and try running the program again."
    fi
fi
