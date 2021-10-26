import boto3

# in this function, I want to be able to poll the changes from
# DynamoDB streams. I am expecting to receive a piece of data related
# to the instance, so that I can deregister the AMI that was created

# most important methods
# deregister_image(): required InstanceId
# describe_snapshots(): listing AMI snapshots
# delete_snapshot(): deleting those snapshots


def lambda_handler(event, context):
    client_ec2 = boto3.client('ec2')
    print('Hello World from Cleaner Function')

    # accessing the actual record
    for record in event['Records']:
        print('record: ' + str(record))
        print(record['eventID'])
        print(record['eventName'])
        # we'd be trying to filter events based on the name
        # we're trying to look for events that are removed
        # from the dynamodb table
        if(record['eventName'] == 'REMOVE'):
            imageId = record['dynamodb']['OldImage']['imageId']['S']
            creationDate = record['dynamodb']['OldImage']['creationDate']['S']

            print('ami id: ' + imageId + 'created at: ' + creationDate)

            response = client_ec2.describe_images(
                ImageIds=[
                    imageId,
                ],
            )

            if (response):
                print('Deleting AMI')
                client_ec2.deregister_image(
                    ImageId=imageId
                )
            else:
                print("Image has been already deleted")

            # get the snapshot Id
            snap_id = client_ec2.describe_snapshots(
                Filters=[
                    {
                        'Name': 'tag:Auto_AMI',
                        'Values': [
                            'Y',
                        ]
                    },
                    {
                        'Name': 'tag:Date',
                        'Values': [
                            creationDate,
                        ]
                    },
                ],
            )

            print('snap_id response ' + str(snap_id))

            for snap in snap_id['Snapshots']:
                bar = snap['SnapshotId']

            # deleting snapshot
            client_ec2.delete_snapshot(
                SnapshotId=bar,
            )

    print('Successfully processed %s records.' % str(len(event['Records'])))
