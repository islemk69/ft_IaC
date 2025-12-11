# Module Autoscaling

This Module manage the compute instance. It use an Autoscaler and a Group Instance Manager to create and configure instance based on the current needs.

## Required variables

- `project_id`: project id to attach all resources to
- `project_name`: name to compute the resource name from

- `region`: the deployment region
- `machine_type`: what type of instance to create
- `vpc_id`: the VPC ID
- `subnet_id`: the subnet ID

- `db_host`: database IP
- `db_user`: database user
- `db_password`: database password
- `db_name`: database name

## Resources

- `app_template` ([google_compute_instance_template](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template)): an Instance Template used to create new instance, the Template is based on `ubuntu-2204-lts` and use a `user_data` script to install docker and start the app 

- `app_mig` ([google_compute_region_instance_group_manager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager)): the Instance Group Manager, responsible to create new instance using the Template

- `app_autoscaler` ([google_compute_region_autoscaler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler)): the Autoscaler, adjusting the number of instance based on th current load

