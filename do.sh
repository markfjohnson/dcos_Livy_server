#!/usr/bin/env bash
set -x
docker build -t markfjohnson/livy:0.10 .
docker push markfjohnson/livy:0.10
#docker run  -ti markfjohnson/livy:0.10 /bin/bash
