from datetime import datetime, timedelta
import boto3

events = boto3.client('events')
ec2 = boto3.client('ec2')
function = boto3.client('lambda')


def handler(event, context):
    five_days_from_now = datetime.now() + timedelta(days=5)
    volume_id = event['detail']['requestParameters']['volumeId']

    """
     Create tags
    """
    ec2.create_tags(
        Resources=[volume_id],
        Tags=[
            {
                'Key': 'CleanUp',
                'Value': str(five_days_from_now)
            }
        ]
    )

    """
     Put rule
     Put target
     Add Lambda permission
    """
    events.put_rule(
        Name='name',
        ScheduleExpression=five_days_from_now,
        State='ENABLED',
        Description='description'
    )

    events.put_targets(
        Rule='id',
        Targets=[
            {
                'Id': 'id',
                'Arn': 'lambda_arn',
                'Input': 'input_obj'
            },
        ]
    )

    function.add_permission(
        FunctionName='function_name',
        StatementId='id',
        Action='invoke:Lambda',
        Principal='events.amazonaws.com',
        SourceArn='lambda_arn',
    )
