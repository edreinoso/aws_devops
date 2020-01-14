import boto3
from stopRDS import stop
from startRDS import start


def lambda_handler(event, context):
    print ('\n')
    client = boto3.client('rds')
    stop = stopRDS
    start = startRDS

    for instance in event['instances']:
        print (instance)
        if (instance == 'personal-website-dev-public-2'):
            print(event['action'])
            # depending on the event
            # the system is supposed to stop (at night 11pm)
            # or start the RDS instance (8am)
            if (event['action'] == 'start'):
                print('stopping instance:' + instance)
                # instance is just what's being passed from the event
                # event['instances']
                stop.stop_rds(instance, client)
            elif (event['action'] == 'stop'):
                print('starting instance:' + instance)
                start.start_rds(instance, client)

                # LATER LEARNING:
                # implement a swich statement: it could actually
                # easier to do an if statements, but for the sake
                # of learning, let's implement a switch
    print ('\n')
