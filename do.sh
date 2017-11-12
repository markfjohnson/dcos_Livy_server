#!/usr/bin/env bash
set -x
docker build -t markfjohnson/livy:0.50 .
docker push markfjohnson/livy:0.50
#docker run  -ti markfjohnson/livy:0.50 /bin/bash
