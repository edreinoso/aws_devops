import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

def lambda_handler(event, context):
    # Documentation: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#client
    client = boto3.client('ec2')
    response = client.describe_snapshots(
        Filters=[
            # REQUIRED: filter for describing snapshots
            {
                'Name': 'owner-id',
                'Values': ['130193131803']
            },
            # Tag and Value filter for testing purposes
            # this will only query values that have this
            # tag. It will come in handy when a high volume
            # of snapshots in the environment
            {
                'Name': 'tag:Automation',
                'Values': ['ebs-extend']
            },
        ],
    )

    # UTC time
    daysBack = 1 # this can be a variant number depending to your needs
    today = datetime.now(tzutc())
    # this calculation will provide the result for today minus daysBack
    # e.g. today May 31st, Sunday - 1 would be May 30th
    dayComparison = today - timedelta(days=daysBack)

    # iterating through the list of snapshots with the applied
    # with the applied filters
    for iterator in response['Snapshots']:
        # KEY: this will compare the snapshot with dayComparison
        # if the snapshot is more recent that the date comparison, then it
        # will assign a tag of Key DR and Value false
        if (dayComparison < iterator['StartTime']):
            create_tag(client, iterator['SnapshotId'], 'DR', 'false')

# function to create the snapshot
# it requires the snapshot_id, the key and value and the client
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
