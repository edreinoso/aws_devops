Fundamental questions
Why would there be a need to have two network interfaces?
Why would they have to be in the same subnet? It's not possible to have two ENIs in different subnets
    Why can't an instance have a secondary private IPv4 address on the primary network interface?
    Why can't they not be in different subnets? 


Steps for configurations
Linux Network Routing changes
Two phase infrastructure

1) Create routing rules that select the routing table that sends the server's response traffic out the same interface on which the request arrived.

2) Create two routing tables; each table routes out through a different interface


Scripting challenges
1. Get the ip address of both interfaces
2. Get the default gateway ip address


References
- Much of the explanation about asymmetric routing was taken from this great article! https://etude01.com/asymmetric-routing/
- Getting gateway ip (shell): https://serverfault.com/questions/31170/how-to-find-the-gateway-ip-address-in-linux