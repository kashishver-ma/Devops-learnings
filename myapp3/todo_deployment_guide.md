# 🚀 TODO App Deployment Guide

**React + Next.js + Tailwind CSS + Firebase + AWS EC2 + Docker**

This guide explains how to deploy your TODO app on an AWS EC2 instance, containerize it with Docker, and push it to Docker Hub for public access.

---

## 1️⃣ Launch EC2 Instance

- Create an EC2 instance on AWS (Ubuntu recommended)
- Select a key pair and security group
- Add required **Inbound Rules**:
  - `22` → SSH access
  - `3000` → App access

---

## 2️⃣ SSH into EC2 & Update

```bash
ssh -i your-key.pem ubuntu@<EC2-Public-IP>
sudo apt update && sudo apt upgrade -y
```

---

## 3️⃣ Import Project from GitHub

```bash
git clone https://github.com/kashishver-ma/todo-list.git
cd todo-list
```

---

## 4️⃣ Install Docker & Setup Permissions

### Install Docker

```bash
sudo apt install docker.io -y
docker --version
```

### Add user to Docker group (so sudo is not needed every time)

```bash
sudo usermod -aG docker $USER
exit
# Re-login into EC2
```

### Check:

```bash
docker ps
```

---

## 5️⃣ Create Docker Image

### Create a Dockerfile in the project root:

```dockerfile
# Use Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build the Next.js app
RUN npm run build

# Expose port
EXPOSE 3000

# Start application
CMD ["npm", "run", "start"]
```

### Build image:

```bash
docker build -t todoimg .
# OR with tag
docker build -t todoimg:latest .
```

### Check:

```bash
docker images
```

---

## 6️⃣ Run Docker Container

```bash
docker run -p 3000:3000 --name todo-cont todoimg
```

**Format:**
```bash
docker run -p <host-port>:<container-port> --name <container-name> <image-name>
```

**Now access in browser:**
```
http://<EC2-Public-IP>:3000
```

> ⚠️ **Make sure port 3000 is allowed in EC2 inbound rules.**

---

## 7️⃣ Push to Docker Hub

### Login to Docker Hub

```bash
docker login -u <dockerhub-username>
```

*(Use Personal Access Token if required)*

### Tag & Push Image

```bash
docker tag todoimg:latest kashishverma12/todoimg:latest
docker push kashishverma12/todoimg:latest
```

**Now, you can pull & run the image anywhere:**

```bash
docker pull kashishverma12/todoimg:latest
docker run -p 3000:3000 --name todo-cont kashishverma12/todoimg:latest
```

---

## ⚠️ Common Issue: Firebase Unauthorized Domain

### Error Example:

```
FirebaseError: Firebase: Error (auth/unauthorized-domain).
The current domain is not authorized for OAuth operations.
```

### Fix:

1. Go to **Firebase Console** → **Authentication** → **Settings** → **Authorized domains**
2. Click **Add domain**
3. Add your EC2 Public IP (e.g., `35.154.12.184`)

---

## 🔍 Extra Note: Popup Auth & Security

When using `signInWithPopup`, Firebase opens a new browser window.

Modern browsers enforce **COOP** (Cross-Origin-Opener-Policy) and **COEP** (Cross-Origin-Embedder-Policy).

If your app sends headers like:
```
Cross-Origin-Opener-Policy: same-origin
```

→ the popup runs in an isolated context → Firebase cannot track if it closes.

This causes the warning:
```
Firebase's popup script cannot check if the popup closed.
```

### ✅ To fix: 
Always ensure your app's domain/IP is added in **Firebase Authorized Domains**.

---

## 🎉 Conclusion

👉 **This deployment is now portable, secure, and production-ready!**