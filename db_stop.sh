###### Sub functions ######
function __prt_msg() {
    clrText='\033[32m'
    clrEND='\033[0m'
    echo -e $clrText$1$clrEND 
}
function __scr_msg() {
    printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$1" | base64)
}

function __is_running() {
    if test $( pgrep -f $1 | wc -l ) -eq 0 
    then 
        # 没有该进程
        retval=0
    else 
        # 已存在该进程
        retval=1
    fi 
    return "$retval"
}

###### Nginx ######
__scr_msg ""

__is_running 'nginx'
retval=$?
if [ $retval == 1 ]
then
    __prt_msg 'Killing Nginx ... \c'
    sudo pkill -9 nginx 
    __prt_msg 'OK \n'
fi
sleep 2 

###### MySql ######
__is_running 'mysqld'
retval=$?
if [ $retval == 1 ]
then
    __prt_msg 'Stoping mysqld ... \c'
    mysql.server stop 
    __prt_msg 'OK\n'
fi

###### Redis ######
__is_running 'redis-server'
retval=$?
if [ $retval == 1 ]
then
    __prt_msg 'Stoping redis-server ... \c'
    redis-cli -h 127.0.0.1 -p 6379 shutdown
    __prt_msg 'OK\n'
fi

###### MongoD ######
__is_running 'mongod'
retval=$?
if [ $retval == 1 ]
then
    __prt_msg 'Stoping mongod ... \c'
    mongo < command.mongo
    __prt_msg 'OK\n'
fi
