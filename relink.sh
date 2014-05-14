#!/bin/sh

################################################
#   Copyright 2013 David Streever
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
################################################

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`
ALL_ELEMENTS="hadoop,hbase,hive,pig,oozie,zookeeper,accumulo,storm,falcon,falcon-server,knox,phoenix,tez,tez-full,flume,sqoop,mahout"
#ALL_ELEMENTS="hadoop,hbase,hive,pig,hcatalog,oozie,flume,sqoop,mahout"

cd $APP_DIR
APP_DIR=`pwd`

HDP_VER=$1

HADOOP_CONF_DIR=/var/hadoop/local/$HDP_VER


echo "===> Expand and Link"

if [ $# -lt 1 ]; then
	echo "Usage: relink.sh $CONF_DIR"
else
	# Link configs to standard location know by scripts
	if [ ! -d /etc/hadoop ]; then
		sudo mkdir /etc/hadoop
	fi
	if [ ! -d /etc/hbase ]; then
		sudo mkdir /etc/hbase
	fi
	if [ ! -d /etc/hive ]; then
		sudo mkdir /etc/hive
	fi
	if [ ! -d /etc/oozie ]; then
		sudo mkdir /etc/oozie
	fi
	if [ ! -d /etc/pig ]; then
		sudo mkdir /etc/pig
	fi
	if [ ! -d /etc/sqoop ]; then
		sudo mkdir /etc/sqoop
	fi
	if [ ! -d /etc/webhcat ]; then
		sudo mkdir /etc/webhcat
	fi
	if [ ! -d /etc/zookeeper ]; then
		sudo mkdir /etc/zookeeper
	fi
	#TODO: NEED VALIDATION ON FLUME CONFIGURATION
	if [ ! -d /etc/flume ]; then
		sudo mkdir /etc/flume
	fi

	# Remove old symlinks
	if [ -d /etc/hadoop/conf ]; then
		sudo rm /etc/hadoop/conf
	fi
	if [ -d /etc/hbase/conf ]; then
		sudo rm /etc/hbase/conf
	fi
	if [ -d /etc/hive/conf ]; then
		sudo rm /etc/hive/conf
	fi
	if [ -d /etc/oozie/conf ]; then
		sudo rm /etc/oozie/conf
	fi
	if [ -d /etc/pig/conf ]; then
		sudo rm /etc/pig/conf
	fi
	if [ -d /etc/sqoop/conf ]; then
		sudo rm /etc/sqoop/conf
	fi
	if [ -d /etc/webhcat/conf ]; then
		sudo rm /etc/webhcat/conf
	fi
	if [ -d /etc/zookeeper/conf ]; then
		sudo rm /etc/zookeeper/conf
	fi

	# Set/Reset symlinks
	sudo ln -s $HADOOP_CONF_DIR/core_hadoop /etc/hadoop/conf
	sudo ln -s $HADOOP_CONF_DIR/hbase /etc/hbase/conf
	sudo ln -s $HADOOP_CONF_DIR/hive /etc/hive/conf
	sudo ln -s $HADOOP_CONF_DIR/oozie /etc/oozie/conf
	sudo ln -s $HADOOP_CONF_DIR/pig /etc/pig/conf
	sudo ln -s $HADOOP_CONF_DIR/sqoop /etc/sqoop/conf
	sudo ln -s $HADOOP_CONF_DIR/webhcat /etc/webhcat/conf
	sudo ln -s $HADOOP_CONF_DIR/zookeeper /etc/zookeeper/conf

fi
