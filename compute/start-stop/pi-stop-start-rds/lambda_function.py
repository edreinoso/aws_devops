import boto3
from stop import stopRDS
from start import startRDS


def lambda_handler(event, context):
    print('\n')
    client = boto3.client('rds')
    stopInstance = stopRDS()
    startInstance = startRDS()
    status = ''

    for instance in event['instances']:
        rdsInstance = client.describe_db_instances(
            DBInstanceIdentifier=instance)
        for description in rdsInstance['DBInstances']:
            status = description['DBInstanceStatus']
        print(instance)
        # depending on the event
        # the system is supposed to stop (at night 11pm)
        # or start the RDS instance (8am)
        if (event['action'] == 'start'):
            print('starting instance:' + instance)
            if (status == 'available'):
                print('rds status is available already')
            else:
                print('starting instance:' + instance)
                startInstance.start_rds(instance, client)
        elif (event['action'] == 'stop'):
            print('RDS instance status: ' + status)
            if (status == 'stopped'):
                print('rds status is stopped already')
            else:
                print('stopping instance:' + instance)
                stopInstance.stop_rds(instance, client)
