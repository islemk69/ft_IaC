# Project

This module allow the creation of a Google Cloud Project, based on a name supplied by user.

<br>

## Required variables

- `project_name`: a name for the project, the project id is computed from
- `billing_account`: the Google Cloud billing account, needed for API activation

<br>

## Resources

- `project_suffix` ([random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id)): a generated id to create the project id

- `project` ([google_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project)): the project which will encapsulate all our Google Cloud resources

The following are [google_project_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service) resources used for API activation

- `compute_api`: Compute API, manage compute instance
- `networks_api`: Networks API, manage networks
- `domains_api`: Domains API, manage domain name
- `dns_api`: DNS API, manage DNS Zone
