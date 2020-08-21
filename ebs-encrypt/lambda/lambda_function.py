import boto3
import json
import time


def lambda_handler(event, context):
    client = boto3.client('ec2')
    volumes = client.describe_volumes()
    # variables
    instanceId = ''
    volumeTagName = ''

    # variables for encrypted volume creation
    # this is going to have a dictionary
    # holds: volume size, volume type, volume AZ
    new_volume = {"data": []}

    # STEP 1: IDENTIFY UNENCRYPTED VOLUMES

    for x in volumes['Volumes']:
        # get tags to know where it is coming from
        for foo in x['Attachments']:
            if foo['InstanceId']:
                instanceId = foo['InstanceId']
        for bar in x['Tags']:
            if (bar['Key'] == 'Name'):
                volumeTagName = bar['Value']
        print(x['Encrypted'])
        description = "encrypting volume: name- " + volumeTagName + \
            " volume-id " + str(x['VolumeId']) + \
            " from instance-id " + instanceId
        if (x['Encrypted'] == False):
            # print(description)
            snapshot = client.create_snapshot(
                Description=description,
                VolumeId=x['VolumeId'],
            )

            new_volume['data'].append({'SnapshotId': snapshot['SnapshotId'],
                                       'VolumeSize': x['Size'], 'AZ': x['AvailabilityZone'], 'Type': x['VolumeType']})
            # print(snapshot['SnapshotId'])
    print(new_volume)
    # print(len(unencrypted_snapshots))

    # STEP 2: CREATE ENCRYPTED VOLUMES FROM SNAPSHOTS
    # important note: consider the pending state from snapshot
    time.sleep(60)

    # determine the length of the list
    # iterate through the list
    for i in new_volume['data']:
        print(i)
        encrypted_volumes = client.create_volume(
            AvailabilityZone=i['AZ'],  # s
            Encrypted=True,
            KmsKeyId='7fb03a33-765b-4aaa-93e8-3ad197a798e1',
            Size=i['VolumeSize'],  # same size as previous
            SnapshotId=i['SnapshotId'],
            VolumeType=i['Type'],
        )
        print(encrypted_volumes)

        # create volumes as iterating through the list
        # encrypt volumes
        # use snaphotId from the list
