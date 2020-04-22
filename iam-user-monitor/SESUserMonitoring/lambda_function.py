import boto3
import json

# Global Variables
TABLE_NAME = "IAMUserListMonitoring"
TEMPLATE_NAME = "User_Console_Login_Monitoring"
keyComparison = 'lastSignIn'
userdata = {
    "data": []
}

# part1
def part1DDB():
  client_ddb = boto3.resource('dynamodb')
  table = client_ddb.Table(TABLE_NAME)
  response = table.scan()
  for items in response['Items']:
      userdata["data"].append(
          {"username": items["username"], "createDate": items["createDate"], "lastSignIn": items["lastSignIn"]})
  bubble_sort(userdata["data"])  # passing userdata["data"], which is a list
  # return userdata # it should actually returned the sorted userdata

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
def bubble_sort(nums):
    swapped = True
    while swapped:
        swapped = False
        for index in range(len(nums) - 1):
            for key in nums[index]:
                if (key == keyComparison):
                    # print("Hello World")

                    if nums[index][key] < nums[index + 1][key]:
                        # print("this date: " + str(nums[index][key]) + ' is greater than this: ' + str(nums[index + 1][key]))
                        # Swap the elements
                        nums[index], nums[index +
                                          1] = nums[index + 1], nums[index]
                        # # Set the flag to True so we'll loop again
                        swapped = True

def lambda_handler(event, context):
  # 1st part: Getting data from DDB
  part1DDB()
  result = json.dumps(userdata)
  # print(result)
  # 2nd part: Create SES client
  part2SES(result)
