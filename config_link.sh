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

!!! WORK IN PROGRESS
The hadoop libs are borken into hdfs mapred and yarn.  In the linux distro, they are all separated out.  With the tarballs, they aren't.


# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`
#ALL_ELEMENTS="hadoop,hbase,hive,pig,oozie,zookeeper,accumulo,storm,falcon,falcon-server,knox,phoenix,tez,tez-full,flume,sqoop,mahout"
#ALL_ELEMENTS="hadoop,hbase,hive,pig,hcatalog,oozie,flume,sqoop,mahout"

cd $APP_DIR
APP_DIR=`pwd`
#. ./mac_env.sh

echo "===> Re-Link configs to $1"

if [ $# -lt 1 ]; then
	echo "Usage: config_link.sh CONF_DIR [elements]"
else
    HADOOP_CONF_DIR=/var/hadoop/local/$1
	LIB_BASE_DIR=/usr/lib

	ELEMENTS="${2:-$ALL_ELEMENTS}"

	cat $APP_DIR/hdp_artifacts.txt | while read next; do
		T_FILE=`echo $next | awk '{print $1}'`
		T_LINK=`echo $next | awk '{print $2}'`
		
		cd $LIB_BASE_DIR
		        		
		if [[ "$ELEMENTS" =~ $T_LINK ]]; then
		
			echo "Reseting: $T_LINK links"
		
			# The Oozie distribution is inconsistent when extracted
			T_FILE_FIXED=`echo $T_FILE | sed s/-distro//`
		
			# Get the version information
			APP_VER=`echo $T_FILE_FIXED | sed s/$T_LINK\-//`
			echo "App: $T_LINK"
			echo "	Fixed File: $T_FILE_FIXED"
			echo "	Version: $APP_VER"
		
			sudo ln -s $HADOOP_CONF_DIR/$T_FILE_FIXED $T_LINK

			# Reset the local conf's to link to /etc/$app/conf
			# Because of the lack of consistency of the startup scripts across products
# 			cd $T_LINK
			sudo rm -rf $T_LINK/conf
			sudo ln -s /etc/$T_LINK/conf $T_LINK/conf

			# Special hcatalog symlinks required
# 			if [ "hcatalog" == "$T_LINK" ]; then
# 				cd share/hcatalog
# 				for j in hcatalog-core hcatalog-pig-adapter hcatalog-server-extensions; do
# 					sudo ln -s $j-$APP_VER.jar $j.jar 						
# 				done
# 			fi

			cd $LIB_BASE_DIR
		else
			echo "Skipping $T_LINK, not a requested element"
		fi		
	done
	
	
	# Expand the Templates and Link
	# DON'T OVERWRITE IF THEY ARE THERE ALREADY
	if [ -d $HADOOP_CONF_DIR/core_hadoop ]; then
		echo "Configs are already present, they have NOT been overwritten"
	else

		echo ""
		echo "Setting up config links"
		
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
	fi

	# Remove old symlinks
	if [ -d /etc/hadoop/conf ]; then
		sudo rm -rf /etc/hadoop/conf
	fi
	if [ -d /etc/hbase/conf ]; then
		sudo rm -rf /etc/hbase/conf
	fi
	if [ -d /etc/hive/conf ]; then
		sudo rm -rf /etc/hive/conf
	fi
	if [ -d /etc/oozie/conf ]; then
		sudo rm -rf /etc/oozie/conf
	fi
	if [ -d /etc/pig/conf ]; then
		sudo rm -rf /etc/pig/conf
	fi
	if [ -d /etc/sqoop/conf ]; then
		sudo rm -rf /etc/sqoop/conf
	fi
	if [ -d /etc/webhcat/conf ]; then
		sudo rm -rf /etc/webhcat/conf
	fi
	if [ -d /etc/zookeeper/conf ]; then
		sudo rm -rf /etc/zookeeper/conf
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

	echo "  === DONE: Don't forget to adjust your configs for 'localhost'"
fi
