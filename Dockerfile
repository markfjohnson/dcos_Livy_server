FROM mesosphere/spark:1.1.0-2.1.1-hadoop-2.6
MAINTAINER Mark Johnson <mjohnson@mesosphere.com>

ENV SPARK_VERSION=2.1.1 def=$SPARK_VERSION
ENV LIVY_BUILD_VERSION livy-server-0.3.0-SNAPSHOT
ENV SPARK_HOME /opt/spark/dist

# Set install path for Livy
ENV LIVY_APP_PATH /apps/$LIVY_BUILD_VERSION

RUN apt-get update
#RUN apt-get --purge reinstall oracle-java7-installer
#RUN apt-get upgrade
#RUN add-apt-repository ppa:webupd8team/java -y 
#RUN apt-get update
#RUN apt-get install oracle-java8-installer
#RUN update-alternatives --config java


RUN apt-get install -yq --no-install-recommends --force-yes maven
RUN apt-get install -y git build-essential libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip 


# Clone Livy repository


RUN env
RUN mkdir -p /apps/build && \
    cd /apps/build && \
    git clone https://github.com/cloudera/livy.git && \
    cd livy && \
    mvn package -Dspark.version=$SPARK_VERSION
    
#RUN cd $LIVY_BUILD_PATH && \
#    mvn -DskipTests -Dspark.version=$SPARK_VERSION package && \
#    unzip $LIVY_BUILD_PATH/assembly/target/$LIVY_BUILD_VERSION.zip -d /apps && \
#    rm -rf $LIVY_BUILD_PATH && \
#	mkdir -p $LIVY_APP_PATH/upload
	
# Add custom files, set permissions
#ADD entrypoint.sh .

#RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8998

#ENTRYPOINT ["/entrypoint.sh"]
  
