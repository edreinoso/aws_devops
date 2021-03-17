from aws_cdk import core

from aws_cdk import aws_ecs, aws_ec2


class LoadTestStack(core.Stack):

    def __init__(self, scope: core.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        vpc = aws_ec2.Vpc(self, "CDK_loadtester", max_azs=2)

        cluster = aws_ecs.Cluster(self, 'Cluster', vpc=vpc)

        taskdef = aws_ecs.FargateTaskDefinition(self, 'PingerTask')
        taskdef.add_container('Pinger',
                              image=aws_ecs.ContainerImage.from_asset('./pinger'),
                              environment={
                                  'URL': 'sample-elb-886491630.us-east-1.elb.amazonaws.com'
                              })
        aws_ecs.FargateService(self, 'PingerService',
                               cluster=cluster,
                               task_definition=taskdef,
                               desired_count=10
                              )
