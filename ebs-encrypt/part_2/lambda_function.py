import boto3
import json
import time


def lambda_handler(event, context):
    client = boto3.client('ec2')
    # set up for dynamoDB reads
    client_ddb = boto3.resource('dynamodb')
    table = client_ddb.Table('EBSSnapshotEncryption')
    response = table.scan()
    # print(response['Items'])

    unencrypted_instances = []  # for turning off instances
    old_volume_list = []  # for detaching the volume
    volume_data = {"data": []}  # for manipulating new volumes and data
    new_volume_list = {"data": []}
    instanceId = ''
    prevInstanceId = ''

    volume_data['data'] = response['Items']

    for y in response['Items']:
        # print('Name: '+ str(y['Name'])+'\n'+'SnapshotId: '+ str(y['SnapshotId']) +'\n'+'InstanceId: '+ str(y['InstanceId']) +'\n'+'VolumeId: '+ str(y['VolumeId']) +'\n'+'VolumeSize: '+ str(y['VolumeSize']) +'\n'+'VolumeType: '+ str(y['Type']) +'\n'+'Device: '+ str(y['Device']) +'\n'+'Root: '+ str(y['RootVolume']))

        # capturing instanceId
        instanceId = y['InstanceId']
        if (instanceId != prevInstanceId):
            unencrypted_instances.append(instanceId)  # adding the same
        prevInstanceId = instanceId

        old_volume_list.append(y['VolumeId'])

        # print('\n')

    # print(volume_data['data'])
    # print(unencrypted_instances)
    # print(old_volume_list)

    # # STEP 2-a: CREATE ENCRYPTED VOLUMES FROM SNAPSHOTS
    print('\n' + 'STEP 2-a:' + '\n')
    for i in volume_data['data']:
        # print(i)
        encrypted_volumes = client.create_volume(
            AvailabilityZone=i['AZ'],  # s
            Encrypted=True,
            KmsKeyId='7fb03a33-765b-4aaa-93e8-3ad197a798e1',
            Size=int(i['VolumeSize']),  # same size as previous
            SnapshotId=i['SnapshotId'],
            VolumeType=i['Type'],
        )
        # # print(encrypted_volumes['VolumeId'])

        new_volume_list['data'].append(
            {'VolumeId': encrypted_volumes['VolumeId'], 'InstanceId': i['InstanceId'], 'Device': i['Device']})
    print(new_volume_list)

    # # STEP 2-b: TURN OFF EC2 INSTANCE
    print('\n' + 'STEP 2-b:' + '\n')
    for i in unencrypted_instances:
        print(i)
        response = client.stop_instances(
            InstanceIds=[i]
        )

    # there needs to be a delay here for which the servers are turning off
    # there needs to be a timer, or an await
    # but this is going to be depending on the amount of instances
    # need to be engineering a way of making it work
    time.sleep(60)  # only thing to be cautious about!

    # # STEP 2-c: DETACH EBS VOLUMES
    print('\n' + 'STEP 2-c:' + '\n')
    # # this is going to have to be for loop iterating through multiple volumes
    for x in old_volume_list:
        print(x)
        response = client.detach_volume(
            VolumeId=x,
        )

    # # STEP 2-d: ATTACH EBS VOLUMES
    print('\n' + 'STEP 2-d:' + '\n')
    # # this is going to have to be for loop iterating through multiple volumes
    # # when you attach the volume, you need to specify the device
    # # -- need to have the info about the instance
    for x in new_volume_list['data']:
        print(x)
        response = client.attach_volume(
            Device=x['Device'],
            InstanceId=x['InstanceId'],
            VolumeId=x['VolumeId'],
        )

    # # STEP 2-e: TURN ON EC2 INSTANCE
    print('\n' + 'STEP 2-b:' + '\n')
    for i in unencrypted_instances:
        print(i)
        response = client.start_instances(
            InstanceIds=[i]
        )
