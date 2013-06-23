#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: ./go.sh TEMP_DIR"
else
	USER=`whoami`
	APP_DIR=`dirname $0`
	. $APP_DIR/mac_env.sh

	# Get Artifacts

	# Expand and Link

	# Deploy Defaults, Template and Link

	# Create Hadoop Directories
	if [ ! -d $BASE_CONF_DIR ]; then
		sudo mkdir -P $BASE_CONF_DIR
		sudo chown `whoami` $BASE_CONF_DIR
		mkdir $BASE_CONF_DIR/name $BASE_CONF_DIR/data $BASE_CONF_DIR/snn $BASE_CONF_DIR/mapred
	fi
	# Store pids
	if [ ! -d /var/run/hadoop/$USER ]; then
		sudo mkdir -P /var/run/hadoop/$USER
		sudo chown $USER /var/run/hadoop/$USER
	fi
	# Store Logs
	if [ ! -d /var/log/hadoop/$USER ]; then
		sudo mkdir -P /var/log/hadoop/$USER
		sudo mkdir -P /var/log/hadoop/mapred
		sudo chown $USER /var/log/hadoop/$USER
		sudo chown $USER /var/log/hadoop/mapred
	fi

	# Setup MySql for Hive and HCatalog

fi
