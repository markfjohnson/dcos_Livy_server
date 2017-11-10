#!/usr/bin/env bash
set -x
docker build -t markfjohnson/livy:cdh .
docker push markfjohnson/livy:cdh
docker run  -ti markfjohnson/livy:cdh /bin/bash
