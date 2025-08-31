# Application Deployment Methods - Interview Guide

## Quick Reference Table

| Stage | Command Example | Benefits | Limitations |
|-------|----------------|----------|-------------|
| **Local** | `node server.js` | Easy to start, fast dev | Only dev machine, no scale |
| **VM** | `ssh → install → run` | Runs in cloud, accessible | Manual setup, wasteful, no auto scale |
| **Docker** | `docker run myapp:v1` | Portable, consistent, lightweight | Still manual scaling, no orchestration |
| **Kubernetes** | `kubectl apply -f app.yaml` | Self-healing, scalable, automated | More complex, needs cluster |

## Real World Analogies 🌍

- **Local:** Cooking noodles in your kitchen → only you can eat
- **VM:** Renting a flat → you bring ingredients and cook (manual setup)
- **Docker:** Buying a packaged meal → same taste anywhere, just heat and serve
- **Kubernetes:** Food delivery service → you say "2 pizzas tonight" and they handle cooking, scaling, delivery automatically

## Interview-Level Deep Dive

### 1. Local Development
**What it is:** Running applications directly on developer's machine

**Technical Details:**
- Uses host OS directly
- Dependencies installed globally or via package managers
- Environment variables set in shell/IDE
- Database runs locally (SQLite, local MySQL/PostgreSQL)

**Interview Questions You Should Know:**
- *"Why can't we just run everything locally in production?"*
  - **Answer:** No external access, single point of failure, doesn't scale, environment inconsistencies ("works on my machine")

- *"What's the main problem with local development?"*
  - **Answer:** Environment drift - different OS versions, dependencies, configurations between developers

**When to Use:** Initial development, prototyping, debugging

---

### 2. Virtual Machines (VMs)
**What it is:** Full operating system virtualization

**Technical Details:**
- Hypervisor creates isolated OS instances
- Each VM has own kernel, memory allocation, storage
- Examples: AWS EC2, Google Compute Engine, VMware
- Provisioning via scripts (Ansible, Terraform) or manual SSH

**Interview Questions:**
- *"What's the difference between VM and container?"*
  - **Answer:** VM virtualizes entire OS (heavy), container shares host kernel (lightweight)

- *"Why are VMs wasteful?"*
  - **Answer:** Resource overhead (each VM needs full OS), slow startup times, over-provisioning for peak loads

- *"How do you handle VM scaling?"*
  - **Answer:** Manual or auto-scaling groups, load balancers, but slower than containers (minutes vs seconds)

**When to Use:** Legacy applications, specific OS requirements, strong isolation needs

---

### 3. Docker Containers
**What it is:** Application containerization using Linux namespaces and cgroups

**Technical Details:**
- Packages app + dependencies into portable image
- Shares host kernel, isolated processes/filesystem
- Dockerfile defines build steps
- Registry stores images (Docker Hub, ECR, GCR)

**Key Commands:**
```bash
docker build -t myapp:v1 .
docker run -p 8080:3000 myapp:v1
docker-compose up  # Multi-container apps
```

**Interview Questions:**
- *"Explain Docker layers and caching"*
  - **Answer:** Each Dockerfile instruction creates layer, cached for reuse, order matters for optimization

- *"What's the difference between image and container?"*
  - **Answer:** Image is blueprint/template, container is running instance

- *"How do you handle data persistence?"*
  - **Answer:** Volumes (managed by Docker) or bind mounts (host filesystem)

- *"What are Docker's limitations for production?"*
  - **Answer:** No native clustering, manual networking, no auto-healing, manual scaling

**When to Use:** Development consistency, CI/CD pipelines, microservices, cloud migration

---

### 4. Kubernetes
**What it is:** Container orchestration platform for automating deployment, scaling, and management

**Technical Details:**
- Master node (API server, etcd, scheduler, controller)
- Worker nodes (kubelet, kube-proxy, container runtime)
- Resources: Pods, Services, Deployments, ConfigMaps, Secrets

**Key Concepts:**
- **Pod:** Smallest deployable unit (usually 1 container)
- **Service:** Network abstraction for pod access
- **Deployment:** Manages pod replicas and rolling updates
- **Ingress:** HTTP/HTTPS routing to services

**Sample YAML:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:v1
        ports:
        - containerPort: 3000
```

**Interview Questions:**
- *"Explain Kubernetes architecture"*
  - **Answer:** Master-worker pattern, declarative API, control loops reconciling desired vs actual state

- *"What happens when a pod dies?"*
  - **Answer:** Deployment controller detects difference, creates new pod, service routes traffic automatically

- *"How does Kubernetes handle scaling?"*
  - **Answer:** Horizontal Pod Autoscaler (HPA) based on CPU/memory/custom metrics, Vertical Pod Autoscaler for resource requests

- *"What's the difference between Service types?"*
  - **Answer:** ClusterIP (internal), NodePort (external via node), LoadBalancer (cloud LB), ExternalName (DNS)

- *"How do you handle configuration and secrets?"*
  - **Answer:** ConfigMaps for non-sensitive data, Secrets for sensitive data, both mounted as volumes or env vars

**Advanced Topics:**
- **Networking:** CNI plugins, Network Policies, Ingress Controllers
- **Storage:** Persistent Volumes, Storage Classes, StatefulSets
- **Security:** RBAC, Pod Security Policies, Network Policies
- **Observability:** Logging (ELK/EFK), Monitoring (Prometheus), Tracing (Jaeger)

**When to Use:** Production workloads, microservices, high availability needs, auto-scaling requirements

## Progression Path Interview Answer

*"How would you deploy a web application from development to production?"*

**Answer Structure:**
1. **Start Local:** Develop and test on local machine
2. **Containerize:** Create Dockerfile for consistency
3. **VM for Simple Cases:** Small apps or legacy systems
4. **Kubernetes for Scale:** Production workloads needing reliability, scaling, and automation

**Follow-up:** *"What factors determine which approach to choose?"*
- Team size and expertise
- Application complexity and scale requirements
- Budget and infrastructure constraints
- Compliance and security needs
- Time to market requirements

## Common Pitfalls to Avoid

1. **Docker in Production:** Running single containers without orchestration
2. **Kubernetes Overkill:** Using K8s for simple, low-traffic applications
3. **Configuration Drift:** Not using Infrastructure as Code
4. **Security Negligence:** Running as root, not scanning images
5. **Resource Limits:** Not setting CPU/memory limits leading to noisy neighbors

This progression represents the evolution of deployment practices, each solving limitations of the previous approach while introducing new complexity.