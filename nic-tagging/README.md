# NIC Tagging

### Goal

Tag Network Interfaces from EC2 instances with the corresponding EC2 instance Name tag for which the interface is attached to.

### Motivation

Troubleshooting instance connectivity can be a very difficult task when dealing with multiple network interfaces (NIC). One of the challenges I constantly face is having to figure out networking issues on EC2 instances. Unfortunately, the AWS console initially only provides the instance in which the NIC is attached. This can become even more problematic when an EC2 instance has more than 1 NIC.

So I decided to create an automation piece that would go through all the instances in the environment and tag the NIC with their corresponding EC2 instance name tag. For example: if the NIC did not have a Name tag, the code would identify the EC2 Name tag and then assign it to the NIC.