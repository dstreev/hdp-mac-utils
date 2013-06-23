#!/bin/sh

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
. ./mac_env.sh

if [ $# -ne 1 ]; then

else
	SOURCE_DIR=$1
	cat $APP_DIR/hdp_artifacts.txt | while read next; do
		T_FILE=`echo $next | awk '{print $1}'`
		T_LINK=`echo $next | awk '{print $2}'`
		
		cd $LIB_BASE_DIR
		if [ -d $T_FILE ]; then
			sudo rm -rf $T_FILE $T_LINK
			sudo tar xzvf $SOURCE_DIR/$T_FILE.tar.gz
			sudo ln -s $T_FILE $T_LINK
		fi 	

	done
	
	# Link JDBC drivers
	cat $APP_DIR/jdbc_cfg.txt | while read next; do
		J_FILE=`echo $next | awk '{print $1}'`
		J_LINK=`echo $next | awk '{print $2}'`

		ln -s $J_FILE $LIB_BASE_DIR/hive/lib/$J_LINK
	done

	# Expand the Defaults
	if [ ! -d $DEFAULT_DIR ]; then
		sudo mkdir -P $DEFAULT_DIR	
	fi	

	cd $DEFAULT_DIR

	tar xzvf $SOURCE_DIR/$DEFAULT_FILE.tar.gz

	# Expand the Templates and Link
	# DON'T OVERWRITE IF THEY ARE THERE ALREADY
	if [ -d $HADOOP_CONF_DIR/core_hadoop ]; then
		echo "Configs are already present, they have NOT been overwritten"
	else
		cd $SOURCE_DIR
		if [ ! -f $COMPANION_FILE ]; then
			echo "Expanding companion files"
			tar xvzf $COMPANION_FILE.tar.gz
		fi	
			
		cd $COMPANION_FILE/configuration_files
		cp -R * $HADOOP_CONF_DIR

		echo "NOTICE: You MUST now edit all the appropriate configs in the $HADOOP_CONF_DIR directory for your environment."
		echo "	You need to change settings in:"
		echo "		core_hadoop, hive, oozie, pig, sqoop, webhcat, zookeeper"
		echo ""
		echo "  Review the configs in these directories and configure for -localhost-"
		
		# Link configs to standard location know by scripts
		if [ ! -d /etc/hadoop ]; then
			sudo mkdir /etc/hadoop
		fi
		if [ ! -d /etc/hive ]; then
			sudo mkdir /etc/hive
		fi
		if [ ! -d /etc/pig ]; then
			sudo mkdir /etc/pig
		fi
		if [ ! -d /etc/sqoop ]; then
			sudo mkdir /etc/sqoop
		fi
		if [ ! -d /etc/zookeeper ]; then
			sudo mkdir /etc/zookeeper
		fi
		if [ ! -d /etc/oozie ]; then
			sudo mkdir /etc/oozie
		fi
		#TODO: NEED VALIDATION ON FLUME CONFIGURATION
		if [ ! -d /etc/flume ]; then
			sudo mkdir /etc/flume
		fi
	fi

	# Remove old symlinks
	sudo /etc/hadoop/conf
	sudo /etc/hive/conf
	sudo /etc/oozie/conf
	sudo /etc/pig/conf
	sudo /etc/sqoop/conf
	sudo /etc/webhcat/conf

	# Set/Reset symlinks
	sudo ln -s $HADOOP_CONF_DIR/core_hadoop /etc/hadoop/conf
	sudo ln -s $HADOOP_CONF_DIR/hive /etc/hive/conf
	sudo ln -s $HADOOP_CONF_DIR/oozie /etc/oozie/conf
	sudo ln -s $HADOOP_CONF_DIR/pig /etc/pig/conf
	sudo ln -s $HADOOP_CONF_DIR/sqoop /etc/sqoop/conf
	sudo ln -s $HADOOP_CONF_DIR/webhcat /etc/webhcat/conf
	sudo ln -s $HADOOP_CONF_DIR/zookeeper /etc/zookeeper/conf

fi
