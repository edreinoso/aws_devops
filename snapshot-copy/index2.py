# SNAP TEST

# Have the outputs commented becuase there is currently an issue when trying to
# compute a huge output in lambda

import boto3
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *

source_region = 'us-east-2'
source_client = boto3.client('ec2', region_name=source_region)


def lambda_handler(event, context):
    client = source_client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['698236466819']
            },
            # {
            #     'Name': 'start-time',
            #     'Values': ['2019-09-09 06:21:40.682000+00:00']
            #     # 'Values': ['2019-09-08T00:00-04:00']
            # },
            # {
            #     'Name': 'tag:Name',
            #     'Values': [event['D-DB2']]
            # },
            {
                'Name': 'tag:Test',
                'Values': ['Y']
            },
        ],
    )
    
    daysBack = 500
    daysBack = 1
    today = datetime.now(tzutc())
    past = today - timedelta(days=daysBack)
    temp = today - timedelta(days=daysBack)
    i = 0

    print('\ntemp: ' + str(temp))

    for x in client['Snapshots']:
        thiselem = x
        print('SnapshotId: ' + thiselem['SnapshotId'])
        print('Start Time: ' + str(thiselem['StartTime']))
        
        if (temp < thiselem['StartTime']):
            print('store in a variable')
        
        print('\n')
    # print('latest snapshot id: ' + str(snap_tag) + '\nname: ' + tag_name + '\nstart time: ' + str(tag_date))
    
