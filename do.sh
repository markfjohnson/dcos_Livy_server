#!/usr/bin/env bash
set -x
docker build -t markfjohnson/livy:0.40 .
#docker push markfjohnson/livy:0.40
docker run  -ti markfjohnson/livy:0.40 /bin/bash
