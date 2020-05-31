import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

destination_region = 'us-east-2'
client = boto3.client('ec2', region_name=destination_region)
policyDates = 7


def lambda_handler(event, context):
    response = client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['130193131803']
            },
        ]
    )
    today = datetime.now(tzutc())
    past = today - timedelta(days=policyDates)

    for snapshot in response['Snapshots']:
        # if snapshot['StartTime'] < past:  # if the snapshot is older than 7 days
        delete_snapshot(client, snapshot['SnapshotId'])


def delete_snapshot(client, snapshot_id):
    client.delete_snapshot(SnapshotId=snapshot_id)
