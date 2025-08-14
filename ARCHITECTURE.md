# Architecture Decisions

- **Local Kubernetes (kind)** with a local Docker registry on `localhost:5001` to emulate realistic image pushing/pulling and to enable Trivy scanning before deploy.
- **Security-first containers**: non-root, read-only filesystem in K8s, dropped capabilities, resource limits and probes for liveness/readiness.
- **Secrets via Infisical** synced to Kubernetes Secrets (no secrets in repo). `.machine.infisical.json` used for machine identity.
- **Observability**: Elasticsearch APM + Kibana for traces/metrics/logs. App is instrumented using `elastic-apm-node`.
- **PostgreSQL + PgBouncer**: Stable connection pooling; daily backup CronJob (sample script) and simple failover simulation by restarting the primary pod.
- **Automated Alerting**: Kibana alert rules (error rate/latency) can post to a webhook. Demo uses a simple Slack/Discord webhook script.
- **IaC**: Terraform creates cluster & registry; Ansible bootstraps dependencies; Makefile orchestrates workflows.
- **Compliance/Security**: Trivy image scanning gate, network policies, and secure Admission via Pod security context (bonus: add Kyverno later).
