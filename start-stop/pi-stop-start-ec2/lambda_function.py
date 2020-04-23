import boto3
from stop import stop
from start import start


def lambda_handler(event, context):
    print ('\n')
    client = boto3.client('ec2')
    areThereEC2Tags = 'Tags'
    stopInstance = stop()
    startInstance = start()

    for reservation in ec2["Reservations"]:
        for instance in reservation["Instances"]:
            print('instance id: ' + instance['InstanceId'])
            if areThereEC2Tags in instance:
                for tags in instance['Tags']:
                    if (tags['Key'] == 'Name'):
                        if ('dev' in tags['Value']):
                            print(tags['Value'])
                            if (event['action'] == 'start'):
                                print('stopping instance:' + instance)
                                stopInstance.stop_ec2(instance, client)
                            elif (event['action'] == 'stop'):
                                print('starting instance:' + instance)
                                startInstance.start_ec2(instance, client)
    print ('\n')
