# System Design & Topology

## Components

- **API (NestJS)** → serves REST endpoints with JWT; emits traces/metrics/logs.
- **PostgreSQL** → persistent DB; **PgBouncer** for pooling.
- **Ingress NGINX** → HTTP entry with optional rate limiting.
- **Elasticsearch/Kibana/APM Server** → monitoring, APM, dashboards.
- **Infisical** → secret source; sync to K8s.
- **Terraform/Ansible/Makefile** → automation/IaC.
- **Trivy** → container scanning in CI and locally.

  ## Diagrams (Mermaid)

### System Architecture

```mermaid
flowchart LR
A[Client] -->|HTTP| I[Ingress NGINX]
I --> API[NestJS API]
API --> PG[PgBouncer]
PG --> DB[(PostgreSQL PVC)]
API --> APM[APM Server]
APM --> ES[(Elasticsearch)]
ES --> K[Kibana]
Inf[Infisical] -->|sync| Sec[Kubernetes Secrets]
Sec --> API
```

### Network Topology & Zones

```mermaid
flowchart TB
subgraph Public
  A[Client]
end
subgraph Cluster
  subgraph Ingress-Namespace
    I[Ingress NGINX]
  end
  subgraph Apps-Namespace
    API[NestJS API]
  end
  subgraph Platform-Namespace
    PG[PgBouncer]
    DB[(PostgreSQL)]
  end
end
A --> I --> API
API --> PG --> DB
```

### Data Flow

```mermaid
sequenceDiagram
  participant C as Client
  participant I as Ingress
  participant A as API
  participant P as PgBouncer
  participant D as PostgreSQL
  participant S as APM Server
  C->>I: HTTP request
  I->>A: Proxy to /
  A->>P: SQL query
  P->>D: Connection (pooled)
  A->>S: Trace/metrics
  S->>ES: Store
  ES->>K: Visualize
```

### Automation Workflow

```mermaid
flowchart LR
Dev --push--> GitHub --> CI[Build + Trivy]
CI --> Registry[(Local Registry)]
Dev --> Makefile --> Terraform --> kind
Makefile --> Ansible --> Tools
Makefile --> kubectl/helm --> Cluster
```
