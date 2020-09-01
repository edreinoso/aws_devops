import boto3
import json
import time


def lambda_handler(event, context):
    client = boto3.client('ec2')
    volumes = client.describe_volumes()
    # variables
    areThereAnyTags = 'Tags'
    instanceId = ''
    volumeTagName = ''

    # variables for encrypted volume creation
    # this is going to have a dictionary
    # holds: volume size, volume type, volume AZ
    new_volume = {"data": []}

    # variables used for the old volume detachment and the new volume attachment
    old_volume_list = []
    new_volume_list = []

    print('\n' + 'STEP 1:' + '\n')

    # STEP 1: IDENTIFY UNENCRYPTED VOLUMES
    for x in volumes['Volumes']:
        # get InstanceId
        for foo in x['Attachments']:
            if foo['InstanceId']:
                instanceId = foo['InstanceId']

        # get volume name tag
        if areThereAnyTags in x:
            for bar in x['Tags']:
                if (bar['Key'] == 'Name'):
                    volumeTagName = bar['Value']

        # print(x['Encrypted'])
        description = "encrypting volume: name- " + volumeTagName + \
            " volume-id " + str(x['VolumeId']) + \
            " from instance-id " + instanceId

        if (x['Encrypted'] == False):
            # this might be just adding to a list
            old_volume_list.append(x['VolumeId'])
            # print(description)
            snapshot = client.create_snapshot(
                Description=description,
                VolumeId=x['VolumeId'],
            )

            new_volume['data'].append({'SnapshotId': snapshot['SnapshotId'],
                                       'VolumeSize': x['Size'], 'AZ': x['AvailabilityZone'], 'Type': x['VolumeType']})
            # print(snapshot['SnapshotId'])
    print(new_volume)
    print(old_volume_list)
    # print(len(unencrypted_snapshots))

    # STEP 2: CREATE ENCRYPTED VOLUMES FROM SNAPSHOTS
    # important note: consider the pending state from snapshot
    # if the time takes too much, consider separating this into two functions
    # howerver, data is going to have to persist somewhere, maybe a table
    # or a file that would be sent to S3.
    time.sleep(60)

    print('\n' + 'STEP 2:' + '\n')

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
        # print(encrypted_volumes['VolumeId'])

        new_volume_list.append(encrypted_volumes['VolumeId'])

        # for x in encrypted_volumes['Volumes']:
        # populate volume id list
        # print(x['VolumeId'])
        # new_volume_list += [] # adding the new volume list here

        # create volumes as iterating through the list
        # encrypt volumes
        # use snaphotId from the list
    print(new_volume_list)

    print('\n' + 'STEP 3:' + '\n')

    # STEP: 3 DETACH EBS VOLUMES
    # this is going to have to be for loop iterating through multiple volumes
    # for x in old_volume_list, then do
    # print(x)
    # response = client.detach_volume(
    #     VolumeId=x,
    # )

    print('\n' + 'STEP 4:' + '\n')

    # STEP: 4 ATTACH EBS VOLUMES
    # this is going to have to be for loop iterating through multiple volumes
    # for x in new_volume_list, then do
    # print(x)
    # response = client.attach_volume(
    #     VolumeId=x,
    # )
