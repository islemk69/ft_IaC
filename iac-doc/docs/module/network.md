# Module Network

This module manage the creation of a Virtual Private Cloud and his sub-component.


## Required variables

- `project_id`: project id to attach all resources to
- `project_name`: name to compute the resource name from

- `region`: the selected region to deploy
- `subnet_cidr`: a CIDR range for subnet


## Resources

- `vpc` ([google_compute_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)): A Virtual Private Cloud, basically oour private network

- `subnet` ([google_compute_subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)): a subnetwork for the compute instance

- `router` ([google_compute_router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router)): our VPC router

- `nat` ([google_compute_router_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat)): a NAT to allow compute instances to access the internet (for updates/installations) without exposing them

- `allow_web` ([google_compute_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)): Firewall allowing only http

- `private_ip_address` ([google_compute_global_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address)): Private IP address used by the private VPC connection

- `private_vpc_connection` ([google_service_networking_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection)): a private VPC connection for our internal traffic

