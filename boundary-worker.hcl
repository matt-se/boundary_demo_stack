disable_mlock = true
hcp_boundary_cluster_id = "98814fc9-b650-4469-96c0-5397232f19b1"
listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
        
worker {
  public_addr = "18.209.241.150"
  controller_generated_activation_token = "neslat_2KrkFMrCtM8GnTrzvjTQrWBfGB5Q7wdM6Eea53vhyFmzacG79m8kDYziwQ16cJ6jtqWhYsUta8k3MJnp5F5GwuybjwrJN"
  auth_storage_path = "home/ubuntu/boundary/worker1"
  tags {
    type = ["worker"]
  }
}

