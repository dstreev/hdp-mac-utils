#!/bin/bash

CUR_DIR=`pwd`
APP_DIR=`dirname $0`


. $APP_DIR/bee-env.sh


beeline -u $URL -n $USER --hivevar USER=$USER  --hivevar EXEC_ENGINE=$EXEC_ENGINE -i $APP_DIR/beeline_init.sql "$@"