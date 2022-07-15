# EBS Tagging

### Goal
Tags EBS volumes with EC2 instance Name tag.

### Motivation

Sometimes, having volumes with little description about what they are can be problematic. This is indeed problematic when having too many volumes in the account since it can be extremelly difficult to troubleshoot. To avoid this situation, this automation piece is designed to tag volumes with the respective names from their EC2 instances which these volumes are attached.

For example:
- EC2 'AutomateWebServers' has three volumes
  - Two of these volumes don't have the tag 'Name'
- This automation tool will bring tags to these two untagged volumes with name 'AutomateWebServers'