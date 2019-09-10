import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

destination_region = 'us-east-1'
destination_client = boto3.client('ec2', region_name=destination_region)
policyDates = 7

def lambda_handler(event, context):
    client = destination_client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['698236466819']
            },
        ]
    )
    print(client)
    today = datetime.now(tzutc())
    
    past = today - timedelta(days=policyDates)
    
    for snapshot in client['Snapshots']:
        print('\n'+str(snapshot['StartTime']))
        if snapshot['StartTime'] < past:
            print(snapshot['Description'])
            if 'ami' in snapshot['Description']:
                print('This snapshot is from an AMI, skip!')
                break
            else:
                print('Snapshot is too old, gotta be deleted')
                # This is going to fail becuase there are some snapshots that
                # are taken from amis.
                # delete_snapshot(destination_client, snapshot['SnapshotId'])
        else:
            print(snapshot['Description'])
            print('Snapshot can be kept')
        print('--------')


def delete_snapshot(client, snapshot_id):
    client.delete_snapshot(SnapshotId=snapshot_id)
