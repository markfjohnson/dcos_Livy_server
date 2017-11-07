FROM mesosphere/spark:1.1.0-2.1.1-hadoop-2.6
MAINTAINER Mark Johnson <mjohnson@mesosphere.com>

# Overall ENV vars
ENV SPARK_VERSION 2.1.1
#ENV MESOS_BUILD_VERSION 1.0.1-2.0.93
ENV LIVY_BUILD_VERSION incubator-livy-0.4.0-incubating
ENV LIVY_SRC_LINK https://github.com/apache/incubator-livy/archive/v0.4.0-incubating.zip
# Set install path for Livy
ENV LIVY_APP_PATH /apps/$LIVY_BUILD_VERSION
# Set Spark home directory
ENV SPARK_HOME /opt/spark/dist
# Set build path for Livy
#ENV LIVY_BUILD_PATH /apps/build/livy

# Add R list
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' | sudo tee -a /etc/apt/sources.list.d/r.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Setup Oracle Java 8
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get install -yq oracle-java8-installer
RUN apt-get install -yq oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV JRE_HOME /usr/lib/jvm/java-8-oracle/jre

# packages
RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    git \
    libjansi-java \
    libsvn1 \
    libcurl3 \
    libevent-dev \
    python-pip \
    python-setuptools \
    build-essential \
    libapr1 \
    libsasl2-modules && \
    mkdir -p /apps/$LIVY_BUILD_VERSION/logs

# python2.7 \

RUN pip install --upgrade setuptools




# Add custom files, set permissions
ADD entrypoint.sh .
RUN chmod +x entrypoint.sh

# Clone Livy repository
RUN mkdir -p /apps/build && \
    cd /apps/build
#	curl -o $LIVY_SRC_LINK && \
#	unzip $LIVY_BUILD_VERSION && \
#    mvn -DskipTests -Dspark.version=$SPARK_VERSION clean package && \
#    unzip $LIVY_BUILD_PATH/assembly/target/$LIVY_BUILD_VERSION.zip -d /apps && \
#    mkdir -p $LIVY_APP_PATH/upload && mkdir -p $LIVY_APP_PATH/logs && \
#    echo "livy.spark.master=mesos://zk://zk-1.zk:2181" >> $LIVY_APP_PATH/conf/livy.conf && \
#    echo "livy.spark.deployMode = cluster" >> $LIVY_APP_PATH/conf/livy.conf


# Expose port
EXPOSE 8998

#ENTRYPOINT ["/opt/spark/dist/entrypoint.sh"]
WORKDIR /opt/spark/dist
  
