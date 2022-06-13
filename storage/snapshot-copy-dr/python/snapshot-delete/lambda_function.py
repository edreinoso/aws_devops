import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

# destination region that's going to be managed
destination_region = 'us-east-2'
client = boto3.client('ec2', region_name=destination_region)
# policy dates will allow you to place a timeframe
# for which to keep the snapshots before deleting
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
    # this calculation will provide the result for today minus policyDates
    # e.g. today May 31st, Sunday - 7 would be May 24th
    past = today - timedelta(days=policyDates)

    for snapshot in response['Snapshots']:
        # if the snapshot is older than 7 days
        if snapshot['StartTime'] < past:
        delete_snapshot(client, snapshot['SnapshotId'])

# function to delete snapshot
# it requires the snapshot_id, and the client
def delete_snapshot(client, snapshot_id):
    client.delete_snapshot(SnapshotId=snapshot_id)
