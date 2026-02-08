# 🌐 Inception-of-Things (IoT)
> **Advanced Kubernetes Orchestration & GitOps Automation**


<br>
<br>


## 🛠 Tech Stack & Tools
| Category | Tools |
| :--- | :--- |
| **Infrastructure** | Vagrant, VirtualBox, K3s, K3d |
| **Orchestration** | Kubernetes (Master/Worker Architecture) |
| **GitOps & CI/CD** | Argo CD, GitLab (Self-hosted) |
| **Networking** | Traefik Ingress, Load Balancing, Private Networking |
| **Automation** | Bash Scripting, YAML Manifests |

<br>
<br>


The project is a hands-on exploration of Kubernetes using lightweight distributions. It is divided into three parts:
1. **Part 1 (K3s & Vagrant):** Automating a cluster setup (1 Master, 1 Worker) using Vagrant and Bash scripts on Debian.
2. **Part 2 (K3s & Ingress):** Deploying 3 web applications with different routing rules using Traefik Ingress.
3. **Part 3 (K3d & GitOps):** Moving to K3d (Kubernetes in Docker) and implementing Argo CD for automated deployments from a Git repository.
4. **Bonus:** Integrating a self-hosted GitLab instance as the Git source for Argo CD.

## 🏗 System Architecture

### 🔹 Part 1: Automated Cluster Provisioning (The Foundation)
Creation of a multi-node cluster using **Vagrant** on Debian.
- **Node Sync**: Implemented a secure automated handshake using `node-token` sharing through synced folders.
- **Network Isolation**: Dedicated private network (`192.168.56.0/24`) for internal cluster traffic.
- **Optimization**: Forced K3s to use specific network interfaces (`eth1`) to prevent TLS handshake timeouts common in virtualized environments.



### 🔹 Part 2: Traffic Management & Ingress
Deploying containerized applications with sophisticated routing.
- **Dynamic Routing**: Configured **Traefik Ingress** to handle multiple hostnames (`app1.com`, `app2.com`).
- **Scalability**: Demonstrated horizontal scaling with **3 replicas** for `app2.com`.
- **Infrastructure**: Applied Kubernetes Services (ClusterIP) to ensure internal decoupling.



### 🔹 Part 3: GitOps Transformation (The Peak)
Migrating to **K3d** for a "Kubernetes-in-Docker" environment and implementing **Argo CD**.
- **Declarative State**: The cluster state is defined entirely in Git. Argo CD monitors the repository and automatically reconciles the live state.
- **Namespacing**: Logical separation of environments (`argocd` vs `dev`).
- **Automation**: A zero-touch `install.sh` that provisions the entire ecosystem in under 2 minutes.


# 🌟 Part 4: The Bonus - Self-Hosted Software Factory

The Bonus part takes the project to a professional production level by removing the dependency on external providers like GitHub. I implemented a fully autonomous **Private Git Ecosystem** within the cluster.

## 🏗️ Architecture Overview
In this setup, the entire DevOps lifecycle happens inside the cluster:
1.  **Storage**: A self-hosted **GitLab CE** instance.
2.  **Delivery**: **Argo CD** tracking the internal GitLab.
3.  **Routing**: A custom **Traefik Ingress** managing non-standard ports.



## 🛠️ Technical Specifications

### 1. Internal Source of Truth
Instead of public repositories, I deployed GitLab to serve as the private "Source of Truth". 
- **Domain**: `gitlab.lvh.me` (Loopback domain for local DNS simulation).
- **Custom Port**: `:9999` (Used to demonstrate advanced Ingress port-mapping and avoid conflicts with standard web traffic).

### 2. Persistence Layer
To ensure that code and user data are not lost when pods are deleted, I implemented:
- **Persistent Volume Claims (PVC)**: Dedicated storage for GitLab’s config, repositories, and PostgreSQL database.
- **Storage Class**: Utilizing the K3s default local-path provisioner.

### 3. Networking & Ingress logic
The Ingress is configured to handle the specific requirements of a heavy application like GitLab:
- **Host-based routing**: Intercepting requests for `gitlab.lvh.me`.
- **Port Forwarding**: Mapping external traffic from port `9999` to the internal GitLab service.



## 🔄 The GitOps Workflow
1.  **Commit**: A developer pushes a manifest change to `http://gitlab.lvh.me:9999/root/iot-project.git`.
2.  **Detection**: Argo CD, using its internal service connection, polls the local GitLab repository.
3.  **Reconciliation**: Argo CD detects a "diff" between the Git state and the Cluster state.
4.  **Auto-Sync**: The changes are applied instantly to the `dev` namespace.

 **Access GitLab**: Open `http://gitlab.lvh.me:9999` in your browser.

---

## 🧠 Lessons Learned
- **Resource Management**: GitLab is resource-intensive. I learned to monitor and set appropriate CPU/RAM limits for heavy stateful applications in K8s.
- **Internal Service Discovery**: Configuring Argo CD to find GitLab via its internal Kubernetes DNS (`gitlab.gitlab.svc.cluster.local`) rather than its public URL.
- **StatefulSets vs Deployments**: Understanding the importance of stable storage for database-driven applications.
