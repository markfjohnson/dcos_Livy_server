FROM mesosphere/spark:1.1.0-2.1.1-hadoop-2.6
MAINTAINER Mark Johnson <mjohnson@mesosphere.com>

ENV SPARK_VERSION=2.1.1 def=$SPARK_VERSION
#ENV LIVY_DOWNLOAD_LINK=http://download.nextag.com/apache/incubator/livy/0.4.0-incubating/livy-0.4.0-incubating-bin.zip 
#ENV LIVY_SRC=livy-0.4.0-incubating-src 
#ENV LIVY_DOWNLOAD_LINK=http://mirror.jax.hugeserver.com/apache/incubator/livy/0.4.0-incubating/livy-0.4.0-incubating-src.zip
#ENV LIVY_HOME=/opt/$LIVY_SRC 
ENV LIVY_BUILD_VERSION livy-server-0.4.0-SNAPSHOT

# Set install path for Livy
ENV LIVY_APP_PATH /apps/$LIVY_BUILD_VERSION

RUN apt-get install -yq --no-install-recommends --force-yes maven


#RUN curl $LIVY_DOWNLOAD_LINK -o /opt/$LIVY_SRC.zip
#RUN cd /opt/$LIVY_SRC && mvn package
RUN cd /opt && unzip /opt/$LIVY_SRC.zip
#RUN ls -lt /opt    
#RUN cd /opt/$LIVY_SRC && mvn -DskipTests=true -Dspark.version=$SPARK_VERSION clean package

# Clone Livy repository
RUN mkdir -p /apps/build && \
    cd /apps/build && \
	git clone https://github.com/cloudera/livy.git && \
	cd $LIVY_BUILD_PATH && \
    mvn -DskipTests -Dspark.version=$SPARK_VERSION clean package && \
    unzip $LIVY_BUILD_PATH/assembly/target/$LIVY_BUILD_VERSION.zip -d /apps && \
    rm -rf $LIVY_BUILD_PATH && \
	mkdir -p $LIVY_APP_PATH/upload
	
# Add custom files, set permissions
ADD entrypoint.sh .

RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8998

ENTRYPOINT ["/entrypoint.sh"]
  