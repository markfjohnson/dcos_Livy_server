FROM mesosphere/spark:1.1.0-2.1.1-hadoop-2.6
MAINTAINER Mark Johnson <mjohnson@mesosphere.com>

# Overall ENV vars
ENV SPARK_VERSION 2.1.1
#ENV MESOS_BUILD_VERSION 1.0.1-2.0.93
ENV LIVY_BUILD_VERSION livy-server-0.4.0-SNAPSHOT

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
    wget \
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
    rm -rf /var/lib/apt/lists/* && \ 
    mkdir -p /apps/$LIVY_BUILD_VERSION/logs

# python2.7 \

RUN pip install --upgrade setuptools

# Set install path for Livy
ENV LIVY_APP_PATH /apps/$LIVY_BUILD_VERSION

# Set build path for Livy
ENV LIVY_BUILD_PATH /apps/build/livy



# Set Spark home directory
ENV SPARK_HOME /opt/spark/dist

# Set native Mesos library path
#ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# Mesos install
#RUN wget http://repos.mesosphere.com/ubuntu/pool/main/m/mesos/mesos_$MESOS_BUILD_VERSION.ubuntu1404_amd64.deb && \
#    dpkg -i mesos_$MESOS_BUILD_VERSION.ubuntu1404_amd64.deb && \
#    rm mesos_$MESOS_BUILD_VERSION.ubuntu1404_amd64.deb

# Spark ENV vars
ENV SPARK_VERSION_STRING spark-$SPARK_VERSION-bin-hadoop2.6
#ENV SPARK_DOWNLOAD_URL http://d3kbcqa49mib13.cloudfront.net/$SPARK_VERSION_STRING.tgz

# Download and unzip Spark
#RUN wget $SPARK_DOWNLOAD_URL && \
#    mkdir -p $SPARK_HOME && \
#    tar xvf $SPARK_VERSION_STRING.tgz -C /tmp && \
#    cp -rf /tmp/$SPARK_VERSION_STRING/* $SPARK_HOME && \
#    rm -rf -- /tmp/$SPARK_VERSION_STRING && \
#    rm spark-$SPARK_VERSION-bin-hadoop2.6.tgz && \
#    echo "spark.mesos.executor.docker.image mesosphere/spark:1.0.6-2.0.2-hadoop-2.6" > $SPARK_HOME/conf/spark-defaults.conf

# Clone Livy repository
RUN mkdir -p /apps/build && \
    cd /apps/build && \
	git clone https://github.com/cloudera/livy.git && \
	cd $LIVY_BUILD_PATH && \
    mvn -DskipTests -Dspark.version=$SPARK_VERSION clean package && \
    unzip $LIVY_BUILD_PATH/assembly/target/$LIVY_BUILD_VERSION.zip -d /apps && \
    rm -rf $LIVY_BUILD_PATH && \
    mkdir -p $LIVY_APP_PATH/upload && \
    echo "livy.spark.master=mesos://0.0.0.0:7077" >> $LIVY_APP_PATH/conf/livy.conf && \
    echo "livy.spark.deployMode = cluster" >> $LIVY_APP_PATH/conf/livy.conf

# Add custom files, set permissions
ADD entrypoint.sh .

RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8998
RUN ls -lt
ENTRYPOINT ["\entrypoint.sh"]
  
