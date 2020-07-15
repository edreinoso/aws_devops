import boto3
from stop import stop
from start import start


def lambda_handler(event, context):
    print('\n')
    print(event["value"] + "\n" + event["key"])
    # nametag = "tag:"+event["key"]
    client = boto3.client('ec2')
    ec2 = client.describe_instances(
        # Having a filter EC2 instances that contain a certain tag
        Filters=[
            {
                'Name': 'tag:'+event["key"],
                # 'Name': nametag,  # how can I accomplish index variables?
                'Values': [event["value"]]
            }
        ]
    )
    stopInstance = stop()
    startInstance = start()

    for reservation in ec2["Reservations"]:
        for instance in reservation["Instances"]:
            print('instance id: ' + instance['InstanceId'])
            # if (event['action'] == 'stop'):
            #     print('stopping instance:' +
            #           instance['InstanceId'])
            #     stopInstance.stop_ec2(
            #         instance['InstanceId'], client)
            # elif (event['action'] == 'start'):
            #     print('starting instance:' +
            #           instance['InstanceId'])
            #     startInstance.start_ec2(
            #         instance['InstanceId'], client)
    print('\n')
