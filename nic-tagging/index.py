import boto3

def lambda_handler(event, context):
    areThereEC2Tags = 'Tags'

    client = boto3.client('ec2', event['region'])

    ec2 = client.describe_instances()

    for reservation in ec2["Reservations"]:
        print(reservation)
        for instance in reservation["Instances"]:
            print(instance)
            if areThereEC2Tags in instance:
                print('Hello World')

    return ("Completed")
