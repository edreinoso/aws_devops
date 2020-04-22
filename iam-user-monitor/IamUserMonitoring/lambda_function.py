import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

def lambda_handler(event, context):
    # As a note 4-21: should definitely make another function that evaluates users who have not logged in the console ever!

    isThereAPassUsed = "PasswordLastUsed" # evaluates users who have logged in only
    daysBack = 1
    arrayOfUsersSignIn = [] # list

    client_iam = boto3.client('iam')
    client_ddb = boto3.resource('dynamodb')
    ddb_table = client_ddb.Table('IAMUserListMonitoring')
    iam = client_iam.list_users()

    today = datetime.now(tzutc())
    temp = today - timedelta(days=daysBack)
    # print(str(today) + '\n' + str(temp.strftime("%a, %d %B, %y")) + '\n')

    for users in iam["Users"]:
        if isThereAPassUsed in users:
            arrayOfUsersSignIn.append(
                {"Username": users["UserName"], "CreateDate": users["CreateDate"], "LastSignIn": users["PasswordLastUsed"]})
    print(type(arrayOfUsersSignIn)) # confirming it's a list
    for i in arrayOfUsersSignIn:
        print('User: ' + i["Username"] + ', Last sign in: ' +
                str(i["LastSignIn"].strftime("%A %d %B, %y")))
        ddb_table.put_item(
            Item={
                'username': i["Username"],
                'createDate': str(i["CreateDate"].strftime("%A %d %B, %y")),
                'lastSignIn': str(i["LastSignIn"].strftime("%A %d %B, %y"))
            }
        )
    print('\n')
