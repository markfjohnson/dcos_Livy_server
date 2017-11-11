import json, pprint, requests, textwrap, time, json
host="http://52.37.197.21:10000"
#    "file": "https://raw.githubusercontent.com/markfjohnson/dcos_Livy_server/master/pi.py",
# "file" : "file:/Users/markjohnson/demos/Livy/pi.py",
pp = pprint.PrettyPrinter(indent=4)
data = {
    "name" : "SparkPi Livy Python Example",
    "file": "https://raw.githubusercontent.com/markfjohnson/dcos_Livy_server/master/pi.py",
    "executorMemory": "2g",
    "args": ["100"],
    "conf":{
        "spark.mesos.executor.docker.image":"mesosphere/spark:2.1.0-2.2.0-1-hadoop-2.6",
        "spark.logConf":"true",
        "spark.mesos.executor.docker.forcePullImage":"true"
    }}
headers = {'Content-Type': 'application/json'}
r = None
r = requests.post(host + '/batches', data=json.dumps(data), headers=headers)
print("-----------------------------------------")
pp.pprint(r.json())
print("-----------------------------------------")
initial_state = json.loads(r.content)['state']
loc = r.headers['location']
batch_url = host + '{}/log'.format(loc)
while initial_state=='starting' or initial_state=='running':
    r = requests.get(batch_url, headers=headers)
    pp.pprint(r.json())
    initial_state = json.loads(r.content)['state']



