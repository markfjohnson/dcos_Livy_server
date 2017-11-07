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






# Clone Livy repository
RUN mkdir -p /apps/build && \
    cd /apps/build && \
	git clone -b $LIVY_BUILD_VERSION $LIVY_SRC_LINK && \
	cd /apps/build/$LIVY_BUILD_PATH && \
    mvn -DskipTests -Dspark.version=$SPARK_VERSION clean package

RUN unzip /apps/build/$LIVY_BUILD_PATH/assembly/target/$LIVY_TARGET.zip -d /apps

RUN cd /apps/build/$LIVY_BUILD_PATH/ && \
    mkdir -p upload && mkdir -p logs && \
    echo "livy.spark.master=mesos://zk://zk-1.zk:2181" >> conf/livy.conf && \
    echo "livy.spark.deploy-mode = cluster" >> conf/livy.conf


# Add custom files, set permissions
ADD entrypoint.sh /apps/build/$LIVY_BUILD_PATH/entrypoint.sh
RUN chmod +x /apps/build/$LIVY_BUILD_PATH/entrypoint.sh

# Expose port
EXPOSE 8998

#ENTRYPOINT ["/apps/build/$LIVY_BUILD_PATH/entrypoint.sh"]
WORKDIR /opt/spark/dist
  
