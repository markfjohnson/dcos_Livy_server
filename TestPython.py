import json, pprint, requests, textwrap
host="http://52.37.197.21:10000"
data = {'kind': 'spark'}
headers = {'Content-Type': 'application/json'}
pp = pprint.PrettyPrinter(indent=4)
r = requests.post(host + '/sessions', data=json.dumps(data), headers=headers)
pp.pprint(r.json())
state = json.loads(r.content)['state']
session_url = host + r.headers['location']
while state != 'idle' and state != 'dead':
    r = requests.get(session_url, headers=headers)
    state = json.loads(r.content)['state']
    pp.pprint(r.json())

statements_url = session_url + '/statements'
data = {'code': '1 + 1'}
r = requests.post(statements_url, data=json.dumps(data), headers=headers)
pp.pprint(r.json())
statement_url = host + r.headers['location']
state = json.loads(r.content)['state']
while state=='running':
    r = requests.get(statement_url, headers=headers)
    pprint.pprint(r.json())
