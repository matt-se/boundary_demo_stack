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
1. Create three keypairs, one for the web servers, onw for the vault servers, and one for the pki workers. Do this either in AWS or locally (ssh-keygen -t rsa).  Set these at variables in the TFC workspace.  This is for SSH access and these will be set as Boundary credential stores.
2. Set AWS account creds as TFC environmental variables.
3. Create HCP Boundary cluster and get the cluster ID, URL, and admin un/pw
4. Set the variables in TFC, and build it.  You should get the worker registration code as an output.
5. Now you can log into Boundary as the user that was created in the TF and connect to a target!



boundary authenticate password \
   -auth-method-id=$BOUNDARY_AUTH_METHOD_ID \
   -login-name=bobby-hill
   
 
----- connect to PSQL
boundary connect postgres -target-id=<target-id> -username matty -dbname mydb
   
   
----- connect to EC2 instance via credential injection
In order to connect to an EC2 instance (vault or web target), start a connection in the desktop client and then do this in the terminal:
ssh -p <port> ec2-user@127.0.0.1 

Or you could also get the target ID and connect directly in the CLI:
boundary connect ssh -target-id=tssh_3ZJ3WsF5cP     
