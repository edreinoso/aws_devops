# Get the ENI of those ec2 instances and store in variable
for nic in instance["NetworkInterfaces"]:

    eni_ids.append(nic['NetworkInterfaceId'])
    print('eni id: ' + eni_ids[eni_loop])

    ec2_eni = client.describe_network_interfaces(
        # enis from EC2 instance.
        NetworkInterfaceIds=[
            eni_ids[eni_loop]
        ],
    )

    for networkinterfaces in ec2_eni['NetworkInterfaces']:
        # testing line
        # print('Size of tagset ' + str(len(networkinterfaces['TagSet'])))
        print('network interface id: ' +
                networkinterfaces['NetworkInterfaceId'])

        # CODE FOR ASSIGNING NAME - STEP 4

        eni_loop += 1  # to loop to all the nics in an ec2 instance
