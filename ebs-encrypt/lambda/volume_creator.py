import boto3
import json
import time

def lambda_handler(event, context):
    client = boto3.client('ec2')
    # set up for dynamoDB reads
    client_ddb = boto3.resource('dynamodb')
    table = client_ddb.Table('EBS_Encryption')
    response = table.scan(
        FilterExpression=boto3.dynamodb.conditions.Attr(
            'EncryptionCreated').eq(False)
    )  # Filter only to the items that are NOT attached.

    unencrypted_instances = []  # for turning off instances
    # unencrypted_instances = {} # for turning off instances
    volume_data = {"data": []}  # for manipulating new volumes and data
    new_volume_list = {"data": []}

    volume_data['data'] = response['Items']

    # Very important piece of code
    # It helps us order the array by the number of instances
    order = {v['InstanceId']: v for v in response['Items']}.values()
    for o in order:
        if(o['InstanceId'] != ""):
            unencrypted_instances.append(o['InstanceId'])

    # STEP 2-a: CREATE ENCRYPTED VOLUMES FROM SNAPSHOTS
    for i in volume_data['data']:
        encrypted_volumes = client.create_volume(
            AvailabilityZone=i['AZ'], 
            Encrypted=True,
            KmsKeyId='7fb03a33-765b-4aaa-93e8-3ad197a798e1',
            Size=int(i['VolumeSize']),
            SnapshotId=i['SnapshotId'],
            VolumeType=i['Type'],
            TagSpecifications=[
                {
                    'ResourceType': 'volume',
                    'Tags': [
                        {
                            'Key': 'Name',
                            'Value': i['Name']
                        },
                        {
                            'Key': 'InstanceId',
                            'Value': i['InstanceId']
                        },
                        {
                            'Key': 'Date',
                            'Value': i['Date']
                        },
                        {
                            'Key': 'Automation',
                            'Value': 'Y'
                        },
                    ]
                },
            ]
        )
        # STEP 3: CHANGE DDB ITEM RECORD
        updateItem = table.update_item(
            Key={
                'IVoId': i['IVoId']  # this is the value of the new volume
            },
            UpdateExpression="set EncryptionCreated=:a, EVoId=:e",
            ExpressionAttributeValues={
                ':a': True,
                ':e': encrypted_volumes['VolumeId']
            },
        )

        new_volume_list['data'].append(
            {'IVoId': i['IVoId'], 'VolumeId': encrypted_volumes['VolumeId'], 'InstanceId': i['InstanceId'], 'Device': i['Device']})

    # # STEP 2-b: TURN OFF EC2 INSTANCE
    print('\n' + 'STEP 2-b:' + '\n')
    for i in unencrypted_instances:
        ec2_state = client.describe_instances(
            InstanceIds=[i]
        )
        if(ec2_state['Reservations'][0]['Instances'][0]['State']['Name'] != "stopped"):
            # stop the instance
            response = client.stop_instances(
                InstanceIds=[i]
            )

    # # STEP 2-c: DETACH / ATTACH EBS VOLUMES
    print('\n' + 'STEP 2-c:' + '\n')
    if(len(new_volume_list['data']) > 0):
        # there needs to be a delay here for which the servers are turning off
        # but this is going to be depending on the amount of instances
        # need to be engineering a way of making it work
        time.sleep(60)  # only thing to be cautious about!
        for x in new_volume_list['data']:
            ivoid = client.describe_volumes(
                VolumeIds=[
                    x['IVoId'],
                ],
            )
            evoid = client.describe_volumes(  # need to check whether there's even
                VolumeIds=[
                    x['VolumeId'],
                ],
            )

            if (x['InstanceId'] != ""):
                # Detach
                # if it's available, it cannot be detached
                if (ivoid['Volumes'][0]['State'] != "available"):
                    print('can detach ivoid volume safely')
                    response = client.detach_volume(
                        VolumeId=x['IVoId'],
                    )

                # sleeping time for the volume to fully detach
                time.sleep(5)

                # Attach
                # this would enforce only attachments in instances
                if (evoid['Volumes'][0]['State'] == 'available'):
                    print('new volume needs to be attached!')
                    response = client.attach_volume(
                        Device=x['Device'],
                        InstanceId=x['InstanceId'],
                        VolumeId=x['VolumeId'],
                    )
                else:
                    print('volume is not available: '+x['VolumeId'])
            print('\n')

    # # STEP 2-e: TURN ON EC2 INSTANCE
    print('\n' + 'STEP 2-e: ' + '\n')
    for i in unencrypted_instances:
        response = client.start_instances(
            InstanceIds=[i]
        )
