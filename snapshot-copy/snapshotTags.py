# Have the outputs commented becuase there is currently an issue when trying to
# compute a huge output in lambda

import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *
from createTag import createTag

source_region = 'us-east-2'
source_client = boto3.client('ec2', region_name=source_region)
aws_ebs = 'arn:aws:kms:us-east-2:698236466819:key/590f9f50-407e-42b7-b575-841c9fe9986c'


def lambda_handler(event, context):
    tag_snaps = createTag()
    client = source_client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['698236466819']
            },
            {
                'Name': 'encrypted',
                'Values': ['true']
            },
            # {
            #     'Name': 'tag:Test',
            #     'Values': ['Y']
            # },
        ],
    )
    
    daysBack = 1
    today = datetime.now(tzutc())
    temp = today - timedelta(days=daysBack)

    for x in client['Snapshots']:
        thiselem = x
        # print('SnapshotId: ' + thiselem['SnapshotId'])
        # print('Start Time: ' + str(thiselem['StartTime']))
        if thiselem['KmsKeyId'] == aws_ebs:
            if (temp < thiselem['StartTime']):
                # print('tag this value')
                tag_snaps.create_tag(source_client, thiselem['SnapshotId'], 'DR', 'false')
        # print('\n')
    
