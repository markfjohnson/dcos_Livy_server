docker build -t markfjohnson/livy_spark:0.10 .
docker run  -ti markfjohnson/livy_spark:0.10 /bin/bash
docker push markfjohnson/livy_spark