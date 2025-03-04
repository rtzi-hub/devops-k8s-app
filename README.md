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
./deployment-scripts/cleanup.sh
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

## **DevOps Assignment - Answers**
### 1. How to build the Docker container?
   - Create Dockerfile with all the needs to create the image according to your target
   - Use the command 'docker build -t <YourTag-of-the-Image> .'
   - Use the command 'docker run -p 8080:8080 <YourTag-You-Picked>
   - If you want to upload it to a dockerhub to save the image use the commands: 
(docker tag devops-assignment your-dockerhub-username/devops-assignment:<version>
docker push your-dockerhub-username/devops-assignment:<version>)
Then you will be able to withdraw the image from every environment - (Don't Forget to Create access Key for the deligation)

### 2. How to deploy the application and MongoDB using the Helm chart?
   - helm install devops-app ./<Name Of the Chart Values directory or use a exist template using the command: helm create devops-assignment-chart
   - Then Create in the templates your Files and enter the values for the values.yaml file and the structure of the deployment.yaml in templates (like: PV,C, Services, Deployment, stateful and more! :)>
   - Then you can see the resources of the kubernetes using commands like:
      kubectl get pods
      kubectl get services
### 3. How to customize the deployment parameters?
   - You can override using command like:helm upgrade devops-app ./devops-assignment-chart --set app.image=your-dockerhub-username/devops-assignment:v2 0r helm install name-of-the-image ./<chart folder> --set app.replicas=3 (just add app.<replicas, image, service type and more!>)
### 4. How the rolling update and service connectivity is achieved?
   - Every time we are creating new image or any new update in the code, We are pushing it in other version name like (v1, v2, v3, latest)
   - If you need to rollout and use the previous image you can use the command kubectl rollout undo <deployment/YourImage>
   - And There is a connectivity MongoDB accessible via address (mongodb://mongodb:27017/devopsdb) 
   - You can see the variable configuration in the mongodb service file named (MONGO_URI = <URL-of-DB>) 
   - We used Mongoose to easy way to establish a connection

     
🚀 **Just copy, paste, and deploy!** 🚀

