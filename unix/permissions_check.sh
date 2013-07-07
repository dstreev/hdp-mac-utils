#!/bin/bash

# Check the permissions on the directories for hadoop
chown -R hdfs:hadoop /usr/lib/hadoop
chown -R hdfs:hadoop /etc/hadoop

chmod -R o+r /usr/lib/hadoop
chmod -R g+r /usr/lib/hadoop
chmod -R o+x /usr/lib/hadoop/*.sh
chmod -R g+r /etc/hadoop
