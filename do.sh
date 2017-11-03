#mvn install:install-file -DgroupId=jdk.tools -DartifactId=jdk.tools -Dpackaging=jar -Dversion=1.8 -Dfile=tools.jar -DgeneratePom=truecd 
docker build -f Spark_Docker -t markfjohnson:livy_spark .
docker run  -ti markfjohnson:livy_spark bash