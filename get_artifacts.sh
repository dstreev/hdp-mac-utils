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

# Check for an output dir in args.

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`
ALL_ELEMENTS="hadoop,hbase,hive,pig,oozie,zookeeper,accumulo,storm,falcon,falcon-server,knox,phoenix,tez,tez-full,flume,sqoop,mahout"
#ALL_ELEMENTS="hadoop,hbase,hive,pig,hcatalog,oozie,zookeeper,flume,sqoop,mahout"

cd $APP_DIR
. ./mac_env.sh

echo "===> Get Artifacts"

if [ $# -lt 1 ] ; then
	echo "Please supply the directory where the tarball artifacts were downloaded."
else

	if [ ! -f $1/${COMPANION_FILE_BASE}.tar.gz ] ; then
    	pushd $1
    	wget "${TOOLS_BASE}${COMPANION_FILE_BASE}.tar.gz"
    	popd
	fi 
	
	ELEMENTS="${2:-$ALL_ELEMENTS}"

# 	for i in `cat $APP_DIR/hdp_artifacts.txt | awk '{print $1}'`; do
	cat $APP_DIR/hdp_artifacts.txt | while read next; do
		T_FILE=`echo $next | awk '{print $1}'`
		T_LINK=`echo $next | awk '{print $2}'`
		
		cd $1
		if [[ "$ELEMENTS" =~ $T_LINK ]]; then
			echo "Getting $T_LINK"
			T_FILE=$T_FILE.tar.gz
			if [ ! -f $T_FILE ]; then
				wget "${HTTP_BASE}${T_FILE}"
			else
				echo "File exists, skipping: ${T_FILE}"
			fi
		else
			echo "Skipping ${T_LINK}, not a requested element"
		fi
	done

	cd $1

	# Get the MySQL Jar for Oozie and Hive.
	if [ ! -f $MYSQL_ARCHIVE.tar.gz ]; then
		wget -O $MYSQL_ARCHIVE.tar.gz "http://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_ARCHIVE}.tar.gz/from/http://cdn.mysql.com/"
	fi
	
	# TODO - For OOZIE
	# Get the ext-2.2.zip
	
	
	cd $CUR_DIR
fi

