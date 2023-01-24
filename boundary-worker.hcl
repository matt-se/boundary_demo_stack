disable_mlock = true
hcp_boundary_cluster_id = "268a4142-1c7f-4c69-af02-853ba8557247"

listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
        
worker {
  public_addr = "3.86.238.242"
  auth_storage_path = "home/ubuntu/boundary/worker1"
  tags {
    #key = ["demo"],
    type = ["worker"]
  }
}