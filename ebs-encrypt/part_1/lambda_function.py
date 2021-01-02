import boto3
import json
import time
from datetime import datetime
from datetime import timedelta
from dateutil.tz import *


def lambda_handler(event, context):
    client = boto3.client('ec2')
    volumes = client.describe_volumes()
    client_ddb = boto3.resource('dynamodb')  # initializing client_ddb

    ddb_table = client_ddb.Table(
        'EBSSnapshotEncryption')  # calling DynamoDB table
    # variables
    areThereAnyTags = 'Tags'
    instanceId = ''
    prevInstanceId = ''
    volumeDevice = ''
    volumeTagName = ''
    rootVolume = False
    today = datetime.utcnow()
    tomorrow = datetime.now(tzutc()) + timedelta(minutes=30)
    expires = int(tomorrow.strftime('%s'))

    # variables for encrypted volume creation
    # this is going to have a dictionary
    # holds: volume size, volume type, volume AZ
    volume_data = {"data": []}

    # variables used for the old volume detachment and the new volume attachment
    old_volume_list = []
    new_volume_data = {"data": []}
    unencrypted_instances = []

    print('\n' + 'STEP 1:' + '\n')

    # STEP 1: IDENTIFY UNENCRYPTED VOLUMES

    for x in volumes['Volumes']:
        # get InstanceId
        if(len(x['Attachments']) > 0):  # if the volume has an attachment
            for foo in x['Attachments']:  # get the device
                instanceId = foo['InstanceId']
                # this comparison is done so that the instance id is not replicated in the list
                # an instance can have many different volumes that might not be encrypted
                # so to avoid having same instance ids, this logic needs to be in place
                volumeDevice = foo['Device']
                if (foo['Device'] == '/dev/xvda'):
                    rootVolume = True
        else:
            instanceId = ""
            volumeDevice = ""

        # get volume name tag
        if areThereAnyTags in x:
            for bar in x['Tags']:
                if (bar['Key'] == 'Name'):
                    volumeTagName = bar['Value']

        description = "encrypting volume: name: " + volumeTagName + \
            " volume-id: " + str(x['VolumeId']) + \
            " from instance-id: " + instanceId

        # meat of the script: if the encryption is not enabled!
        if (x['Encrypted'] == False):
            # this might be just adding to a list
            old_volume_list.append(x['VolumeId'])
            # print(description)
            snapshot = client.create_snapshot(
                Description=description,
                VolumeId=x['VolumeId'],
                TagSpecifications=[
                    {
                        'ResourceType': 'snapshot',
                        'Tags': [
                            {
                                'Key': 'Name',
                                'Value': volumeTagName
                            },
                            {
                                'Key': 'InstanceId',
                                'Value': instanceId
                            },
                            {
                                'Key': 'VolumeId',
                                'Value': x['VolumeId']
                            },
                            {
                                'Key': 'AZ',
                                'Value': x['AvailabilityZone']
                            },
                            {
                                'Key': 'Date',
                                'Value': str(today.strftime("%Y-%m-%dT%H:%M:%SZ"))
                            },
                            {
                                'Key': 'Automation',
                                'Value': 'Y'
                            },
                        ]
                    },
                ]
            )

            volume_data['data'].append({'SnapshotId': snapshot['SnapshotId'], 'RootVolume': rootVolume,
                                        'Name': volumeTagName, 'VolumeSize': x['Size'], 'AZ': x['AvailabilityZone'], 'Type': x['VolumeType'], 'InstanceId': instanceId, 'Device': volumeDevice, 'VolumeId': x['VolumeId']})

            ddb_table.put_item(  # putting new items to the DynamoDB table
                # Attributes: username, createDate, lastSignIn, executionTime
                Item={
                    'Name': volumeTagName,
                    'SnapshotId': snapshot['SnapshotId'],
                    'RootVolume': rootVolume,
                    'VolumeSize': x['Size'],
                    'AZ': x['AvailabilityZone'],
                    'Type': x['VolumeType'],
                    'InstanceId': instanceId,
                    'Device': volumeDevice,
                    'VolumeId': x['VolumeId'],
                    'Date': str(today.strftime("%Y-%m-%dT%H:%M:%SZ")),
                    'Attached': False
                    # 'TTL': expires,

                }
            )

        # prevInstanceId = instanceId
        rootVolume = False  # resetting the variable to false after iterating through the volume

    # these lines are just for printing
    for y in volume_data['data']:
        print('Name: ' + str(y['Name'])+'\n'+'SnapshotId: ' + str(y['SnapshotId']) + '\n'+'InstanceId: ' + str(y['InstanceId']) + '\n'+'VolumeId: ' + str(y['VolumeId']) +
              '\n'+'VolumeSize: ' + str(y['VolumeSize']) + '\n'+'VolumeType: ' + str(y['Type']) + '\n'+'Device: ' + str(y['Device']) + '\n'+'Root: ' + str(y['RootVolume']))
        print('\n')
    # print(volume_data)
    print(old_volume_list)
    print(unencrypted_instances)
