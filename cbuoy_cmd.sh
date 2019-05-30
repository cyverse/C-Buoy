#! /bin/bash

CONNECT_SUCCCESS=0
TIME_OUT=5
PORT_START=20000
PORT_END=20399
PORT_ERROR=0
CMD1=curl
CMD2=wget
CMD_TO_USE=curl                 # default command for cbuoy test connection


main(){
    # checking if curl exist
    if exist $CMD1
    then
        CMD_TO_USE=$CMD1
        test_connection
        is_success
    # if curl doesn't exist
    #
    else
        # checking if wget exist
        if exist $CMD2
        then
            CMD_TO_USE=$CMD2
            test_connection
            is_success
        # if both are not available
        else
            echo "ERROR: $CMD1 does not exist!"
            echo "Please install curl, and try running the program again."
        fi
    fi
}


# this function checks if a command is intalled in the system
exist(){
    command -v "$1" >/dev/null 2>&1
}

# this function tests the connection between the server and the assigned ports
test_connection(){
    # checking the Port 1247 first
    run_cmd 1247
    if [ $? -gt 0 ]
    then
        CONNECT_SUCCCESS=1
        PORT_ERROR=1247
        return
    fi
    #checking Ports 20000-20399
    for PORT in $(seq $PORT_START $PORT_END); do
        run_cmd $PORT
        if [ $? -gt 0 ]
        then
            CONNECT_SUCCCESS=1
            PORT_ERROR=$PORT
            return
        fi
    done
}

# this function determines which of the two commands/functions to be executed
# being called in the test_connection function
# argument '$1' is the port number
run_cmd(){
    if [ $CMD_TO_USE = $CMD1 ]
    then
        use_curl $1
    else
        use_wget $1
    fi
}

# curl command
# sets the connection timeout to 5 seconds
use_curl(){
    $CMD1 --connect-timeout $TIME_OUT http://cbuoy.cyverse.org:$1 >& /dev/null
}

# wget command
# sets the connection timeout to 5 seconds and limits the retry connection to one
# --spider option prevents downloading the source's *.html file (index.html)
use_wget(){
    $CMD2 --spider --connect-timeout=$TIME_OUT --tries=1 http://cbuoy.cyverse.org:$1 >& /dev/null
}

# this function checks the connection response and prints the appropriate message
is_success(){
    if [ $CONNECT_SUCCCESS -eq 1 ]
    then
        print_error
    else
        print_success
    fi
}

# prints an error message
print_error(){
    echo "ERROR: Port connection error found."
    IP=$(curl -s ifconfig.co)
    echo "IP Address ($IP) cannot establish connection with port $PORT_ERROR."
}

# prints a success message
print_success(){
    echo "You are connected!"
}

main
