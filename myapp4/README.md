# Deploy a Simple Web Application on Kubernetes (Systematic Guide)

## 1. Why Kubernetes Needs Resources

Kubernetes is not lightweight like Docker. Even on a **single-node setup**, it requires **at least 2 CPU cores** because it runs several critical control plane components:

* **kube-apiserver** – main API server
* **kube-controller-manager** – manages node controllers, replication, endpoints
* **kube-scheduler** – schedules pods to nodes
* **etcd** – key-value store for cluster data
* **kubelet** – node agent that runs pods
* **kube-proxy** – network routing for services

Each of these components needs CPU time. With only **1 CPU**, Kubernetes may fail to start or run unstable.

### Minimum Requirements

* **2 CPU cores**:
   * 1 for control plane processes
   * 1 for user pods/workloads
* **Memory:** 1–2 GB is sufficient for testing, flexible.

## 2. Lightweight Alternatives for Limited Resources

If you only have **1 CPU** (like AWS Free Tier t2.micro), you can use:

* **k3s** – lightweight Kubernetes, runs on 1 CPU
* **Kind** – Kubernetes in Docker containers, works on 1 CPU

## 3. Checking Your System

### On Windows
Open Command Prompt and run:

```cmd
echo %NUMBER_OF_PROCESSORS%
```

* If the number of processors is **>1**, you can run Minikube.

### On AWS
Create an EC2 instance with at least **2 CPUs** (t2.small or higher) for full Kubernetes.

## 4. Setting Up Kubernetes on Windows (Using WSL + Ubuntu)

### Step 1: Install WSL

1. Open **PowerShell as Administrator**.
2. Run:

```powershell
wsl --install
```

This installs:
* **Virtual Machine Platform** (required for WSL 2)
* **Windows Subsystem for Linux**
* **Default Linux distro** (usually Ubuntu)

### Step 2: Wait for Installation

* Progress may show `[0.0%]` initially → normal
* Let it finish (a few minutes)

### Step 3: Restart Your PC

* Required to finalize WSL installation

### Step 4: Open Ubuntu

* From the **Start menu → Ubuntu**
* Set up Linux username and password

### Step 5: Verify WSL Installation

```bash
wsl --list --verbose
```

* Should show **Ubuntu with VERSION 2**

## 5. Installing Docker

Inside Ubuntu, install Docker:

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

Optional: Add user to docker group to avoid `sudo`:

```bash
sudo usermod -aG docker $USER
```

* Close and reopen Ubuntu
* Verify:

```bash
docker --version
```

## 6. Installing Minikube

### Download and Install

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Verify Installation

```bash
minikube version
```

## 7. Installing kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Verify kubectl Installation

```bash
kubectl version --client
```

## 8. Starting Minikube

```bash
minikube start --driver=docker --cpus=2 --memory=4096
```

* **--driver=docker** → uses Docker inside Ubuntu
* **--cpus=2** → allocate 2 cores
* **--memory=4096** → allocate 4 GB RAM

## 9. Verify Kubernetes Cluster

### Check Cluster Status

```bash
kubectl get nodes
kubectl cluster-info
```

### Deploy a Simple Application

```bash
# Create a deployment
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4

# Expose the deployment as a service
kubectl expose deployment hello-node --type=NodePort --port=8080

# Get service information
kubectl get services

# Access the application
minikube service hello-node
```

This opens the deployed web application in your browser.

## 10. Alternative: Deploy a Custom Web Application

### Create a Simple HTML Application

Create a directory and files:

```bash
mkdir my-web-app
cd my-web-app
```

Create `index.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>My Kubernetes App</title>
</head>
<body>
    <h1>Hello from Kubernetes!</h1>
    <p>This application is running in a Kubernetes pod.</p>
</body>
</html>
```

Create `Dockerfile`:

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

### Build and Deploy

```bash
# Build the Docker image (using Minikube's Docker daemon)
eval $(minikube docker-env)
docker build -t my-web-app:latest .

# Create Kubernetes deployment
kubectl create deployment my-web-app --image=my-web-app:latest --image-pull-policy=Never

# Expose the service
kubectl expose deployment my-web-app --type=NodePort --port=80

# Access the application
minikube service my-web-app
```

## 11. Managing Your Application

### View Running Pods

```bash
kubectl get pods
kubectl describe pod <pod-name>
```

### View Services

```bash
kubectl get services
```

### Scale Your Application

```bash
kubectl scale deployment my-web-app --replicas=3
```

### Update Your Application

```bash
# Build new version
docker build -t my-web-app:v2 .

# Update deployment
kubectl set image deployment/my-web-app my-web-app=my-web-app:v2
```

### View Application Logs

```bash
kubectl logs deployment/my-web-app
```

## 12. Cleanup Commands

### Stop and Clean Up

```bash
# Delete deployments and services
kubectl delete deployment hello-node
kubectl delete service hello-node
kubectl delete deployment my-web-app
kubectl delete service my-web-app

# Stop Minikube
minikube stop

# Delete Minikube cluster (removes all data)
minikube delete
```

## 13. Key Points About WSL

* Runs Linux inside Windows – no dual boot needed
* Supports Linux commands & apps: `bash`, `ls`, `grep`, `apt`, etc.
* **WSL 1:** Translates Linux calls to Windows (older, slower)
* **WSL 2:** Lightweight VM with full Linux kernel, faster & more compatible
* Can run GUI apps (WSL 2 + Windows 11)
* Works seamlessly with **Docker** and **Minikube**

## 14. Troubleshooting

### Common Issues

**Minikube won't start:**
```bash
minikube delete
minikube start --driver=docker --cpus=2 --memory=2048
```

**Docker permission denied:**
```bash
sudo usermod -aG docker $USER
# Logout and login again
```

**kubectl command not found:**
```bash
# Ensure kubectl is in PATH or reinstall
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/kubectl
```

### Useful Commands for Debugging

```bash
# Check Minikube status
minikube status

# Check cluster events
kubectl get events

# Describe resources for more details
kubectl describe deployment <deployment-name>
kubectl describe service <service-name>
kubectl describe pod <pod-name>
```

## ✅ Outcome

After following these steps, you have a **fully functional Kubernetes environment on Windows**, ready to deploy and practice web applications locally.

### What You've Accomplished:

1. ✅ Set up WSL2 with Ubuntu on Windows
2. ✅ Installed Docker and Minikube
3. ✅ Created a working Kubernetes cluster
4. ✅ Deployed and accessed web applications
5. ✅ Learned basic Kubernetes operations

### Next Steps:

* Explore Kubernetes manifests (YAML files)
* Learn about ConfigMaps and Secrets
* Practice with different deployment strategies
* Try persistent volumes for data storage