PgBouncer => untuk membuat db(postgre) gak ngosngosan/hemat resource untuk connection

kind => Kubernetes in Docker

APM => Application Performance Monitoring

Trivy => Security Scanner untuk Container, File System, Git Repo, Kubernetes Cluster, VM Image/Disk.

## Prerequisites

```bash
# Install makefile
sudo apt install make

# Install Ansible
sudo apt install ansible

# Install Terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
```
