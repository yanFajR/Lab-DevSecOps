# Assumptions

- Single-node local cluster with kind suitable for demonstration (not production).
- Secrets stored in Infisical; Kubernetes only contains synced secrets.
- Minimal auth for demo; JWT secret is provided via Infisical.
- APM stack runs outside the cluster via Docker Compose for simplicity.
