#!/usr/bin/env bash
set -x
docker build -t markfjohnson/livy:0.50a .
docker push markfjohnson/livy:0.50a
#docker run  -ti markfjohnson/livy:0.50 /bin/bash
