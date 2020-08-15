import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *


def lambda_handler(event, context):
    isThereAPassUsed = "PasswordLastUsed"  # evaluates users who have logged in only
    arrayOfUsersSignIn = []  # list to append all the users

    client_iam = boto3.client('iam')  # initializing client_iam
    client_ddb = boto3.resource('dynamodb')  # initializing client_ddb

    ddb_table = client_ddb.Table(
        'IAMUserListMonitoring')  # calling DynamoDB table
    iam = client_iam.list_users()  # listing all users in environment

    today = datetime.now(tzutc())

    for users in iam["Users"]:  # iterating through the list of users
        # there needs to be a logic here in place to check whether users have signed
        # into their accounts. Otherwise, this is going to give a logical error
        ### appending users to the list variable declared above ###
        if isThereAPassUsed in users:
            arrayOfUsersSignIn.append(
                {"Username": users["UserName"], "CreateDate": users["CreateDate"], "LastSignIn": users["PasswordLastUsed"]})
        else:
            arrayOfUsersSignIn.append(
                {"Username": users["UserName"], "CreateDate": users["CreateDate"], "LastSignIn": 'Have not signed in'})  # users have not logged in yet.

    for i in arrayOfUsersSignIn: # iterating through the newly created list
        print(i['Username'] + '\t' + str(i['LastSignIn']))
        ddb_table.put_item( # putting new items to the DynamoDB table
            # Attributes: username, createDate, lastSignIn, executionTime
            Item={
                'username': i["Username"],
                'createDate': str(i["CreateDate"]),
                'lastSignIn': str(i["LastSignIn"]),
                'executionTime': str(today.strftime("%a, %d %B %y")),
            }
        )
