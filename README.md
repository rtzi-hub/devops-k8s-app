# DevOps Kubernetes Application Deployment 🚀

## **Overview**
This project automates the deployment of a **Node.js application** with a **MongoDB database** using **Kubernetes and Helm**. The entire process is automated using a **single deploy script (`deploy.sh`)**.

---

## **1️⃣ Prerequisites**
Before proceeding, ensure you have the required dependencies:

- **Docker** (for containerization)
- **Minikube** (for running a local Kubernetes cluster)
- **kubectl** (Kubernetes CLI)
- **Helm** (for deploying Helm charts)
- **Git** (for cloning the repository)

### **Check if all dependencies are installed:**
Run this command:

```bash
docker -v
minikube version 
kubectl version 
helm version 
git --version
```
If not you can use those commands manually:
```bash
sudo apt update && sudo apt install -y docker.io git && \
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && sudo install minikube-linux-amd64 /usr/local/bin/minikube && \
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## **2️⃣ Clone the Repository**
Run the following command to **clone the project**:

```bash
git clone https://github.com/rtzi-hub/devops-k8s-app.git
cd devops-k8s-app
```

---

## **3️⃣ Grant Execute Permission to the Deploy Script**
Ensure the script is executable:

```bash
chmod +x deployment-scripts/deploy.sh
```

---

## **4️⃣ Run the Deployment**
Deploy everything (Docker, Kubernetes, Helm) in **one command**:

```bash
./deployment-scripts/deploy.sh
```

This script will:
✔️ Start **Minikube**  
✔️ Build **Docker images**  
✔️ Deploy the app and **MongoDB**  
✔️ Expose the **Node.js API**  

---

## **5️⃣ Verify the Deployment**
### **Check Running Pods**
To check if all Pods are running, use:

```bash
kubectl get pods
```

#### ✅ **Expected Output**

---

### **Check Running Services**
To confirm if the services are exposed, use:

```bash
kubectl get svc
```

#### ✅ **Expected Output**

The application should be exposed at **NodePort** `30007`.

---

## **6️⃣ Access the Application**
Run:

```bash
curl $(minikube ip):30007
curl $(minikube ip):30007/health
curl $(minikube ip):30007/assignment
```
You will see this output when all working.
![image](https://github.com/user-attachments/assets/4014f39b-02dd-458c-9966-41bdcceb09f6)

---

## **7️⃣ Uninstall & Cleanup**
To remove everything:

```bash
helm uninstall devops-app
minikube delete
```

---

## **📌 Troubleshooting**
If you encounter issues:

### **1. Check Logs**
```bash
kubectl logs -l app=devops-app
```

### **2. Verify Service Exposure**
```bash
kubectl get svc devops-app
```

### **3. Restart the Pod**
```bash
kubectl rollout restart deployment devops-app
```

---

## **📢 Conclusion**
This project demonstrates:
- ✅ **Fully automated Kubernetes deployment**
- ✅ **Helm-based microservice management**
- ✅ **Docker multi-stage builds**
- ✅ **MongoDB integration with Kubernetes**
- ✅ **Rolling updates with zero downtime**

---

## **👤 Author**
This project is maintained by **rtzi-hub** 🚀.

---

🚀 **Just copy, paste, and deploy!** 🚀

