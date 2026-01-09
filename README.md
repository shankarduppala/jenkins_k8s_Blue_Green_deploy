# 🚀 Blue-Green Deployment using Jenkins, Docker, and Kubernetes (Minikube)

This project demonstrates a **Blue-Green deployment strategy** implemented using **Jenkins CI/CD**, **Docker**, **Docker Hub**, and **Kubernetes (Minikube)** on a **Windows machine**.

The deployment allows **zero-downtime releases** by switching traffic between Blue and Green environments using a Kubernetes Service.

---

## 🧰 Tools & Technologies Used

          - **Jenkins** – CI/CD automation
          - **Git & GitHub** – Source code management
          - **Docker & Docker Hub** – Containerization and image registry
          - **Kubernetes (Minikube)** – Container orchestration
          - **Nginx** – Web server
          - **Windows OS** – Jenkins master and Minikube setup

## 📂 Project Structure

jenkins_k8s_Blue_Green_deploy/

          app/
             |-index.html
          k8s/
            ├── deploy-blue.yaml
            ├── deploy-green.yaml
            └── service.yaml
          ├── Jenkinsfile
          ├── Dockerfile
---
## 🔁 Blue-Green Deployment Concept

          - **Blue Deployment** → Current live version
          - **Green Deployment** → New version
          - **Service (`web-svc`)** controls traffic using labels:
            - `version: blue`
            - `version: green`
          - Traffic is switched instantly by updating the Service selector.

---

## ⚙️ Prerequisites

            Ensure the following are installed and configured:
            
            - Docker Desktop (with Kubernetes disabled)
            - Minikube
            - kubectl
            - Jenkins (running on Windows)
            - Docker Hub account

---

## 🚀 Setup & Execution Steps

### 1️⃣ Start Minikube
      minikube start --driver=docker
      
Verify:

                kubectl get nodes
      
**2️⃣ Jenkins Setup**

Install Jenkins
Install required plugins:
                                    Git
                                    Docker Pipeline
                                    Credentials Binding
                                    kubectl cli

Add Credentials in Jenkins:
                
                                    Docker Hub credentials (Username & Password)

Kubernetes kubeconfig as Secret File
                
                                    add config file (.kube\config)
      
**3️⃣ Docker Image Build Logic**

Jenkins passes deployment type (blue or green) as a Docker build argument

UI displays which version is live
      Dockerfile

                                      FROM nginx:alpine
                                      ARG ENV
                                      ENV ENV=${ENV}
                                      COPY app/index.html /usr/share/nginx/html/index.html
                                      RUN sed -i "s/\${ENV}/${ENV}/g" /usr/share/nginx/html/index.html

**4️⃣ Kubernetes Manifests**
Blue Deployment

                    labels:
                      app: web
                      version: blue
Green Deployment

                    labels:
                      app: web
                      version: green
Service

                    selector:
                      app: web
                      version: blue
            
**5️⃣ Jenkins Pipeline Flow**
                                    1. Checkout code from GitHub
                                    2. Build Docker image (blue/green)
                                    3. Push image to Docker Hub
                                    4. Apply Kubernetes manifests
                                    5. Update deployment image
                                    6. Switch traffic using Service selector

**🧪 How to Trigger Deployment**
Manual Trigger
          Jenkins → Build with Parameters

                    Choose:
                        blue
                        green
                        rollback

**Verify Deployment**
                                          kubectl get deploy
                                          kubectl get pods
                                          kubectl get svc
                                
**Access application:**
                                          minikube service web-svc
            
**🔄 Rollback Strategy**
Rollback is instant by switching Service selector back to Blue:
                                          kubectl patch svc web-svc -p '{"spec":{"selector":{"version":"blue"}}}'


🎯 Key Highlights
                                      Zero-downtime deployment
                                      Immutable Docker images
                                      Traffic switching via Kubernetes Service
                                      Fully automated using Jenkins
                                      All configurations stored in Git
