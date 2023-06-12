# boundary_demo_stack

Creates a fully-functional HCP Boundary demo environment.

- configures an existing HCP Boundary cluster
- builds AWS infr (web servers, PKI worker, RDS instance, windows server)
- sets AWS security groups and networking rules to force traffic through Boundary.


What you need:
- AWS creds
- HCP Boundary cluster
- TFC account (or you can refactor the TF code to do it with OSS)
- Boundary desktop client installed


steps:
1. Create a keypair to be used for remote access. Do this either in AWS or locally (ssh-keygen -t rsa).  This is for SSH access and these will be set in the Boundary credential stores.  You can create separate keypairs for each resource, but for simplicity's sake we just create one and use it everywhere.
2. Set AWS account creds as TFC environmental variables.
3. Create HCP Boundary cluster and get the cluster ID, URL, and admin un/pw
4. Set the variables in TFC, and build it.  The workers should register automatically via the user_data script that is passed.
5. Now you can log into Boundary as the user that was created in the TF and connect to a target!




   
 
----- connect to PSQL
boundary connect postgres -target-id=<target-id> -username matty -dbname mydb
   
   
----- connect to EC2 instance via credential injection
In order to connect to an EC2 instance (vault or web target), start a connection in the desktop client and then do this in the terminal:
ssh -p <port> ec2-user@127.0.0.1 

Or you could also get the target ID and connect directly in the CLI:
boundary connect ssh -target-id=tssh_3ZJ3WsF5cP     
   
   
 ----- connect to windows instance
   Log into the AWS portal, go to EC2 > instances > connect > rdp > descrypt the password for that instance using the private key.  Connect using an RDP client with user: Administrator.
