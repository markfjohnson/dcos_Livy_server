import json, pprint, requests, textwrap, time, json
host="http://52.37.197.21:10000"


data = {
    "name" : "SparkPi Livy Example 5 http",
    "file": "http://downloads.mesosphere.com/spark/assets/spark-examples_2.10-1.4.0-SNAPSHOT.jar",
    "className" : "org.apache.spark.examples.SparkPi",
    "executorMemory": "20g",
    "args": ["100", "verbose"],
    "conf":{
        "spark.mesos.executor.docker.image":"mesosphere/spark:2.1.0-2.2.0-1-hadoop-2.6",
        "spark.logConf":"true",
        "spark.mesos.executor.docker.forcePullImage":"true"
    }}
headers = {'Content-Type': 'application/json'}
r = None
r = requests.post(host + '/batches', data=json.dumps(data), headers=headers)
print(r.json())
initial_state = json.loads(r.content)['state']
loc = r.headers['location']
while initial_state=='starting' or initial_state=='running':
    session_url = host + loc
    r = requests.get(session_url, headers=headers)
    initial_state = json.loads(r.content)['state']
    print(r.json())


