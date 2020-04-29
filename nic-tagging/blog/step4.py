# This if statement would help as an error checker.
if (len(networkinterfaces['TagSet']) > 0):
    for nic_tags in networkinterfaces['TagSet']:
        # We want to check for the key 'name'
        if (nic_tags['Key'] == 'Name'):
            # if the value is not equal the ec2 instance tag
            # print('len(ec2_tag_value): '+ str(len(ec2_tag_value)))
            # if(len(ec2_tag_value) > 0):
            if (ec2_tag_value[instance_loop] != ""):
                print('Not empty!!!')
                print(
                    '\tnic card name: ' + nic_tags['Value'] + ' - ec2-tag: ' + ec2_tag_value[instance_loop])
                # BREAD AND BUTTER OF FUNCTION: if the NIC tag is not the same as the EC2 tag
                if(nic_tags['Value'] != ec2_tag_value[instance_loop]):
                    # testing lines
                    print(
                        '####ENI name tag is not same as the ec2 instance name tag####')
                    tag_class.create_tag(
                        client, eni_ids[eni_loop], ec2_tag_key[instance_loop], ec2_tag_value[instance_loop])
            else:
                print('Empty!!!')
                print('\tnic card name: ' +
                        nic_tags['Value'])
                tag_class.create_tag(
                    client, eni_ids[eni_loop], 'Name', '')
else:
    print('There are no tags in this nic, creating one')
    if (ec2_tag_value[instance_loop] != ""):
        tag_class.create_tag(
            client, eni_ids[eni_loop], ec2_tag_key[instance_loop], ec2_tag_value[instance_loop])
    else:
        tag_class.create_tag(
            client, eni_ids[eni_loop], 'Name', '')