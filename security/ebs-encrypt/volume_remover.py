import boto3
import json
import time
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

# delete the volumes that were already encrypted


def lambda_handler(event, context):
    client = boto3.client('ec2')
    response = client.describe_volumes(
        Filters=[
            {
                'Name': 'tag:snapshot-taker',
                'Values': [
                    'Y',
                ]
            },
        ],
    )
    for volume in response['Volumes']:
        if(len(x['Attachments']) > 0):
            # this will handle the case of volumes that are attached
            # to running instances.
            print('do not delete volume' + volume['VolumeId'])
        else: 
            client.delete_volume(
                VolumeId=volume['VolumeId'],
            )
