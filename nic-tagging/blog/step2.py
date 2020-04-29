# Iterate through the instances
for instance in ec2["Instances"]:
    print('instance id: ' + instance['InstanceId'])

    # Check if there are any tags in the selected instance
    # IMPORTANT: If there is no tag and the code doesn't evaluate that, the code will crash
    if areThereEC2Tags in instance:

        # Assign the length of how many tags an instance is using
        len_tags = len(instance['Tags'])

        # Iterate through all the tags in the instance
        for tags in instance["Tags"]:
            # DEBUGGING: this will print out the tag KEY and VALUE
            print('tag key: ' + tags['Key'] +
                  ' tag value: ' + tags['Value'])

            # Comparison to know whether the Key is Name
            if (tags['Key'] == 'Name'):
                # Append the key and the value in the global variables
                ec2_tag_key.append(tags['Key'])
                ec2_tag_value.append(tags['Value'])
                # DEBUGGING: this will print out the NAME VALUE of the instance
                print('\tYY - ec2 tag - key: ' +
                      ec2_tag_key[instance_loop] + ' value: ' + ec2_tag_value[instance_loop])
                break

            # If the code has found a tag with key Name, create one tag with
            # Key Name and Value Empty.
            # IMPORTANT: If there is no name tag there will be a logical
                # error since we're assigning Name tag from EC2 to the NICs.
            elif (instance_tag_loop >= len_tags-1):
                # Create a new tag which key is Name and value is blank
                ec2_tag_key.append('Name')
                ec2_tag_value.append('')
                # DEBUGGING: this will print out the NAME VALUE of the instance
                print('\tXX - ec2 tag - key: ' +
                      ec2_tag_key[instance_loop] + ' value: ' + ec2_tag_value[instance_loop])
            instance_tag_loop += 1  # increase the count to go to the other value in the array

        instance_tag_loop = 0  # note: "what is this doing here?"
    # CODE FOR NIC - STEP 3 & 4
    else:
        print('Please assign a tag to the instance: ' +
              instance['InstanceId'])

    instance_loop += 1  # increase the count to go to the other value in the array
    print('\n')
