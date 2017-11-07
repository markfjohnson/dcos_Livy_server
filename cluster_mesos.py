
conf = new SparkConf()
  .setMaster("mesos://HOST:5050")
  .setAppName("My app")

sc = new SparkContext(conf)