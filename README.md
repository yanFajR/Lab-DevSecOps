# Secure Microservices with Observability

Single command setup for a **secure, observable, automated** microservices platform:

- Backend: NestJS (TypeScript)
- DB: PostgreSQL + PgBouncer
- Orchestrator: kind (local Kubernetes)
- Secrets: Infisical + `.machine.infisical.json`
- Monitoring: Elasticsearch APM + Kibana (docker-compose)
- Infra: Terraform (local) + Ansible
- Automation: Makefile + GitHub Actions
- Security: Trivy image scan

## Quick Start

```bash
# 1) Install prerequisites (Ubuntu/Debian)
#    Docker, Kind, Kubectl, Helm, Trivy, Infisical CLI
make bootstrap

# 2) Create local registry + kind cluster + ingress
make cluster

# 3) Start APM (Elasticsearch + Kibana + APM Server)
make apm

# 4) Provision secrets from Infisical to K8s
make secrets

# 5) Build, scan, and push image to local registry
make build scan push

# 6) Deploy API + Postgres + PgBouncer to Kubernetes
make deploy

# 7) Demo script (alerting/load/incident)
make demo
```

Kibana: http://localhost:5601 • APM: http://localhost:8200 • API (via Ingress): http://api.localtest.me/health

See **ARCHITECTURE.md** and **SYSTEM_DESIGN.md** for design and diagrams.
