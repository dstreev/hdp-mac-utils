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

cd $APP_DIR
. ./mac_env.sh

if [ $# -ne 1 ] ; then
	echo "Please supply the directory where the tarball artifacts were downloaded."
else	
	for i in `cat $APP_DIR/hdp_artifacts.txt | awk '{print $1}'`; do
		cd $1
		T_FILE=$i.tar.gz
		if [ ! -f $T_FILE ]; then
			wget "$HTTP_BASE$T_FILE"
		else
			echo "File exists, skipping: $T_FILE"
		fi
	done
	# Get Helper Files
	cd $1
	#if [ ! -f $COMPANION_FILE.tar.gz ]; then
	#	wget "$TOOLS_BASE$COMPANION_FILE.tar.gz"
	#fi

	# Get Mac Defaults
	#if [ ! -f $DEFAULT_FILES.tar.gz ]; then
	#	wget "$DEFAULT_FILES_BASE$DEFAULT_FILES.tar.gz"
	#fi

	# Get the MySQL Jar for Oozie and Hive.
	if [ ! -f $MYSQL_ARCHIVE.tar.gz ]; then
		wget -O $MYSQL_ARCHIVE.tar.gz "http://dev.mysql.com/get/Downloads/Connector-J/$MYSQL_ARCHIVE.tar.gz/from/http://cdn.mysql.com/"
	fi
	
	# TODO - For OOZIE
	# Get the ext-2.2.zip
	
	
	cd $CUR_DIR
fi

