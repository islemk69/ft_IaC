# Ft_IaC - Infrastructure as Code (GCP)

This project deploys a highly available, scalable web application infrastructure on Google Cloud Platform using Terraform.

## 🏗 Architecture

The infrastructure acts as a transparent layer for the application, ensuring High Availability (HA) and Security.

```mermaid
graph TD
    User[User / Internet] -->|HTTP:80| LB[Global HTTP Load Balancer]
    LB -->|Health Checks| MIG[Managed Instance Group]
    
    subgraph GCP Region (e.g., us-central1)
        subgraph VPC Network
            subgraph Private Subnet
                MIG -->|Auto Scaling (2-4 nodes)| VM1[App Instance 1]
                MIG --> VM2[App Instance 2]
                NAT[Cloud NAT] -.->|Outbound Internet| VM1
                NAT -.->|Outbound Internet| VM2
            end
            
            subgraph Data Layer
                VM1 -->|Private IP| SQL[(Cloud SQL - MySQL)]
                VM2 -->|Private IP| SQL
            end
        end
    end
    
    Monitoring[Cloud Monitoring] -.->|Alerting > 80% CPU| Email[Email Notification]
```

### Key Components
- **Global Load Balancer**: Distributes traffic to healthy instances.
- **Auto-Scaling Group**: Automatically adjusts between 2 and 4 instances based on CPU load.
- **Cloud SQL**: Managed MySQL 8.0 instance with Private IP only (no public access).
- **Cloud NAT**: Allows private instances to access the internet (for updates/installations) without exposing them.
- **Monitoring**: Alerts triggers via Email if CPU usage exceeds defined threshold.

## 🚀 Usage

### Prerequisites
- Google Cloud Platform account with billing enabled.
- `gcloud` CLI installed and authenticated (`gcloud auth application-default login`).
- `terraform` installed.

### Configuration
1. **Initialize** the project:
   ```bash
   cd src
   terraform init
   ```

2. **Configure Variables**:
   Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   Edit `terraform.tfvars`:
   - Set your `gcp_project_id`.
   - **Important**: Choose a strong `db_password`.
   - Configure `alert_email` for notifications.

3. **Deploy**:
   ```bash
   terraform apply
   ```

### Inputs (Simplified)
| Variable | Description | Options | Default |
|----------|-------------|---------|---------|
| `gcp_region` | Deployment Region | `US`, `Europe`, `Asia` | `US` |
| `machine_type` | Instance Size | `small`, `medium`, `large` | `small` |

## 🛡 Security & Compliance
- **Secrets Management**: `terraform.tfvars` is git-ignored. Database passwords are changed via variables, never hardcoded.
- **Network Isolation**: Database and App instances have **no public IPs**.
- **Least Privilege**: Application connects to DB via specific user credentials.

## 🧹 Cleanup
To destroy the infrastructure and stop billing:
```bash
terraform destroy
```
*Note: If `service_networking_connection` fails to delete due to dependencies, run `terraform state rm google_service_networking_connection.private_vpc_connection` and try again.*
