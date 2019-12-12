#!/bin/sh

CONFIG="/rocketmq/data/conf/broker.properties"

startNamesrv(){
    if [ ! -z "$JAVA_OPT_EXT" ];then
        sed -i "s/-Xms4g -Xmx4g -Xmn2g/$JAVA_OPT_EXT/" /opt/rocketmq/bin/runserver.sh
    fi
    /opt/rocketmq/bin/mqnamesrv
}

startBroker(){
    if [ ! -f $CONFIG ];then
        mkdir -p /rocketmq/data/conf
        mv /opt/broker.properties /rocketmq/data/conf/
    fi

    if [ ! -z "$BROKERNAME" ];then
        sed -i "s/broker-a/$BROKERNAME/" $CONFIG
    fi

    if [ ! -z "$BROKERROLE" ];then
        if [ "$BROKERROLE" = "SYNC_MASTER" ];then
            sed -i "s/ASYNC_MASTER/SYNC_MASTER/" $CONFIG
        elif [ "$BROKERROLE" = "SLAVE" ];then
            sed -i "s/ASYNC_MASTER/SLAVE/" $CONFIG
            sed -i "s/brokerId=0/brokerId=1/" $CONFIG
        else
            echo "Invalid argument"
        fi
    fi

    if [ ! -z "$BROKERIP" ];then
        sed -i "s/BROKER_IP/$BROKERIP/g" $CONFIG
    fi

    if [ ! -z "$PORT" ];then
        sed -i "s/10911/$PORT/" $CONFIG
    fi
    
    if [ ! -z "$NAMESRV" ];then
        sed -i "s/127.0.0.1:9876/$NAMESRV/" $CONFIG
    fi

    if [ ! -z "$JAVA_OPT_EXT" ];then
        sed -i "s/-Xms8g -Xmx8g -Xmn4g/$JAVA_OPT_EXT/" /opt/rocketmq/bin/runbroker.sh
    fi

    /opt/rocketmq/bin/mqbroker -c $CONFIG

}

if [ "$1"x = "mqbroker"x ];then
    startBroker
else
    startNamesrv
fi
