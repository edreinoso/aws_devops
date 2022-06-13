import boto3
from stop import stop
from start import start


def lambda_handler(event, context):
    client = boto3.client('ec2')
    ec2 = client.describe_instances(
        # filtering by tags, these will be particularly useful
        # for identifying multiple or single instances that
        # need to be brought up or shut down.
        Filters=[
            {
                'Name': 'tag:'+event["key"], 
                'Values': [event["value"]]
            }
        ]
    )
    stopInstance = stop() # declaring external class for stopping instances
    startInstance = start() # declaring external class for starting instance

    for reservation in ec2["Reservations"]:
        for instance in reservation["Instances"]:
            print('instance id: ' + instance['InstanceId'])
            if (event['action'] == 'stop'):
                print('stopping instance:' +
                      instance['InstanceId'])
                stopInstance.stop_ec2(
                    instance['InstanceId'], client)
            elif (event['action'] == 'start'):
                print('starting instance:' +
                      instance['InstanceId'])
                startInstance.start_ec2(
                    instance['InstanceId'], client)
    print('\n')
