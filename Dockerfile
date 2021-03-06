FROM mesosphere/spark:1.1.0-2.1.1-hadoop-2.6
MAINTAINER Mark Johnson <mjohnson@mesosphere.com>

# Overall ENV vars
ENV SPARK_VERSION 2.1.1
ENV LIVY_BUILD_VERSION v0.3.0-incubating
ENV LIVY_SRC_LINK https://github.com/apache/incubator-livy.git
ENV LIVY_TARGET livy-0.4.0-incubating-SNAPSHOT-bin

# Set install path for Livy
ENV LIVY_APP_PATH /apps/$LIVY_BUILD_VERSION
# Set Spark home directory
ENV SPARK_HOME /opt/spark/dist
ENV SPARK_DISPATCHER_MESOS_PRINCIPAL ""
ENV SPARK_DISPATCHER_MESOS_ROLE *
ENV SPARK_DISPATCHER_MESOS_SECRET ""
ENV SPARK_DISPATCHER_HOST localhost
ENV SPARK_DISPATCHER_PORT 7077
ENV SPARK_LOG_LEVEL INFO
ENV SPARK_USER nobody

# Set build path for Livy
ENV LIVY_BUILD_PATH incubator-livy
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV JRE_HOME /usr/lib/jvm/java-8-oracle/jre

ENV NO_BOOTSTRAP true
ENV LD_LIBRARY_PATH /opt/mesosphere/lib:/opt/mesosphere/libmesos-bundle/lib:/usr/lib
ENV TERM xterm

#  Finalize the PATH
ENV PATH "/usr/lib/mesos/3rdparty/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$SPARK_HOME/bin"

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

RUN mkdir -p /apps/build && \
    cd /apps/build && \
	git clone https://github.com/markfjohnson/incubator-livy.git && \
	cd $LIVY_BUILD_PATH && \
    mvn -DskipTests -Dspark.version=$SPARK_VERSION clean package && \
    unzip /apps/build/$LIVY_BUILD_PATH/assembly/target/livy-0.5.0-incubating-SNAPSHOT-bin.zip -d /apps
RUN mkdir -p /apps/build/$LIVY_BUILD_PATH/upload && mkdir -p WORKDIR /apps/build/$LIVY_BUILD_PATH/logs && \
    echo "livy.spark.master=spark://spark-dispatcher.marathon.l4lb.thisdcos.directory:7077" >>  /apps/build/$LIVY_BUILD_PATH/conf/livy.conf && \
    echo "livy.spark.deploy-mode = cluster" >>  /apps/build/$LIVY_BUILD_PATH/conf/livy.conf && \
    echo "livy.rsc.channel.log.level = ${SPARK_LOG_LEVEL}" >> /apps/build/$LIVY_BUILD_PATH/conf/livy.conf &&\
    echo "spark.mesos.executor.docker.image=mesosphere/spark:1.1.0-2.1.1-hadoop-2.6" > $SPARK_HOME/conf/spark-defaults.conf

WORKDIR /apps/build/$LIVY_BUILD_PATH
# Add custom files, set permissions
ADD log4j.properties conf
#ADD entrypoint.sh .
#RUN chmod +x entrypoint.sh


# Expose port
EXPOSE 8998 7077 7228
#ENTRYPOINT ["./entrypoint.sh"]
#ENTRYPOINT ["/bin/bash"]

