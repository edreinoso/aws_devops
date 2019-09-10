import boto3

source_region = 'us-east-2'
destination_region = 'us-east-1'

# Connect to EC2 in Source region
source_client = boto3.client('ec2', region_name=source_region)
# Connect to EC2 in Destination region
destination_client = boto3.client('ec2', region_name=destination_region)

# These keys are from north virginia region and they represents aws_ebs and global_kms
kms_key = '45f02b69-219a-4fad-b6e3-44056c46ca1c'


def lambda_handler(event, context):
    snapshot_tag_name = ''
    key_dr_tag = 'DR'
    key_name_tag = 'Name'
    i = 1
    client = source_client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['698236466819']
            },
            {
                'Name': 'tag:DR',
                'Values': ['false']
            },
            # {
            #     'Name': 'tag:Test',
            #     'Values': ['Y']
            # }
        ]
    )

    for snapshot in client['Snapshots']:
        snapshot_id = snapshot['SnapshotId']
        snapshot_name = snapshot['Description']
        print('Snap_id primary region: ' + snapshot_id)
        print(str(i))
        if i > 5:
            # print('You need to stop RIGHT NOW!')
            return ("Maximum amount of snapshots have been sent")
            # exit(0)
        else:
            for tags in snapshot['Tags']:
                snapshot_tag_name = tags['Value']
                # print('Key: ' + tags['Key'] + '\t' +
                #       ' Value: ' + snapshot_tag_name)
                if (tags['Key'] == 'Name'):
                    # call the snapshot copy, it will return the
                    # new snapshot_id that will be used in tagging
                    new_snapshot_id = copy_snapshot(
                        snapshot_id, snapshot_name, key_name_tag, snapshot_tag_name)

                    # create a DR tag set to the destination region
                    # this would be useful in the for loop
                    create_tag(source_client, snapshot_id,
                              'DR', 'true')

                    # create a tag with name of previous snapshot
                    create_tag(destination_client, new_snapshot_id,
                              key_name_tag, snapshot_tag_name)
        i += 1
        print('--------' + '\n')

# This function would copy the snapshots to another region

def copy_snapshot(snapshot_id, snapshot_name, key_name_tag, snapshot_tag_name):
    print("Started copying snapshot_id: " + snapshot_id +
          "from: " + source_region + ", to: " + destination_region)
    # Copy the snapshot
    response = destination_client.copy_snapshot(
        SourceSnapshotId=snapshot_id,
        SourceRegion=source_region,
        Description=snapshot_name,
        Encrypted=True,
        KmsKeyId=kms_key
    )

    print('res: ' + str(response))
    new_snapshot_id = response['SnapshotId']
    # encrypted = response['Encrypted']
    print('New snapshot ID: ' + new_snapshot_id)
    # print('New snapshot ID: ' + new_snapshot_id + '. Encrypted: ' + encrypted)
    return response['SnapshotId']

# This function will create a tag to snaphots


def create_tag(client, snapshot_id, key, value):
    # print("Creating tag - Key: " + key + " Value" + '\t' +
    #       value + ", snapshot_id: " + snapshot_id)
    client.create_tags(
        Resources=[snapshot_id],
        Tags=[
            {
                'Key': key,
                'Value': value
            },
        ]
    )
