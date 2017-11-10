#!/usr/bin/env bash
dcos marathon app add https://raw.githubusercontent.com/vishnu2kmohan/dcos-toolbox/master/hdfs/hdfs.json
dcos package install --yes marathon-lb
dcos package install --yes spark
#dcos marathon app add livy.json
dcos marathon app add spark-dispatcher-ucr-hdfs-eventlog-external-volume.json
#
# Configure HDFS for history server
#docker run -it mesosphere/hdfs-client bash
#export PATH=$PATH:/hadoop-2.6.4/bin
#wget http://api.hdfs.marathon.l4lb.thisdcos.directory/v1/endpoints/hdfs-site.xml
#wget http://api.hdfs.marathon.l4lb.thisdcos.directory/v1/endpoints/core-site.xml
#cp core-site.xml hadoop-2.6.4/etc/hadoop
#cp hdfs-site.xml hadoop-2.6.4/etc/hadoop
#hdfs dfs -mkdir -p /history
#hdfs dfs -ls -h -R /
#exit
#exit
#
# dcos marathon app add https://raw.githubusercontent.com/vishnu2kmohan/dcos-toolbox/master/spark/spark-history.json
#dcos marathon app add https://raw.githubusercontent.com/vishnu2kmohan/dcos-toolbox/master/spark/spark-dispatcher-ucr-hdfs-eventlog.json
#dcos marathon app add https://raw.githubusercontent.com/vishnu2kmohan/dcos-toolbox/master/spark/spark-dispatcher-ucr.json


