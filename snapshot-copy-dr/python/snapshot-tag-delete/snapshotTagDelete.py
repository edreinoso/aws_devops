# Have the outputs commented becuase there is currently an issue when trying to
# compute a huge output in lambda

import boto3

source_region = 'us-east-2'
source_client = boto3.client('ec2', region_name=source_region)


def lambda_handler(event, context):
    tags_name = 'Tags'

    client = source_client.describe_snapshots(
        Filters=[
            {
                'Name': 'owner-id',
                'Values': ['130193131803']
            },
            {
                'Name': 'tag:Automation',
                'Values': ['ebs-extend']
            },
        ],
    )
    for snapshot in client['Snapshots']:
        if tags_name in snapshot:
            for tags in snapshot['Tags']:
                # print(tags)
                if (tags['Key'] == 'DR'):
                    delete_tag(source_client,
                               snapshot['SnapshotId'], 'DR', 'false')
                    delete_tag(source_client,
                               snapshot['SnapshotId'], 'DR', 'true')

def delete_tag(client, snapshot_id, key, value):
    client.delete_tags(
        Resources=[snapshot_id],
        Tags=[
            {
                'Key': key,
                'Value': value
            },
        ]
    )
