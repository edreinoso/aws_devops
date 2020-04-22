import boto3
import json

# def lambda_handler(event, context): # use this when exporting to Lambda
sampleData = {"meta": {"userId": "51806220607"}, "contact": {"firstName": "Anaya", "lastName": "Iyengar", "city": "Bengaluru", "country": "India", "postalCode": "560052"}, "subscription": [{"interest": "Sports", "favorite": "Soccer"}, {"interest": "Travel", "favorite": "Spain"}, {"interest": "Cooking", "favorite": "Paella"}]}

TABLE_NAME = "IAMUserListMonitoring"
TEMPLATE_NAME = "Sample_Data_Parsing"
userdata = {
  "data": []
}

# 1st part: Getting data from DDB
client_ddb = boto3.resource('dynamodb')
table = client_ddb.Table(TABLE_NAME)
response = table.scan()

# print(type(response)) # dict
# print(response)
# print('\n')
# print(type(response['Items'])) # list
# print(response['Items'])
# print('\n')

# userdata["data"].append(response['Items'])
# print(userdata)
# print('\n')

for items in response['Items']:
    # print(type(items))
    # print(items['username'])
    # print(items)
    # userdata.append(items)
    userdata["data"].append(
        {"username": items["username"], "createDate": items["createDate"], "lastSignIn": items["lastSignIn"]})

# this is perfect
result = json.dumps(userdata)
print(result)

# 2nd part: Create SES client
ses = boto3.client('ses')

# result = json.dumps(sampleData)
responseSend = ses.send_templated_email(
    Source='edgardo_16_@hotmail.com',
    Destination={
        'ToAddresses': ['edgardojesus16@gmail.com']
    },
    Template=TEMPLATE_NAME,
    TemplateData=result
)

print(responseSend)
