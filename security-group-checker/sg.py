import boto3

# these variables are going to be changing
# they can even transformed into events
range_170 = '170.0.0.0/8'
range_172 = '172.0.0.0/8'
range_167 = '167.0.0.0/8'  # this range is going to have to be changed to 167.219.0.0/16
range_140 = '140.0.0.0/8'
range_10 = '10.0.0.0/8'

# exception handling variables
exFromPort = 'FromPort'
exToPort = 'ToPort'
region = 'us-east-2'

client = boto3.client('ec2', region_name=region)

# data will be sent to S3 for analysis
bucket_name = "security-groups-checker"
file_name = "mgtSecurityGroups.txt"
lambda_path = "/tmp/" + file_name
s3_path = "/clean_up_nov_19/" + file_name


def lambda_handler(event, context):
    # event['region']
    response = client.describe_security_groups(
        Filters=[
            {
                'Name': 'vpc-id',
                # this should just be a variable that's passed with the event
                'Values': [event['mgt']]
            },
        ]
    )

    # print('\n')

    num = 0
    groupId = ''
    groupName = ''
    fromPort = ''
    toPort = ''
    ipProtocol = ''
    finalString = ''

    for sg in response["SecurityGroups"]:
        # grab these variables so that they're sent to the revoke security group access
        groupId = sg['GroupId']
        groupName = sg['GroupName']

        # print(sg)
        # print('Group Id: ' + groupId + '\t' + ' Group Name: ' + groupName)
        # print('Group Id: ' + groupId)
        for ip in sg['IpPermissions']:
            # there has to be an exception for security groups that don't have ports.
            if exFromPort in ip:
                # print('---> yes, its available')
                fromPort = ip['FromPort']
                ipProtocol = ip['IpProtocol']
                toPort = ip['ToPort']
                # print('From Port: ' + str(fromPort) +
                #       '\t' + ' To Port: ' + str(toPort))
                for cidr in ip['IpRanges']:
                    num += 1
                    # If the program goes to the 172 range, delete it
                    # print('\t' + ' - Cidr: ' + cidr['CidrIp'])
                    if cidr['CidrIp'] == range_170:
                        # print('\t\tHello World: 170 security group')
                        string = writeToFile(
                            num, groupId, groupName, fromPort, toPort, ipProtocol, range_170)
                        finalString += string
                        deleteRule(response, groupId, fromPort,
                                   toPort, ipProtocol, range_170)

                    if cidr['CidrIp'] == range_172:
                        # print('\t\tHello World: 172 security group')
                        string = writeToFile(
                            num, groupId, groupName, fromPort, toPort, ipProtocol, range_172)
                        finalString += string
                        deleteRule(response, groupId, fromPort,
                                   toPort, ipProtocol, range_172)

                    # If the program goes to the 140 range, change it for 10.140
                    if cidr['CidrIp'] == range_140:
                        # print('\t\tHello World: 140 security group')
                        string = writeToFile(
                            num, groupId, groupName, fromPort, toPort, ipProtocol, range_140)
                        finalString += string
                        deleteRule(response, groupId, fromPort,
                                   toPort, ipProtocol, range_140)
                        applyRule(response, groupId, fromPort, toPort,
                                  ipProtocol, '10.140.0.0/16', 'DHS Network')

                    # If the program goes to the 167/8 range, change it for 167/16
                    if cidr['CidrIp'] == range_167:
                        # print('\t\tHello World: 167 security group')
                        string = writeToFile(
                            num, groupId, groupName, fromPort, toPort, ipProtocol, range_167)
                        finalString += string
                        deleteRule(response, groupId, fromPort,
                                   toPort, ipProtocol, range_167)
                        applyRule(response, groupId, fromPort, toPort,
                                  ipProtocol, '167.219.0.0/16', 'Deloitte Network')
                    
                    # If the program goes to the 10/8 range, change it for 10.139/16
                    if cidr['CidrIp'] == range_10:
                        # print('\t\tHello World: 10 security group')
                        string = writeToFile(
                            num, groupId, groupName, fromPort, toPort, ipProtocol, range_10)
                        finalString += string
                        deleteRule(response, groupId, fromPort,
                                   toPort, ipProtocol, range_10)
                        applyRule(response, groupId, fromPort, toPort,
                                  ipProtocol, '10.139.0.0/16', 'AWS Network')
    #     print('\n')
    # print('\n')

    # sending data to S3
    encoded_string = finalString.encode("utf-8")
    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)

    return ("Completed")


def writeToFile(num, groupId, groupName, fromPort, toPort, ipProtocol, cidrip):
    string = str(num) + '\nGroupId: ' + groupId + '\nGroupName: ' + groupName + '\nFromPort: ' + \
        str(fromPort) + '\nToPort:' + str(toPort) + '\nIpProtocol: ' + \
        ipProtocol + '\nRules: ' + cidrip + '\n\n'
    return string

# this method will promote security group rules


def applyRule(response, groupId, fromPort, toPort, ipProtocol, cidrip, cidr_description):
    response = client.authorize_security_group_ingress(
        GroupId=groupId,
        IpPermissions=[
            {
                'FromPort': fromPort,
                'ToPort': toPort,
                'IpProtocol': ipProtocol,
                'IpRanges': [
                    {
                        'CidrIp': cidrip,
                        'Description': cidr_description
                    }
                ]
            },
        ],
    )

# this method will revoke security group rules
def deleteRule(response, groupId, fromPort, toPort, ipProtocol, cidrip):
    response = client.revoke_security_group_ingress(
        GroupId=groupId,
        IpPermissions=[
            {
                'FromPort': fromPort,
                'ToPort': toPort,
                'IpProtocol': ipProtocol,
                'IpRanges': [{'CidrIp': cidrip}]
            },
        ],
    )
