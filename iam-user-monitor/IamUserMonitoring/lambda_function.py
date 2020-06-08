import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *


def lambda_handler(event, context):
    isThereAPassUsed = "PasswordLastUsed"  # evaluates users who have logged in only
    daysBack = 1
    arrayOfUsersSignIn = []  # list

    client_iam = boto3.client('iam')
    client_ddb = boto3.resource('dynamodb')
    ddb_table = client_ddb.Table('IAMUserListMonitoring')
    iam = client_iam.list_users()

    today = datetime.now(tzutc())
    temp = today - timedelta(days=daysBack)
    print(str(today) + '\n' + str(temp.strftime("%a, %d, %B %Y")) + '\n')

    now = datetime.now()

    for users in iam["Users"]:
        if isThereAPassUsed in users:
            arrayOfUsersSignIn.append(
                {"Username": users["UserName"], "CreateDate": users["CreateDate"], "LastSignIn": users["PasswordLastUsed"]})
        else:
            arrayOfUsersSignIn.append(
                {"Username": users["UserName"], "CreateDate": users["CreateDate"], "LastSignIn": 'Have not signed in'})

    for i in arrayOfUsersSignIn:
        print(i['Username']+ '\t' + str(i['LastSignIn']))
        ddb_table.put_item(
            Item={
                'username': i["Username"],
                'createDate': str(i["CreateDate"]),
                'lastSignIn': str(i["LastSignIn"]),
                'executionTime': str(today.strftime("%a, %d %B %y")),
            }
        )
