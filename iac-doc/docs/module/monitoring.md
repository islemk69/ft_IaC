# Module Monitoring

This module enable email alerts for monitoring the cloud status.

## Required variables

- `project_id`: project id to attach all resources to
- `project_name`: name to compute the resource name from

- `alert_email`: the email address to send alert


## Resources

- `email` ([google_monitoring_notification_channel](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel)): a notification channel via email

- `high_cpu` ([google_monitoring_alert_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy)): an alert policy to trigger alert when compute instance CPU usage hit a threshold

