#!/bin/sh

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
. ./mac_env.sh

if [ $# -ne 1 ]; then

else
	TARGET_DIR=$1
	cd $LIB_BASE_DIR
	if [ -d hadoop-$HADOOP_VER ]; then
		sudo tar xzvf $TARGET_DIR/hadoop-$HADOOP_VER.tar.gz
	fi
	if [ -d pig-$PIG_VER ]; then
		sudo tar xzvf $TARGET_DIR/pig-$PIG_VER.tar.gz
	fi
	if [ -d hive-$HIVE_VER ]; then
		sudo tar xzvf $TARGET_DIR/hive-$HIVE_VER.tar.gz
	fi
	if [ -d hcatalog-$HCATALOG_VER ]; then
		sudo tar xzvf $TARGET_DIR/hcatalog-$HCATALOG_VER.tar.gz
	fi
	if [ -d oozie-$OOZIE_VER ]; then
		sudo tar xzvf $TARGET_DIR/oozie-$OOZIE_VER.tar.gz
	fi
	if [ -d sqoop-$SQOOP_VER ]; then
		sudo tar xzvf $TARGET_DIR/sqoop-$SQOOP_VER.tar.gz
	fi
	if [ -d apache-flume-$FLUME_VER ]; then
		sudo tar xzvf $TARGET_DIR/apache-flume-$FLUME_VER.tar.gz
	fi

	# Link
	if [ -e hadoop ]; then
		sudo rm hadoop pig hive hcatalog oozie sqoop apache-flume
	fi
	sudo ln -s hadoop-$HADOOP_VER hadoop
	sudo ln -s pig-$PIG_VER hadoop
	sudo ln -s hive-$HIVE_VER hadoop
	sudo ln -s hcatalog-$HCATALOG_VER hadoop
	sudo ln -s oozie-$OOZIE_VER hadoop
	sudo ln -s sqoop-$SQOOP_VER hadoop
	sudo ln -s apache-flume-$FLUME_VER hadoop
	
fi
