#! /bin/bash

exist(){
    command -v "$1" >/dev/null 2>&1
}

use_curl(){
    COUNTER=0
    BOOL=0
    PORT=19999
    PORT_ERROR=00000
    while [ $COUNTER -lt 401 ]; do
        if [ $COUNTER -eq 0 ]
        then
            curl --connect-timeout 5 http://cbuoy.cyverse.org:1247
            if [ $? -gt 0 ]
            then
                BOOL=1
                PORT_ERROR=1247
                break
            fi
        # COUNTER should be > 0 here
        else
            NUM=$(( $PORT + $COUNTER ))
            curl --connect-timeout 5 http://cbuoy.cyverse.org:$NUM
            if [ $? -gt 0 ]
            then
                BOOL=1
                PORT_ERROR=$NUM
                break
            fi
        fi
    done

    if [ $BOOL -eq 0 ]
    then
        echo "You are connected!"
    else
        echo "ERROR: Port connection error found."
        IP_ADD=curl ifconfig.co
        echo "IP Address ($IP_ADD) cannot establish connection with port $PORT_ERROR."
    fi
}

use_wget(){

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
