#!/bin/sh
# Check for an output dir in args.

# Set parameters
APP_DIR=`dirname $0`
CUR_DIR=`pwd`

cd $APP_DIR
. ./mac_env.sh

if [ $# -ne 1 ] ; then
	echo "Please supply a target directory for the artifacts"
else	
	for i in `cat $APP_DIR/hdp_artifacts`; do
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
	if [ ! -f $COMPANION_FILE.tar.gz ]; then
		wget "$TOOLS_BASE$COMPANION_FILE.tar.gz"
	fi

	# Get Mac Defaults
	if [ ! -f $DEFAULT_FILES ]; then
		wget "$DEFAULT_FILES_BASE$DEFAULT_FILES.tar.gz"
	fi

	cd $CUR_DIR
fi

