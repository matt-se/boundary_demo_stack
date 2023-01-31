disable_mlock = true
hcp_boundary_cluster_id = "98814fc9-b650-4469-96c0-5397232f19b1"
listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
        
worker {
  public_addr = "174.129.142.63"
  controller_generated_activation_token = "neslat_2KqsXTT2FSxgjkKxwCzo3NZ7bPNDvE36vxHiSLKUtSjjPTD1MDeGDWKjBDCE3e4wNTZym9azZsKoW5RaaACWY8WXJu4Ca"
  auth_storage_path = "home/ubuntu/boundary/worker1"
  tags {
    type = ["worker"]
  }
}

