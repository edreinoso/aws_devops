import boto3

# these variables are going to be changing
# they can even transformed into events
wide_open = '0.0.0.0/0'

# exception handling variables
exFromPort = 'FromPort'
exToPort = 'ToPort'
region = 'us-east-1'


client = boto3.client('ec2', region)

def lambda_handler(event, context):
    response = client.describe_security_groups(
        Filters=[
            {
                'Name': 'vpc-id',
                'Values': ['vpc-0c9013e7f3bf005cc']
            },
        ]
    )

    print('\n')

    # variables required to delete rule
    groupId = ''
    fromPort = ''
    toPort = ''
    # groupName = ''

    for sg in response["SecurityGroups"]:
        # grab these variables so that they're sent to the revoke security group access
        groupId = sg['GroupId']
        # groupName = sg['GroupName']

        print(sg)
        # print('Group Id: ' + groupId + '\t' + ' Group Name: ' + groupName)
        print('Group Id: ' + groupId)
        for ip in sg['IpPermissions']:
            # there has to be an exception for security groups that don't have ports.
            if exFromPort in ip:
                # print('---> yes, its available')
                fromPort = ip['FromPort']
                toPort = ip['ToPort']
                print('From Port: ' + str(fromPort) +
                      '\t' + ' To Port: ' + str(toPort))
            for cidr in ip['IpRanges']:
                if cidr['CidrIp'] == wide_open:
                    print('Hello World: close below security group')
                    deleteRule(response, fromPort, toPort, wide_open)
                    # call a function here!
                print('\t' + ' - Cidr: ' + cidr['CidrIp'])
        print('\n')

    print('\n')

    return ("Completed")


def deleteRule(response, fromPort, toPort, wide_open):
    response = client.revoke_security_group_ingress(
        GroupId='string',
        IpPermissions=[
            {
                'FromPort': fromPort,
                'ToPort': toPort,
                'IpProtocol': 'string',
                'IpRanges': [{'CidrIp': wide_open}]
            },
        ],
    )
