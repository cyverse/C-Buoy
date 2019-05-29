#! /bin/bash

exist(){
    command -v "$1" >/dev/null 2>&1
}

use_curl(){
    COUNTER=0
    while [ $COUNTER -lt 401 ]; do
        if [ $COUNTER -eq 0 ]
        then
            curl --connect-timeout 5 http://cbuoy.cyverse.org:1247
            
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
