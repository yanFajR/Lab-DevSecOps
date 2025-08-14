# Troubleshooting

- If Ingress doesn't route:
  - `kubectl -n ingress-nginx get pods`
  - Add hosts: `api.localtest.me` maps to `127.0.0.1` (use localtest.me which already resolves to 127.0.0.1).
- If APM not receiving data: check `APM_SERVER_URL` env in deployment and logs of `apm-server` container.
- Trivy failing: Update vulnerability DB: `trivy image --download-db-only`.
- Docker permission denied: add your user to docker group or use sudo.
