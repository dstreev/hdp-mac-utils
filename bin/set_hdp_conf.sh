#!/bin/bash

# Use this to adjust the configuration settings.

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
APP_DIR=`pwd`
. ../mac_env.sh

CONFIG=$1

if [ -d /etc/hadoop ]; then
    sudo rm -rf /etc/hadoop
    sudo rm -rf /etc/hive
    sudo rm -rf /etc/hbase
    sudo rm -rf /etc/zookeeper
fi

sudo mkdir -p /etc/hadoop
sudo mkdir -p /etc/hive
sudo mkdir -p /etc/hbase
sudo mkdir -p /etc/zookeeper

sudo ln -s $HADOOP_CONF_DIR/$CONFIG/hadoop /etc/hadoop/conf
sudo ln -s $HADOOP_CONF_DIR/$CONFIG/hive /etc/hive/conf
sudo ln -s $HADOOP_CONF_DIR/$CONFIG/hbase /etc/hbase/conf
sudo ln -s $HADOOP_CONF_DIR/$CONFIG/zookeeper /etc/zookeeper/conf

sudo cp -f $HADOOP_CONF_DIR/default/hadoop/hadoop-env.sh $HADOOP_CONF_DIR/$CONFIG/hadoop/
sudo cp -f $HADOOP_CONF_DIR/default/hadoop/yarn-env.sh $HADOOP_CONF_DIR/$CONFIG/hadoop/