#!/bin/bash

# Use this to adjust the configuration settings.

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
APP_DIR=`pwd`
. ./mac_env.sh

CONFIG=$1

if [ -d /etc/hadoop ]; then
    sudo rm -r /etc/hadoop
fi

sudo mkdir -p /etc/hadoop

sudo ln -s $HADOOP_CONF_DIR/$CONFIG/hadoop /etc/hadoop/conf

sudo cp -f $HADOOP_CONF_DIR/default/hadoop/hadoop-env.sh $HADOOP_CONF_DIR/$CONFIG/hadoop/
sudo cp -f $HADOOP_CONF_DIR/default/hadoop/yarn-env.sh $HADOOP_CONF_DIR/$CONFIG/hadoop/