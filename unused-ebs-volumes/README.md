# Unused EBS Volumes

### Goal

Optimizing cost by deleting unused EBS volumes that are not used after instance deletion.

### Motivation

Even though you might be using an EBS Volume -either the instance is in the rest state, or the instance has been deleted-, AWS still charges for the EBS volume capacity and storage. This function can be very cost effective when having multiple EBS volumes that are just unused when an EC2 instance has been deleted.  