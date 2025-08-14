# Demo Script

1. `make setup` – bootstrap tools, create cluster, start APM.
2. `make secrets` – sync secrets from Infisical.
3. `make deploy` – deploy DB + PgBouncer + API to K8s.
4. Send requests:
   - `curl http://api.localtest.me/health`
   - `curl http://api.localtest.me/metrics`
   - `curl -XPOST http://api.localtest.me/auth/login -d '{"username":"u","password":"p"}' -H 'Content-Type: application/json'`
5. Observe Kibana APM at http://localhost:5601.
6. Run `make demo` to simulate load + errors + pod deletion.
7. Optional:
   - `bash scripts/pg_backup.sh`
   - `bash scripts/chaos.sh`
