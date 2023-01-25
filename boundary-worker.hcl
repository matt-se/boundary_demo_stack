disable_mlock = true
hcp_boundary_cluster_id = "e9ac2d61-1eda-44e8-9d86-e456659b8bf7"
controller_generated_activation_token = "neslat_2KquuyxBTnzUrXBR6KJthvHwwyMpfRirfXARTLZCSsfwxmfHAJha7sp4uBPu1wYQYZb7EnRPEhQgMYbWPADULyxPU7u1d"
listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
        
worker {
  public_addr = "54.196.255.246"
  auth_storage_path = "home/ubuntu/boundary/worker1"
  tags {
    type = ["worker"]
  }
}
