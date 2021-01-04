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
        'EBS_Encryption')  # calling DynamoDB table

    # variables
    areThereAnyTags = 'Tags'
    instanceId = ''
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
    new_volume_data = {"data": []}

    print('\n' + 'STEP 1:' + '\n')

    # STEP 1: IDENTIFY UNENCRYPTED VOLUMES

    for x in volumes['Volumes']:
        # get InstanceId
        if(len(x['Attachments']) > 0):  # if the volume has an attachment
            for attach in x['Attachments']:  # get the device
                instanceId = attach['InstanceId']
                # this comparison is done so that the instance id is not replicated in the list
                # an instance can have many different volumes that might not be encrypted
                # so to avoid having same instance ids, this logic needs to be in place
                volumeDevice = attach['Device']
                if (attach['Device'] == '/dev/xvda'):
                    rootVolume = True
        else:
            instanceId = ""
            volumeDevice = ""

        # get volume name tag
        if areThereAnyTags in x:
            for tag in x['Tags']:
                if (tag['Key'] == 'Name'):
                    volumeTagName = tag['Value']
                else:
                    volumeTagName = ""

        description = "encrypting volume: name: " + volumeTagName + \
            " volume-id: " + str(x['VolumeId']) + \
            " from instance-id: " + instanceId

        # meat of the script: if the encryption is not enabled!
        if (x['Encrypted'] == False):
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
            client.create_tags(
                Resources=[
                    x['VolumeId'],
                ],
                Tags=[
                    {
                        'Key': 'snapshot-taker',
                        'Value': 'Y',
                    },
                ]
            )
            # this is required so that it can be excluded
            volume_data['data'].append({'SnapshotId': snapshot['SnapshotId'], 'RootVolume': rootVolume,
                                        'Name': volumeTagName, 'VolumeSize': x['Size'], 'AZ': x['AvailabilityZone'], 'Type': x['VolumeType'], 'InstanceId': instanceId, 'Device': volumeDevice, 'VolumeId': x['VolumeId']})

            ddb_table.put_item(  # putting new items to the DynamoDB table
                Item={
                    'Name': volumeTagName,
                    'SnapshotId': snapshot['SnapshotId'],
                    'RootVolume': rootVolume,
                    'VolumeSize': x['Size'],
                    'AZ': x['AvailabilityZone'],
                    'Type': x['VolumeType'],
                    'InstanceId': instanceId,
                    'Device': volumeDevice,
                    'IVoId': x['VolumeId'],
                    'EVoId': "",
                    'Date': str(today.strftime("%Y-%m-%dT%H:%M:%SZ")),
                    'EncryptionCreated': False
                }
            )

        rootVolume = False  # resetting the variable to false after iterating through the volume
