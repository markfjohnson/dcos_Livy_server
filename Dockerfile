FROM mesosphere/spark:1.1.0-2.1.1-hadoop-2.6
MAINTAINER Mark Johnson <mjohnson@mesosphere.com>

# Overall ENV vars
ENV SPARK_VERSION 2.1.1
ENV LIVY_BUILD_VERSION v0.4.0-incubating
ENV LIVY_SRC_LINK https://github.com/apache/incubator-livy.git
ENV LIVY_TARGET livy-server-0.4.0-incubating
# Set install path for Livy
ENV LIVY_APP_PATH /apps/$LIVY_BUILD_VERSION
# Set Spark home directory
ENV SPARK_HOME /opt/spark/dist
# Set build path for Livy
ENV LIVY_BUILD_PATH incubator-livy
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV PATH "/usr/lib/mesos/3rdparty/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$SPARK_HOME"

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





#git clone -b $LIVY_BUILD_VERSION $LIVY_SRC_LINK && \
# Clone Livy repository
RUN mkdir -p /apps/build && \
    cd /apps/build && \
	git clone $LIVY_SRC_LINK && \
	cd /apps/build/$LIVY_BUILD_PATH && \
    mvn -DskipTests -Dspark.version=$SPARK_VERSION clean package


#RUN unzip /apps/build/incubator-livy/assembly/target/$LIVY_TARGET.zip -d /apps &&\
#    mkdir -p WORKDIR /apps/$LIVY_BUILD_PATH/upload && mkdir -p WORKDIR /apps/build/$LIVY_BUILD_PATH/logs && \
#    echo "livy.spark.master=spark-dispatcher-hdfs-eventlog.marathon.l4lb.thisdcos.directory:7077" >> WORKDIR /apps/build/$LIVY_BUILD_PATH/conf/livy.conf && \
#    echo "livy.spark.deploy-mode = cluster" >> WORKDIR /apps/build/$LIVY_BUILD_PATH/conf/livy.conf && \
#    echo "livy.rsc.channel.log.level = DEBUG" >> WORKDIR /apps/build/$LIVY_BUILD_PATH/conf/livy.conf

WORKDIR /apps/build/$LIVY_BUILD_PATH
# Add custom files, set permissions
ADD log4j.properties conf
ADD entrypoint.sh .
RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8998



  
