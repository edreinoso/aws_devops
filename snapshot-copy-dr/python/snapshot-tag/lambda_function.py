import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

def lambda_handler(event, context):
    client = boto3.client('ec2')
    response = client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['130193131803']
            },
            {
                'Name': 'tag:Automation',
                'Values': ['ebs-extend']
            },
        ],
    )

    daysBack = 2
    today = datetime.now(tzutc())
    temp = today - timedelta(days=daysBack)

    for iterator in response['Snapshots']:
        if (temp < iterator['StartTime']):
            create_tag(client, iterator['SnapshotId'], 'DR', 'false')


def create_tag(client, snapshot_id, key, value):
    client.create_tags(
        Resources=[snapshot_id],
        Tags=[
            {
                'Key': key,
                'Value': value
            },
        ]
    )
