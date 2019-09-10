# SNAP TAG Mon 9 15:46

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
# global_kms =``
tags_name = 'Tags'


def lambda_handler(event, context):
    # num_tags = 0
    # y = 0
    tag_snaps = createTag()

    client = source_client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['698236466819']
            },
            {
                'Name': 'tag:Test',
                'Values': ['Y']
            },
            {
                'Name': 'encrypted',
                'Values': ['true']
            }
        ],
    )

    snapshots_tag = []
    zsnap_tag_value = ''
    ysnap_tag_value = ''
    temp_tag = ''
    days = 500

    i = 0
    n = len(client['Snapshots'])
    y = n-1

    for x in client['Snapshots']:
        thiselem = x
        # print(i)
        # print('thiselem: ' + thiselem['Description'])
        # print('thiselem: ' + thiselem['KmsKeyId'])

        if thiselem['KmsKeyId'] == aws_ebs:
            if tags_name in thiselem:
                # This for loop would be the get the variables in the current state
                for ztags in thiselem['Tags']:
                    # ztags['Value']
                    if (ztags['Key'] == 'Name' and ztags['Value'] != ''):
                        zsnap_tag_value = ztags['Value']
                        print('value of zsnap: ' + zsnap_tag_value)
                        print('value of temp_tag: ' + temp_tag)

            # # If statement in case the iterator goes beyond the y value
            # # If this wasn't in place, the iteator for next would go back to the first
            # # point
            if (i < y):
                nextelem = client['Snapshots'][(i + 1) % n]
                # This for loop would be the get the variables in the current state
                if tags_name in nextelem:
                    for ytags in nextelem['Tags']:
                        if (ytags['Key'] == 'Name'):
                            ysnap_tag_value = ytags['Value']
                            print('value of ysnap: ' + ysnap_tag_value)

            # # Comparing Tags #
            # # if (zsnap_tag_value != '' or ysnap_tag_value != '' or temp_tag != ''):
            # if tags_name in thiselem:
                if (zsnap_tag_value != ''):
                    # print('perform operation')
                    if (zsnap_tag_value == ysnap_tag_value):
                        snapshots_tag.append(thiselem)
                        print('--->Add the snap, forwards tag')
                    elif (zsnap_tag_value == temp_tag):
                        snapshots_tag.append(thiselem)
                        snapDateCompare(tag_snaps, snapshots_tag, days)
                        snapshots_tag = []  # reset after use
                        print('--->Add the snap, backwards tag')
                        # print(snapshots)
                    else:
                        print('add a tag to the ones that are not equal')
                        #     source_client, thiselem['SnapshotId'], 'DR', 'false')
                        # tag_snaps.create_tag(

            temp_tag = zsnap_tag_value
            ysnap_tag_value = ''
            zsnap_tag_value = ''
            print('\n')

        i += 1


def snapDateCompare(tag_snaps, snapshots, days):
    # Taking the most recent snapshot from the var

    b = 0
    a = len(snapshots)-1
    today = datetime.now(tzutc())
    past = today - timedelta(days=days)
    for w in snapshots:
        # print('Description: ' + w['Description'])
        today = w['StartTime']
        # print(str(b) + ' ' + 'today: ' + str(today) + ' past: ' + str(past))
        # print('today: ' + str(today) + ' past: ' + str(past))
        if (today > past):
            snap_tag = w['SnapshotId']
            # print('compare here')
        past = today
        b += 1
    # tag_snaps.create_tag(source_client, snap_tag, 'DR', 'false')
