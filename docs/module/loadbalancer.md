# Load Balancer

This module allow external traffic and redirect it between our compute instance.

<br>

## Required variables

- `project_id`: project id to attach all resources to
- `project_name`: name to compute the resource name from


- `domain_name`: the domain to use as entrypoint
- `instance_group`: the instance group to redirect traffic to

<br>

## Resources

- `hc` ([google_compute_health_check](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check)): the healthcheck to use for checking instances

- `backend` ([google_compute_backend_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service)): the load balancer, targeting a backend, in our case it's our Instance Group Manager

- `lb` ([google_compute_url_map](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map)): url map to route traffic from proxy to load balancer

- `proxy` ([google_compute_target_http_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy)): a HTTP proxy sitting before the load balancer, it only redirect to HTTPS

- `http` ([google_compute_global_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule)): a forwarding rule to accept HTTP request and forward them to proxy

- `default` ([google_compute_managed_ssl_certificate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate)): SLL certificate for HTTPS

- `proxy` ([google_compute_target_https_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy)): a HTTPS proxy sitting before the load balancer

- `https` ([google_compute_global_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule)): a forwarding rule to accept HTTPS request and forward them to proxy

- `dns_record_sub` ([ovh_domain_zone_record](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/domain_zone_record)): the domain name record
