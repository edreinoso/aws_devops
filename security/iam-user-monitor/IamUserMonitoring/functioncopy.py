import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

def lambda_handler(event, context):
    isThereAPassUsed = "PasswordLastUsed"
    daysBack = 1
    arrayOfUsersSignIn = []

    client_iam = boto3.client('iam')
    client_ddb = boto3.resource('dynamodb')
    ddb_table = client_ddb.Table('IAMUserListMonitoring')
    iam = client_iam.list_users()

    today = datetime.now(tzutc())
    temp = today - timedelta(days=daysBack)
    # print(str(today) + '\n' + str(temp.strftime("%a, %d %B, %y")) + '\n')

    print('Updating the function with AWS CLI')
    print('Made an alias to deploy the function')

    for users in iam["Users"]:
        if isThereAPassUsed in users:
            # SORTING of accounts being accessed
            arrayOfUsersSignIn.append(
                {"Username": users["UserName"], "CreateDate": users["CreateDate"], "Last sign in": users["PasswordLastUsed"]})
    print('before sorting')
    for i in arrayOfUsersSignIn:
        print(i)
    bubble_sort(arrayOfUsersSignIn)
    print('\nafter sorting')
    print(type(arrayOfUsersSignIn))
    # for i in range(len(arrayOfUsersSignIn)):
    #     print(i)
    # for y in arrayOfUsersSignIn[i]:
    #     print(y)
    for i in arrayOfUsersSignIn:
        # print(type(i))
        # print(i)
        # print('User: ' + i["Username"] + ', Last sign in: ' + str(i["Last sign in"]))
        print('User: ' + i["Username"] + ', Last sign in: ' +
              str(i["Last sign in"].strftime("%a, %d %B, %y")))
        ddb_table.put_item(
            Item={
                'username': i["Username"],
                'createDate': str(i["CreateDate"].strftime("%a, %d %B, %y")),
                'lastSignIn': str(i["Last sign in"].strftime("%a, %d %B, %y"))
            }
        )
    print('\n')


def bubble_sort(nums):
    swapped = True
    while swapped:
        swapped = False
        for index in range(len(nums) - 1):
            for key in nums[index]:
                if (key == "lastSignIn"):
                    # print("Hello World")

                    if nums[index][key] < nums[index + 1][key]:
                        # print("this date: " + str(nums[index][key]) + ' is greater than this: ' + str(nums[index + 1][key]))
                        # Swap the elements
                        nums[index], nums[index +
                                          1] = nums[index + 1], nums[index]
                        # # Set the flag to True so we'll loop again
                        swapped = True
