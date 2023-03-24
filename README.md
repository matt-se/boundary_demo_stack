# boundary_demo_stack

Creates a fully-functional HCP Boundary demo environment.

- configures HCP Boundary cluster
- builds AWS infr (web servers, PKI worker, RDS instance)
- sets AWS security groups and networking rules to force traffic through Boundary.


What you need:
- AWS creds
- HCP Boundary cluster
- TFC account (or you can refactor the TF code to do it with OSS)
- Boundary desktop client installed


steps:
1. Create two keypairs, one for the web servers and one for the pki worker. Do this either in AWS or locally (ssh-keygen -t rsa).  Set these at variables in the TFC workspace.
2. Set AWS account creds as TFC environmental variables.
3. Create HCP Boundary cluster and get the cluster ID, URL, and admin un/pw
4. Set HCP variables in TFC, and build it.  You should get the worker registration code as an output.
5. Update the boundary_worker.hcl config file to include the correct values for hcp_boundary_cluster_id, public_addr, and controller_generated_activation_token.
6. SSH into the PKI worker EC2 instance and execute the commands in the boundary_setup.sh file (or run it).
7. Now you can log into Boundary as the user that was created in the TF and connect to a target!



boundary authenticate password \
   -auth-method-id=$BOUNDARY_AUTH_METHOD_ID \
   -login-name=bobby-hill

boundary connect postgres -target-id=<target-id> -username matty -dbname mydb
boundary connect ssh -target-id=tssh_3ZJ3WsF5cP     
