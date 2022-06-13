import boto3

# two regions are required for this function to execute
# a source region would be where the snapshot is being
# copied from.
# a destination region would be where the snapshot is
# going to be copied to
source_region = 'us-east-1'
destination_region = 'us-east-2'

# connect to EC2 in source region
source_client = boto3.client('ec2', region_name=source_region)
# connect to EC2 in destination region
destination_client = boto3.client('ec2', region_name=destination_region)


def lambda_handler(event, context):
    snapshot_tag_name = ''
    key_dr_tag = 'DR'
    key_name_tag = 'Name'
    i = 1
    client = source_client.describe_snapshots(
        Filters=[
            # REQUIRED as with the previous function
            # this function will also need to have the
            # the account ID
            {
                'Name': 'owner-id',
                'Values': ['130193131803']
            },
            # this filter will only include the functions
            # that have the DR:false tag
            {
                'Name': 'tag:DR',
                'Values': ['false']
            }
        ]
    )

    for snapshot in client['Snapshots']:
        # saving these in variables for later usage
        snapshot_id = snapshot['SnapshotId']
        snapshot_name = snapshot['Description']
        if i > 5:  # there is a limit of 5 to be transferred to a diff region
            return ("Maximum amount of snapshots have been sent")
        else:  # if the limit has not been reached, then it would copy the snapshots
            for tags in snapshot['Tags']:
                if (tags['Key'] == 'Name'):
                    snapshot_tag_name = tags['Value']
                    # call the snapshot copy, it will return the
                    # new snapshot_id that will be used in tagging
                    new_snapshot_id = copy_snapshot(
                        snapshot_id, snapshot_name, key_name_tag, snapshot_tag_name)

                    # change DR tag to true value on the source snapshot
                    create_tag(source_client, snapshot_id,
                               'DR', 'true')

                    # create a Name tag in the destination snapshot
                    create_tag(destination_client, new_snapshot_id,
                               key_name_tag, snapshot_tag_name)
        i += 1  # move to the next snapshot

# function that will handle the snapshot copy
# it will take a snapshot_id, snapshot_name


def copy_snapshot(snapshot_id, snapshot_name):
    # Copy the snapshot
    response = destination_client.copy_snapshot(
        SourceSnapshotId=snapshot_id,
        SourceRegion=source_region,
        Description=snapshot_name,
    )

    new_snapshot_id = response['SnapshotId']
    return response['SnapshotId']

# function to create the snapshot
# it requires the snapshot_id, the key and value and the client


def create_tag(client, snapshot_id, key, value):
    client.create_tags(
        Resources=[snapshot_id],
        Tags=[
            {
                'Key': key,
                'Value': value
            },
        ]
    )
