from datetime import datetime, timedelta
import json
import boto3

events = boto3.client('events')
ec2 = boto3.client('ec2')
function = boto3.client('lambda')


def datetime_to_cron(dt):
    return f"cron({dt.minute} {dt.hour} {dt.day} {dt.month} ? {dt.year})"


def lambda_handler(event, context):
    five_days_from_now = datetime.now() + timedelta(minutes=3)
    schedule = datetime_to_cron(datetime.strptime(
        str(five_days_from_now.replace(microsecond=0)), "%Y-%m-%d %H:%M:%S"))

    volume_id = event['detail']['requestParameters']['volumeId']

    print(volume_id)

    """
     Create tags
    """
    ec2.create_tags(
        Resources=[volume_id],
        Tags=[
            {
                'Key': 'CleanUp',
                'Value': str(five_days_from_now.replace(microsecond=0))
            }
        ]
    )

    """
     Put rule
     Put target
     Add Lambda permission
    """
    name = 'foobar'
    events.put_rule(
        Name=name,
        ScheduleExpression=schedule,
        State='ENABLED',
        Description='description'
    )

    body = {
        'volume_id': volume_id
    }

    input_obj = json.dumps(body)

    events.put_targets(
        Rule=name,
        Targets=[
            {
                'Id': name,
                'Arn': 'arn:aws:lambda:us-east-1:130193131803:function:function_test2',
                'Input': input_obj
            },
        ]
    )

    function.add_permission(
        FunctionName='function_test2',
        StatementId=name,
        Action='lambda:InvokeFunction',
        Principal='events.amazonaws.com',
        SourceArn=f'arn:aws:events:us-east-1:130193131803:rule/{name}'
    )
