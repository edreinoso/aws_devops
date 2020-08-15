import boto3
from datetime import datetime
from dateutil.tz import *
import json

# Global Variables
TABLE_NAME = "IAMUserListMonitoring"
TEMPLATE_NAME = "User_Console_Login_Monitoring"
keyComparison = 'lastSignIn'  # this will serve to identify attribute to sort by
usersSignedIn = {  # variable to capture all the signed in users
    "data": []
}
sortedUserData = { # variable to sort all users that are sorted
    "data": []
}
completeUserData = { # variable to hold all the complete user information: signed in and not signed in
    "data": []
}
today = datetime.now(tzutc())


# part1
def part1DDB():
    # print('hello world')
    client_ddb = boto3.resource('dynamodb')
    table = client_ddb.Table(TABLE_NAME)
    # we are filtering data that is only related to today's execution time
    response = table.scan(  # scanning table to get all items according to filter
        FilterExpression=boto3.dynamodb.conditions.Attr(
            'executionTime').eq(str(today.strftime("%a, %d %B %y")))
    )
    # print(response)
    # 1st sub part: add data to different variables, one for sign in and one for not sign in
    for items in response['Items']:
        if (items["lastSignIn"] != "Have not signed in"):
            usersSignedIn["data"].append(
                {"username": items["username"], "createDate": items["createDate"], "lastSignIn": items["lastSignIn"]})
        else:
            completeUserData["data"].append({"username": items["username"], "createDate": str(datetime.strptime(
                items["createDate"], "%Y-%m-%d %H:%M:%S+00:00").strftime("%a %d, %B %Y")), "lastSignIn": items["lastSignIn"]})

    # 2nd sub part: sort data that have the appropriate date
    # sort the data
    # passing userdata["data"], which is a list
    bubble_sort(usersSignedIn["data"])

    # 3rd sub part: transform usersSignedIn date values of to string str(datetime.strptime(items["createDate"], "%Y-%m-%d %H:%M:%S+00:00").strftime("%a %d, %B %Y"))
    for items in usersSignedIn["data"]:
        sortedUserData["data"].append({"username": items["username"], "createDate": str(datetime.strptime(items["createDate"], "%Y-%m-%d %H:%M:%S+00:00").strftime(
            "%a %d, %B %Y")), "lastSignIn": str(datetime.strptime(items["lastSignIn"], "%Y-%m-%d %H:%M:%S+00:00").strftime("%a %d, %B %Y"))})

    # 4th sub part: add sortedUserData + userdataNotSignIn, the latter should be on top
    for items in sortedUserData["data"]:
        completeUserData["data"].append(
            {"username": items["username"], "createDate": items["createDate"], "lastSignIn": items["lastSignIn"]})

    print(completeUserData)
    # return usersSignedIn  # it should actually returned the sorted userdata

# part2


def part2SES(result):
    ses = boto3.client('ses')
    responseSend = ses.send_templated_email(
        Source='edgardo_16_@hotmail.com',
        Destination={
            'ToAddresses': ['edgardojesus16@gmail.com']
        },
        Template=TEMPLATE_NAME,
        TemplateData=result
    )
    print(responseSend)

# bubble sorting

# sorting data according to the keyComparison
# the logic uses the bubble sort algorithm


def bubble_sort(nums):
    swapped = True
    while swapped:
        swapped = False
        for index in range(len(nums) - 1):
            for key in nums[index]:
                if (key == keyComparison):
                    # print("Hello World")

                    if nums[index][key] > nums[index + 1][key]:
                        # print("this date: " + str(nums[index][key]) + ' is greater than this: ' + str(nums[index + 1][key]))
                        # Swap the elements
                        nums[index], nums[index +
                                          1] = nums[index + 1], nums[index]
                        # # Set the flag to True so we'll loop again
                        swapped = True


def lambda_handler(event, context):
    # 1st part: Getting data from DDB
    print(str(today.strftime("%a, %d %B %y")))
    part1DDB()
    # result = json.dumps(completeUserData)
    # print(result)
    # # # 2nd part: Create SES client
    # part2SES(result)
