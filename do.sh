#!/bin/sh

#TODO: Validate/add support for:
#	webhcat
#	hbase
#	flume
# 	zookeeper

if [ $# -ne 1 ]; then
	echo "Usage: ./go.sh TEMP_DIR"
else
	USER=`whoami`
	APP_DIR=`dirname $0`
	. $APP_DIR/mac_env.sh

	# Get Artifacts
	. $APP_DIR/get_artifacts.sh

	# Deploy Defaults, Template and Link

	# Create Hadoop HDFS and Storage Directories
	if [ ! -d $HDFS_BASE_DIR ]; then
		sudo mkdir -p $HDFS_BASE_DIR
		sudo chown `whoami` $HDFS_BASE_DIR
		mkdir $HDFS_BASE_DIR/name $HDFS_BASE_DIR/data $HDFS_BASE_DIR/snn $HDFS_BASE_DIR/mapred
	fi

	if [ ! -d $HADOOP_CONF_DIR ]; then
		sudo mkdir -p $HADOOP_CONF_DIR
		sudo chown `whoami` $HADOOP_CONF_DIR
	else
		sudo chown `whoami` $HADOOP_CONF_DIR
	fi

	# Store pids
	if [ ! -d /var/run/hadoop/$USER ]; then
		sudo mkdir -p /var/run/hadoop/$USER
		sudo chown $USER /var/run/hadoop/$USER
	fi
	# Store Logs
	if [ ! -d /var/log/hadoop/$USER ]; then
		sudo mkdir -p /var/log/hadoop/$USER
		sudo mkdir -p /var/log/hadoop/mapred
		sudo chown $USER /var/log/hadoop/$USER
		sudo chown $USER /var/log/hadoop/mapred
	fi

	# Expand and Link
	. $APP_DIR/expand_link.sh $1

	# Setup MySql for Hive and HCatalog

fi
