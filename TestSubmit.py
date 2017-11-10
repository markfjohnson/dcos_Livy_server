import json, pprint, requests, textwrap, time, json
host="http://34.215.91.71:10000"
#host="http://localhost:8998"

data = {
    "name" : "SparkPi Livy Example 2",
    "file": 'https://downloads.mesosphere.com/spark/assets/spark-examples_2.10-1.4.0-SNAPSHOT.jar',
    "className" : "org.apache.spark.examples.SparkPi",
    "args": ["100"]}
headers = {'Content-Type': 'application/json'}
r = None
r = requests.post(host + '/batches', data=json.dumps(data), headers=headers)
print(r.json())
initial_state = json.loads(r.content)['state']
loc = r.headers['location']
while initial_state=='starting':
    session_url = host + loc
    r = requests.get(session_url, headers=headers)
    initial_state = json.loads(r.content)['state']
    print(r.json())


