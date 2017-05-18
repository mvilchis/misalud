from temba_client.v2 import TembaClient
import json
TOKEN_IO="bae15e0a8572ddb5f0e1c1fb8bb3733c84e3a746"
io_client = TembaClient('rapidpro.io',TOKEN_IO)
definitions = io_client.get_definitions(campaigns=("9ea19f24-bdc3-4fe9-bf37-5301d4c1f385", "41927fb7-37ee-4f5b-846c-71cf0acabba1", "a7e2b278-238d-445c-9923-abb5aae9cadc", "33cfdd37-5150-4a4b-a3e7-0e7ae419a86b", "6fbbab3b-3167-4d74-ae79-f590b6df3877", "7477b32e-8d7f-4600-a9ba-b8c5aa69ef22", "d6f30a53-6be6-42c7-910d-7cfdcb0ca0a3", "b0d8bedb-35b5-4972-ba4e-e6d4689be1f3", "645e6a30-ecb1-484d-977e-a6723ab5992b", "0324bae6-46c5-456d-84a9-2be41b021668", "db1186ac-d552-47b9-8e33-1574c6c4506c", "6e66257e-c213-4487-804e-d8eb399bbbac", "3fec8bcc-f7c2-49ed-9079-c5972e7f4eb6",))
print len(definitions.flows)
for flow in definitions.flows:
    with open('%s.json'%flow['metadata']['uuid'], 'w') as outfile:
        json.dump(flow, outfile)
