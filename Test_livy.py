import json, pprint, requests, textwrap, time, json
host="http://34.214.84.60:10007"

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
while (initial_state=='starting'):
    session_url = host + loc
    r = requests.get(session_url, headers=headers)
    initial_state = json.loads(r.content)['state']
    print(r.json())
