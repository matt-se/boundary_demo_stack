# boundary_demo_stack

Creates a fully-functional HCP Boundary demo stack.

- configures HCP Boundary cluster
- builds AWS infr (web servers, PKI worker, dB)
- sets AWS security groups and networking rules to force traffic through Boundary.


What you need:
- AWS creds
- HCP Boundary cluster
- TFC account (or you can refactor the TF code to do it with OSS)
- Boundary desktop client installed


steps:
1. Create two keypairs, one for the web servers and one for the pki worker. Do this either in AWS or locally (ssh-keygen -t rsa)
2. Set AWS account creds as TF variables
3. Create HCP Boundary cluster and get the cluster ID, URL, and admin un/pw
4. set varables in tf

