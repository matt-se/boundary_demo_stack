disable_mlock = true
hcp_boundary_cluster_id = "98814fc9-b650-4469-96c0-5397232f19b1"
listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
        
worker {
  public_addr = "44.201.8.40"
  controller_generated_activation_token = "neslat_2Kq91Y3xyS1j5U9Ycj21rZfFg2raKge32N46BLMvrASi3E5wAiFNzGi9EivuNCYpdDWUqX6irYCKVjugfJQU42JNMMQcZ"
  auth_storage_path = "home/ubuntu/boundary/worker1"
  tags {
    type = ["worker"]
  }
}

