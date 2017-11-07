
import json, pprint, requests, textwrap, time, json
host="http://54.148.237.235:10007"

statements_url = host + '/statements'
headers = {'Content-Type': 'application/json'}
data = {'code': '1 + 1'}
r = requests.post(statements_url, data=json.dumps(data), headers=headers)
print(r.json())