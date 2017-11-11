import json, pprint, requests, textwrap, time, json
host="http://52.37.197.21:10000"
#host="http://localhost:8998"
data = {'kind': 'pyspark',
        'queue':'',
        'pyFiles': [],
        'jars':[],
        'files':[],
        'archives':[],
        'name':"Crazy Test"}
headers = {'Content-Type': 'application/json'}
r = None
r = requests.post(host + '/sessions', data=json.dumps(data), headers=headers)
print(r.json())
initial_state = json.loads(r.content)['state']
loc = r.headers['location']
id = 0
while (initial_state=='starting' or initial_state=='running'):
    session_url = host + loc
    r = requests.get(session_url, headers=headers)
    initial_state = json.loads(r.content)['state']
    id = json.loads(r.content)['id']
    print(r.json())


