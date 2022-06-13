# most important methods
# describe_instances(): need to describe instances in order
# create_image(): required: name and instanceId
# put_item(): putting items inside of the DDB table for record

import boto3
import time
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

# global variables
lasting = 18  # how often AMI will be taken (?)
radius = ""  # whether it's going to take in any additional tag
env_key = "Environment"  # environment key portion
env_value = "Production"  # environment value portion


def lambda_handler(event, context):
    client_ec2 = boto3.client('ec2')
    client_ddb = boto3.resource('dynamodb')  # initializing client_ddb
    print('Hello World from Taker Function')
    today = datetime.utcnow()
    tomorrow = datetime.now(tzutc()) + timedelta(minutes=lasting)
    expires = int(tomorrow.strftime('%s'))

    # radius would be implemented somewhere inside
    # of the describe_instances method
    # describe running instance only
    instances = client_ec2.describe_instances(
        Filters=[
            {
                'Name': 'instance-state-name',
                'Values': [
                    'running'
                ]
            },
        ],
    )
    ddb_table = client_ddb.Table('AutoAMIRecord')

    for reservation in instances['Reservations']:
        for ec2 in reservation['Instances']:
            if 'Tags' in ec2:
                for tags in ec2["Tags"]:
                    # evaluating for production environments
                    # if the condition is true, then these instances
                    # will not restart
                    if (tags['Key'] == env_key and tags['Value'] == env_value):
                        reboot = False
                    elif (tags['Key'] == 'Name'):
                        instanceNameValue = tags['Value']
                    else:
                        reboot = True
            print('instanceNameValue: ' + instanceNameValue)

            # create the ami, this would be the simplest form of code
            response = client_ec2.create_image(
                InstanceId=ec2['InstanceId'],
                Name=instanceNameValue + '__' +
                str(today.strftime("%Y-%m-%dT%H.%M.%SZ")),
                NoReboot=reboot,
                TagSpecifications=[  # adding tags to new image and snapshots
                    {
                        'ResourceType': 'image',
                        'Tags': [
                            {
                                'Key': 'Name',
                                'Value': instanceNameValue
                            },
                            {
                                'Key': 'Date',
                                'Value': str(today.strftime("%Y-%m-%dT%H:%M:%SZ"))
                            },
                            {
                                'Key': 'Auto_AMI',
                                'Value': 'Y'
                            },
                        ]
                    },
                    {
                        'ResourceType': 'snapshot',
                        'Tags': [
                            {
                                'Key': 'Name',
                                'Value': instanceNameValue
                            },
                            {
                                'Key': 'Date',
                                'Value': str(today.strftime("%Y-%m-%dT%H:%M:%SZ"))
                            },
                            {
                                'Key': 'Auto_AMI',
                                'Value': 'Y'
                            },
                        ]
                    }
                ]
            )

            # creating record of the operation executed
            # placing a ttl of 2 min in the item
            ddb_table.put_item(  # putting new items to the DynamoDB table
                Item={
                    'instanceId': ec2['InstanceId'],
                    'imageId': response['ImageId'],
                    'instanceName': instanceNameValue,
                    'creationDate': str(today.strftime("%Y-%m-%dT%H:%M:%SZ")),
                    'expiryDate': expires,  # date values
                }
            )
