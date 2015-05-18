#!/bin/bash

CUR_DIR=`pwd`
APP_DIR=`dirname $0`
HIVE_USER=$USER

. $APP_DIR/bee-env.sh


TARGET_ENV=$1

if [ "$TARGET_ENV" == "" ]; then
    . $APP_DIR/beepass-default.sh
else
    if [ -f $APP_DIR/beepass-$TARGET_ENV.sh ]; then
        . $APP_DIR/beepass-$TARGET_ENV.sh
    else
        echo "Create a 'beepass-<target>.sh' (use beepass-default.sh as template) file in the beewrap.sh directory and add the following:"
        echo "Omit HIVE_USER is you user id matches your HIVE User id"
        echo " HIVE_USER=<your hive user>"
        echo " HS2_PASSWORD=<your Hive Password>"
        echo " URL=jdbc:hive2://lnx21116.csxt.csx.com:10000"
        echo ""
        echo "chmod the file 700"

    fi
fi

beeline -u $URL -n $HIVE_USER -p $HS2_PASSWORD --hivevar USER=$HIVE_USER  --hivevar EXEC_ENGINE=$EXEC_ENGINE -i $APP_DIR/beeline_init.sql "$@"