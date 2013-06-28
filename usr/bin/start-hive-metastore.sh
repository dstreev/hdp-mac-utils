#!/bin/sh

nohup hive --service metastore>$HIVE_LOG_DIR/hive.out 2>$HIVE_LOG_DIR/hive.log &
nohup /usr/lib/hive/bin/hiveserver2>$HIVE_LOG_DIR/hiveserver2.out 2>$HIVE_LOG_DIR/hiveserver2.log &

