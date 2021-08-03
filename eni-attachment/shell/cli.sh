cli for detaching and attaching network interface

aws ec2 detach-network-interface --attachment-id eni-attach-04878c31b721aa9ed;

aws ec2 detach-network-interface --attachment-id eni-attach-0a7cde64a7fb50707; zip -g eni.zip function.py; terraform apply -auto-approve; sleep 10; aws ec2 attach-network-interface --device-index 1 --instance-id i-07916e3aa03900039 --network-interface-id eni-067671a98480e80ac



aws ec2 detach-network-interface --attachment-id eni-attach-04878c31b721aa9ed

aws ec2 attach-network-interface --device-index 1 --instance-id i-07916e3aa03900039 --network-interface-id eni-067671a98480e80ac

aws ec2 describe-instances --instance-ids i-07916e3aa03900039