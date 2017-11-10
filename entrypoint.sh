#!/bin/bash

export LIBPROCESS_IP=0.0.0.0
export LIBPROCESS_PORT=7228
export SPARK_MESOS_DISPATCHER_HOST=0.0.0.0
echo "Running entrypoint"
/opt/spark/dist/sbin/start-mesos-dispatcher.sh --master mesos://zk://zk-1.zk:2181 &
/apps/build/$LIVY_BUILD_PATH/bin/livy-server start

