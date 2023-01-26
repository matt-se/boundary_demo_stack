disable_mlock = true
hcp_boundary_cluster_id = "e9ac2d61-1eda-44e8-9d86-e456659b8bf7"
listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}
        
worker {
  public_addr = "174.129.142.63"
  controller_generated_activation_token = "neslat_2KrcHSPQZQDTPPaFR4Fc3Pf1SVkALuCus3Y1zUgfypFxZUr8s17vNqoyEyuMUBEvrwSCox3ZykwSWGJByv5oRkDksDgQu"
  auth_storage_path = "home/ubuntu/boundary/worker1"
  tags {
    type = ["worker"]
  }
}
