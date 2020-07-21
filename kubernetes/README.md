Docker and Kubernetes 
==========


Table of contents
=================

<!--ts-->
   * [Container](#containers)
       * [changeroot](#changeroot)
       * [cgroups](#cgroups)
       * [namespaces](#namespaces)
       * [Virtual Machines vs Containers](#virtual-machines-vs-containers)
   * [Docker Architecture](#docker-architecture)
       * [Docker Network](#docker-network)
   * [Kubernetes Architecture](#kubernetes-architecture)
   * [Networking services](#networking-services)
   * [kubernetes Resources](#kubernetes-resources)
   * [ReplicationController vs ReplicaSet Vs Deployment](#replicationcontroller-vs-replicaSet-vs-deployment)
   * [Damonset vs Statefulset vs Deployment](#daemonset-vs-statefulset-vs-deployment)
   * [CoreDNS](#cordens)
   * [Preparing K8S Cluster](#Preparing-k8s-cluster)
   * [Ingress](#ingress)
   * [RBAC](#rbac)
   * [Issues](#issues)
<!--te-->

Containers
=========
Customized isolated process running inside our os. as they shares a same kernel, os does not treat them differently.
containers use kernel feature to create isolated runtime env. This docker feature is almost available on all linux kernels which allows docker to create isolated process

Kernel does not provision isolated runtime environemt to docker.
First idea of process isolation comes with a chroot system call (1979)

changeroot
---------- 
is an operation that changes the apparent root directory of process and its children.
using chroot we can change root directory of new bash process that we lanched.
chroot is not enough to total process isolation as it just modifies the path name lookup for the processes and its children processes. but it was first demonstarttion of process isolation

Today containers are basically chroot on steroids
in 2008 we had LXC -- linux containers, docker is built on LXC but shifted recently with lib container.

docker and LXC built based on two Linux features.
- namespaces
- cgroups - Control groups to access the resources

cgroups
-------
- heirarchial group structure
- individual node represent the process
- seperate heirarchy structure for individual resource controllers (redhat say subsystem to this)

Let see the cgroup heirarchy using
```linux
[root@mum00ban ~]# systemd-cgls cpu
cpu:
├─    1 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
├─ 2472 /usr/lib/systemd/systemd-journald
├─ 2525 /usr/sbin/lvmetad -f
├─ 2536 /sbin/multipathd
├─ 2546 /usr/lib/systemd/systemd-udevd
├─ 3511 /bin/sh ./startNodeManager.sh
├─ 3513 /bin/sh /scratch/app/product/fmw/wlserver/server/bin/startNodeManager.sh
├─ 3560 /u01/app/product/jdk/bin/java -server -Xms32m -Xmx200m -Djdk.tls.ephemeralDHKeySize=2048 -Dcoherence.home=/u01/app/product/fmw/w
├─ 4510 /sbin/auditd -n
├─ 4542 /sbin/audispd
├─ 4544 /usr/sbin/sedispatch
├─ 4548 /usr/sbin/alsactl -s -n 19 -c -E ALSA_CONFIG_PATH=/etc/alsa/alsactl.conf --initfile=/lib/alsa/init/00main rdaemon
├─ 4549 /usr/sbin/ModemManager
├─ 4550 /usr/bin/lsmd -d
├─ 4553 /usr/sbin/rsyslogd -n
├─ 4555 /usr/lib/systemd/systemd-logind
```

Here, we can see docker has created two subgroups for two container, so all of this process under this containers will belong to same container cgroups/system unit. </br>
hence, we its easy to control resource limit by putting resouce restriction to container subgroup rather controlling at process level.</br>
similarly we can give cgroup subsystem for memory </br>

Cgroups vs namespaces</br>
cgroups:: limit what processes use </br>
namespace: limit of what processes see </br>

namespaces
---------
Namespace is used by process to see and identify system resources, so by manipulating namespaces you can restrict the what process see and can not see on ur system.
This is key feature for isolation

Linux Namespaces
- ipc
- mount mnt
- network net
- pid
- user uid
- UTS

```
[root@mum00aqm ~]# ls -l /proc/11298/ns
total 0
lrwxrwxrwx 1 root root 0 Nov 23 13:34 cgroup -> cgroup:[4026531835]
lrwxrwxrwx 1 root root 0 Nov 23 13:34 ipc -> ipc:[4026531839]
lrwxrwxrwx 1 root root 0 Nov 23 13:34 mnt -> mnt:[4026531840]
lrwxrwxrwx 1 root root 0 Nov 23 13:34 net -> net:[4026532185]
lrwxrwxrwx 1 root root 0 Nov 23 13:34 pid -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Nov 23 13:34 pid_for_children -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Nov 23 13:34 user -> user:[4026531837]
lrwxrwxrwx 1 root root 0 Nov 23 13:34 uts -> uts:[4026531838]
```
Note that namespace will get distroyed last process from that namespace exits.
Namespace enable us to grab a global system resouce such that process within that namespace.
It appears that it has their own isolated instance of same resource

Container runtime 

based on cgroudps and namespaces
- docker 
- lxc
- systemd-nspawn

Based on other mechanizm
- openvz
- jails

Virtual Machines vs Containers
----------------------------
VM - we install multiple OS on top of hypervisor, all these operating system will have separate kernel to process the request.
---
Containers - 
----------
Now the kernel runs containerization daemon like docker. this daemon is resposible for creating isolated runtime env.
each containers will have its own set of libraries and dependencies and each containers can have seperate apps in isolation with each other.
The abstraction of hardware is manged by kernel iteslef, daemon is responsible for crating/deleting the continers using kernel feature


Docker Architecture
===================
* Docker Engine -- Server, Rest API, CLI
* Docker Client --  when any docker command runs, the client sends them to dockerd daemon
* Docker registries
* Docker Objects -- images, containers, volumes, network

Docker Network
---------------
* Bridge </br>
  Create a private newtwork internal to the host so containers on this network can communicate.   </br>
  Behind the scenes, the Docker Engine creates the necessary Linux bridges, internal interfaces, iptables rules, and host routes to make this connectivity possible

* Host </br>
  This driver removes the network isolation between docker containers and docker host.
  
* Overlay </br>
  This network enables swarm services to communicate with each other
  
* macvlan </br>
  This driver assigns mac address to containers to make them look like physical devices. </br>
  The traffic is routed between containers through their mac addresses. </br>
  This network is used when you want the containers to look like a physical device, for example, while migrating a VM setup. </br>
  
* none </br>
  This driver disables all the networking.
  
  
Kubernetes Architecture
======================

<p align="center"><img width="800" height="500" src=".images/kubertes.png"></p>


Master Components
-----------------

* etcd cluster  </br>
  a simple, distributed key value storage which is used to store the Kubernetes cluster data (such as number of pods, their state, namespace, etc), API objects and service discovery details. </br> 
  It is only accessible from the API server for security reasons. etcd enables notifications to the cluster about configuration changes with the help of watchers. </br> Notifications are API requests on each etcd cluster node to trigger the update of information in the node’s storage.

* kube-apiserver </br>
  Kubernetes API server is the central management entity that receives all REST requests for modifications (to pods, services, replication sets/controllers and others), serving as frontend to the cluster. Also, this is the only component that communicates with the etcd cluster, making sure data is stored in etcd and is in agreement with the service details of the deployed pods.

* kube-controller-manager </br>
  runs a number of distinct controller processes in the background (for example, replication controller controls number of replicas in a pod, endpoints controller populates endpoint objects like services and pods, and others) to regulate the shared state of the cluster and perform routine tasks. When a change in a service configuration occurs (for example, replacing the image from which the pods are running, or changing parameters in the configuration yaml file), the controller spots the change and starts working towards the new desired state.
  
* cloud-controller-manager </br>
  is responsible for managing controller processes with dependencies on the underlying cloud provider (if applicable). For example, when a controller needs to check if a node was terminated or set up routes, load balancers or volumes in the cloud infrastructure, all that is handled by the cloud-controller-manager.

* kube-scheduler </br>
  helps schedule the pods (a co-located group of containers inside which our application processes are running) on the various nodes based on resource utilization. It reads the service’s operational requirements and schedules it on the best fit node. For example, if the application needs 1GB of memory and 2 CPU cores, then the pods for that application will be scheduled on a node with at least those resources. The scheduler runs each time there is a need to schedule pods. The scheduler must know the total resources available as well as resources allocated to existing workloads on each node.

Node (worker) components
-------------------------

* kubelet </br>
  the main service on a node, regularly taking in new or modified pod specifications (primarily through the kube-apiserver) and ensuring that pods and their containers are healthy and running in the desired state. This component also reports to the master on the health of the host where it is running.

* kube-proxy </br>
  a proxy service that runs on each worker node to deal with individual host subnetting and expose services to the external world. It performs request forwarding to the correct pods/containers across the various isolated networks in a cluster.

* kubectl </br>
  kubectl command is a line tool that interacts with kube-apiserver and send commands to the master node. Each command is converted into an API call.



ETCD
====
Distributed reliable key value store, key value stores data in the form of document for each individual data.
each individual, we get a document where we can add and delete key which will not affect others pages.
we can transact this data with json and yaml

Quorum (Majority)
on HA env having 1 oor 2 insatnce doesn't really make any sense,  since if one of instance get down our cluster will get fail.
as one of instance get down it will live you without quorum and cluster will be non functional.
thats why having odd no of nodes are preferrred over the even
It gives you a better chance of keeping network alive in case of odd no of nodes


Networking services
===================

to accesss the pods outside/inside k8s cluster we use services and it is based on label selector

Services are:

* Cluster IP (inside k8s cluster)

Cluster IP is the default approach when creating a Kubernetes Service. The service is allocated an internal IP that other components can use to access the pods.

* Target Ports (inside k8s cluster)

Use to create port for internal cluster.
```
master $ kubectl get svc
NAME                               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
webapp1-clusterip-targetport-svc   ClusterIP   10.100.73.107   <none>        8080/TCP   4m30s  
```

* NodePort (outside k8s cluster)

 NodePort exposes the service on each Node’s IP via the defined static port. 
 No matter which Node within the cluster is accessed, the service will be reachable based on the port number defined.
 
--service-node-port-range flag (default: 30000-32767)

```
  type: NodePort
  ports:
  - port: 80
    nodePort: 30080
```

* External IPs (outside k8s cluster)
Another approach to making a service available outside of the cluster is via External IP addresses.
```
 ports:
  - port: 80
  externalIPs:
  - 172.17.0.47
  selector:
    app: webapp1-externalip
```

* Load Balancer (outside k8s cluster)
it's possible to dynamically allocate IP addresses to LoadBalancer type services. This is done by deploying the Cloud Provider using kubectl apply -f cloudprovider.yaml. 
When running in a service provided by a Cloud Provider this is not required.

When a service requests a Load Balancer, the provider will allocate one from the 10.10.0.0/26 range defined in the configuration.

```
spec:
  type: LoadBalancer
  ports:
  - port: 80
```

Kubernetes Resources
=========

| NAME                             | SHORTNAMES   | KIND                            | VERBS                                                      |
|----------------------------------|--------------|---------------------------------|------------------------------------------------------------|
| bindings                         |              | Binding                         | create                                                     |
| componentstatuses                | cs           | ComponentStatus                 | get list                                                   |
| configmaps                       | cm           | ConfigMap                       | create delete deletecollection get list patch update watch |
| endpoints                        | ep           | Endpoints                       | create delete deletecollection get list patch update watch |
| events                           | ev           | Event                           | create delete deletecollection get list patch update watch |
| limitranges                      | limits       | LimitRange                      | create delete deletecollection get list patch update watch |
| namespaces                       | ns           | Namespace                       | create delete get list patch update watch                  |
| nodes                            | no           | Node                            | create delete deletecollection get list patch update watch |
| persistentvolumeclaims           | pvc          | PersistentVolumeClaim           | create delete deletecollection get list patch update watch |
| persistentvolumes                | pv           | PersistentVolume                | create delete deletecollection get list patch update watch |
| pods                             | po           | Pod                             | create delete deletecollection get list patch update watch |
| podtemplates                     |              | PodTemplate                     | create delete deletecollection get list patch update watch |
| replicationcontrollers           | rc           | ReplicationController           | create delete deletecollection get list patch update watch |
| resourcequotas                   | quota        | ResourceQuota                   | create delete deletecollection get list patch update watch |
| secrets                          |              | Secret                          | create delete deletecollection get list patch update watch |
| serviceaccounts                  | sa           | ServiceAccount                  | create delete deletecollection get list patch update watch |
| services                         | svc          | Service                         | create delete get list patch update watch                  |
| mutatingwebhookconfigurations    |              | MutatingWebhookConfiguration    | create delete deletecollection get list patch update watch |
| validatingwebhookconfigurations  |              | ValidatingWebhookConfiguration  | create delete deletecollection get list patch update watch |
| customresourcedefinitions        | crd,crds     | CustomResourceDefinition        | create delete deletecollection get list patch update watch |
| apiservices                      |              | APIService                      | create delete deletecollection get list patch update watch |
| controllerrevisions              |              | ControllerRevision              | create delete deletecollection get list patch update watch |
| daemonsets                       | ds           | DaemonSet                       | create delete deletecollection get list patch update watch |
| deployments                      | deploy       | Deployment                      | create delete deletecollection get list patch update watch |
| replicasets                      | rs           | ReplicaSet                      | create delete deletecollection get list patch update watch |
| statefulsets                     | sts          | StatefulSet                     | create delete deletecollection get list patch update watch |
| tokenreviews                     |              | TokenReview                     | create                                                     |
| localsubjectaccessreviews        |              | LocalSubjectAccessReview        | create                                                     |
| selfsubjectaccessreviews         |              | SelfSubjectAccessReview         | create                                                     |
| selfsubjectrulesreviews          |              | SelfSubjectRulesReview          | create                                                     |
| subjectaccessreviews             |              | SubjectAccessReview             | create                                                     |
| horizontalpodautoscalers         | hpa          | HorizontalPodAutoscaler         | create delete deletecollection get list patch update watch |
| cronjobs                         | cj           | CronJob                         | create delete deletecollection get list patch update watch |
| jobs                             |              | Job                             | create delete deletecollection get list patch update watch |
| certificatesigningrequests       | csr          | CertificateSigningRequest       | create delete deletecollection get list patch update watch |
| leases                           |              | Lease                           | create delete deletecollection get list patch update watch |
| events                           | ev           | Event                           | create delete deletecollection get list patch update watch |
| daemonsets                       | ds           | DaemonSet                       | create delete deletecollection get list patch update watch |
| deployments                      | deploy       | Deployment                      | create delete deletecollection get list patch update watch |
| ingresses                        | ing          | Ingress                         | create delete deletecollection get list patch update watch |
| networkpolicies                  | netpol       | NetworkPolicy                   | create delete deletecollection get list patch update watch |
| podsecuritypolicies              | psp          | PodSecurityPolicy               | create delete deletecollection get list patch update watch |
| replicasets                      | rs           | ReplicaSet                      | create delete deletecollection get list patch update watch |
| networkpolicies                  | netpol       | NetworkPolicy                   | create delete deletecollection get list patch update watch |
| poddisruptionbudgets             | pdb          | PodDisruptionBudget             | create delete deletecollection get list patch update watch |
| podsecuritypolicies              | psp          | PodSecurityPolicy               | create delete deletecollection get list patch update watch |
| clusterrolebindings              |              | ClusterRoleBinding              | create delete deletecollection get list patch update watch |
| clusterroles                     |              | ClusterRole                     | create delete deletecollection get list patch update watch |
| rolebindings                     |              | RoleBinding                     | create delete deletecollection get list patch update watch |
| roles                            |              | Role                            | create delete deletecollection get list patch update watch |
| priorityclasses                  | pc           | PriorityClass                   | create delete deletecollection get list patch update watch |
| storageclasses                   | sc           | StorageClass                    | create delete deletecollection get list patch update watch |
| volumeattachments                |              | VolumeAttachment                | create delete deletecollection get list patch update watch |



ReplicationController vs ReplicaSet Vs Deployment
==================================================
 All these are the replication types of replication.
 Pod is a basic execution unit of k8s application. smallest and simplest unit in k8s object model. 
 It is like docker host where we can create multiple container. in pod we can create one or more container in single pod. 
 Each pod is meant to run single instance. You should use multiple pods one for each instance. it is generally know as replication.

 ReplicationController
 ---------------------
 Its original form of replication in k8s. It is easy to create multiple pods using ReplicationController and it ensures all pod always exist.</br>
 If pod crashes, then it get replaced by new pod.It also provide you the ability to scale-up and scale-down replica. </br>

 
 ReplicaSet  
 -----------
 Replication controller is being replica set. </br>
 ReplicaSet has more options for selector ie matchLables and matchExpressions. </br>
 RoplicaSet does not support rollingUpdate while ReplicationController does. This is becuase replica set is meant to be used as backend for deployment.
 
 Deployment
 ----------
 Deployments are intended to replace replicationController. It provide the feature of replicaSet and ReplicaController. That makes it more powerful.</br>
 
 
Daemonset vs Statefulset vs Deployment
======================================

We can deploy Pods using 
    * Deployment
    * Statefulset
    * Daemonset

Deployment
----------

Statefulset
----------

Mostly all applications all statless, we can make them stateful using managing its state using session and replica.
In deployment for database it is not possible since all pods of database will get same volum when we scale it. to solve this problem we use stateful set to assign unique identity,network and storage


**What is Headless service?**
We assign cluster ip to none. then each pod will get uniq network identity,stable storage
Note: Ordering of pod is important

**Creating Staefull set**
- We need to specify which headless service we are going to use
- Default order policy is Ordered -- in sequential order , you can specify parallel as well
- PersistentVolumeClaimTemplate can only be used with stateful set.


**How to debug replica set?** 
- First describe the pod and then check the logs of pod 
- kubectl logs --follow -n mongo mongodb-0  mongodb
  where, mongodb-0 is pods stateful set created using mongodb pod 



Daemonset
---------
**ReplicaSet** - Ensure that specified no of replica of pods are running at any point of time, this is based on the configuration that we specify in a spec file. Once we send the request for deployment/replica set to API server , its job of scheduler to schedule pods inside the k8s cluster.
Now what if , we want to deploy a monitoring app on every node inside a cluster, how can we solve this problem.

**Solution is using DaemonSet;**
DaemonSet: It ensures that all/some nodes inside k8s cluster should run copy of pod.
Example: Deploying one monitoring app instance tool per node inside k8s cluster
Daemonset is the right controller to do this job.  once we submit doemonset manifest file to the apiserver.
As node are added/removed in cluster, pods will be added/removed(garbage collected).

**Use cases::**
*Node monitoring Daemons* 
- collectd
- fluentd
- ceph



CoreDNS
=======
- Updating existing core-dns file

* Create manifest file using existing configmap
``` kubectl get -n kube-system cm/coredns --export -o yaml > coredns-kube-system.yml  ```

* Add below content on above this line:: kubernetes cluster.local in-addr.arpa ip6.arpa { </br>
```shell
        rewrite name cfg.ccoms.com cfg.ccoms.svc.cluster.local
        rewrite name dept.ccoms.com dept.ccoms.svc.cluster.local
        rewrite name org.ccoms.com org.ccoms.svc.cluster.local
        rewrite name emp.ccoms.com emp.ccoms.svc.cluster.local
        rewrite name proxy.ccoms.com proxy.ccoms.svc.cluster.local
        rewrite name db.mongo.com db.mongo.svc.cluster.local
```

* Forcing CoreDNS to reload the ConfigMap
``` kubectl delete pod --namespace kube-system -l k8s-app=kube-dns ```
The kubectl delete pod command isn't destructive and doesn't cause down time. The kube-dns pods are deleted, and the Kubernetes Scheduler then recreates them. These new pods contain the change in TTL value.
 
* Replace existing coredns configmap through newly created manifest file

``` 
kubectl replace -n kube-system -f coredns-kube-system.yml 
```

Note:: Here, we are using replace since we dont know how this ConfigMap is created. if you try to use apply it wont work.

- Adding Custom core-dns file

Preparing K8S Cluster
=====================

Install k8s
------------

```
## Add yum repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

## install package
yum install -y kubelet kubeadm kubectl docker

## disable ip6 tables
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system


## Disable SE Linux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

## Disable swap
sed -i '/swap/d' /etc/fstab
swapoff -a

## Start services
systemctl enable kubelet
systemctl start kubelet
systemctl enable docker
systemctl start docker

## Always use cidr to work flannel plugin properly
kubeadm init --pod-network-cidr=10.244.0.0/16
```


Installing helm3
---------------

```
yum install -y epel-release 
yum install -y snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap
snap install helm3

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

```
Adding new node in existing cluster
----------------------------------
Run below command on master node
```
kubeadm token create --print-join-command
W0708 09:01:17.460384   24912 configset.go:202] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
kubeadm join 10.135.35.77:6443 --token j9zo99.ajyt3v76l06a2mvc     --discovery-token-ca-cert-hash sha256:7daa5ae3e86cca5c8706879eba7940a00abeb547975d33417f2ab5141cf4a4c3
```

Ingress 
========

Plain kubernetes does not contains ingress controller. Ingress resource will only work, if k8s cluster has ingress controller installed.
Following are the ingress controller.
- F5
- nginx
- ha-proxy
- istio
- traefic
- skipper
- kong
- glue
- citrix
- contour
- AKS

NGINX Deployment
----------------
we can configure controller nginx-controller using helm

```
[root@master-node ingress_testing]# cat ~/ingress-values-np.yaml
controller:
  service:
    type: NodePort

helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress -f ~/ingress-values-np.yaml
```



issue - Did not work for me, thats why i tried ha-proxy controller, it worked

HA Proxy Deployment
-----------------

```shell
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm repo update
helm search repo haproxy
helm install mycontroller haproxytech/kubernetes-ingress
```

For testing purpose deploy ingress based application and try to access that app via ingress service

```yaml  ingress-test.yaml
kind: Pod
apiVersion: v1
metadata:
  name: employee-app
  labels:
    app: employee
spec:
  containers:
    - name: employee-app
      image: hashicorp/http-echo
      args:
        - "-text=employee"
---
kind: Pod
apiVersion: v1
metadata:
  name: department-app
  labels:
    app: department
spec:
  containers:
    - name: department-app
      image: hashicorp/http-echo
      args:
        - "-text=department"
---
kind: Service
apiVersion: v1
metadata:
  name: employee-service
spec:
  selector:
    app: employee
  ports:
    - port: 5678 # Default port for image
---
kind: Service
apiVersion: v1
metadata:
  name: department-service
spec:
  selector:
    app: department
  ports:
    - port: 5678 # Default port for image
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
        - path: /employee
          backend:
            serviceName: employee-service
            servicePort: 5678
        - path: /department
          backend:
            serviceName: department-service
            servicePort: 5678

```

RBAC
====

# Create namespace
export CA_LOCATION=/etc/kubernetes/pki/ </br>
cd $CA_LOCATION </br>
kubectl create namespace ccoms </br>

# Create the user credentials

- Create a private key for your user.
openssl genrsa -out employee.key 2048 </br>
```
[root@master-node pki]# openssl genrsa -out employee.key 2048

Generating RSA private key, 2048 bit long modulus
...........+++
.............................................+++
e is 65537 (0x10001)
[root@master-node pki]# cat employee.key
-----BEGIN RSA PRIVATE KEY-----
H/VpNpl+h9pZ7ZSPi6HUxlEWpJqpUZJBz5xFxxj6C15pIcgoch6qZltMSDtAuLOz
LQaEFPTdBiXH2rInXkhvJMhiSv6YmG+482yOny9FYPGH9vtXoHwglh7CWjE7KW3k
gDKSi2XmeGsL6Nj/4hSHuj0RRnmdFtQgAweDtaXuHFIUu7C1AQHisnjncQ/c9TRf
pjwQ6d4F7JxeOxDlE3bkP7ODWm1+hxcTs4Dp1QIDAQABAoIBABlp36+KSrhJX32K
-----END RSA PRIVATE KEY-----
```

- Create a certificate sign request employee.csr using the private key you just created (employee.key in this example). 

Make sure you specify your username and group in the -subj section (CN is for the username and O for the group). As previously mentioned, we will use employee as the name and bitnami as the group: </br>
openssl req -new -key employee.key -out employee.csr -subj "/CN=employee/O=ccoms" </br>

```
[root@master-node pki]# openssl req -new -key employee.key -out employee.csr -subj "/CN=employee/O=ccoms"
[root@master-node pki]# cat employee.csr
-----BEGIN CERTIFICATE REQUEST-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxW5fNVkLH845vvzG2WV4
Qc08xQxqYLI7lCgwoL3seBzRvsAb/bGc+qqGqIZo1Lg09B83oFbzDANVxouMYn8v
oOZ6zsOSvLkCfXGtQ+PzrvhN6KHKH/VpNpl+h9pZ7ZSPi6HUxlEWpJqpUZJBz5xF
xxj6C15pIcgoch6qZltMSDtAuLOzLQaEFPTdBiXH2rInXkhvJMhiSv6YmG+482yO
-----END CERTIFICATE REQUEST-----
```

- Generate the final certificate employee.crt by approving the certificate sign request, employee.csr

openssl x509 -req -in employee.csr -CA $CA_LOCATION/ca.crt -CAkey $CA_LOCATION/ca.key \ </br>
-CAcreateserial -out employee.crt -days 1095 </br>
```
[root@master-node pki]# openssl x509 -req -in employee.csr -CA $CA_LOCATION/ca.crt -CAkey $CA_LOCATION/ca.key \
> -CAcreateserial -out employee.crt -days 1095
Signature ok
subject=/CN=employee/O=ccoms
Getting CA Private Key
```

- Add a new context with the new credentials for your Kubernetes cluster

kubectl config set-credentials employee --client-certificate=$CA_LOCATION/employee.crt \ </br>
--client-key=$CA_LOCATION/employee.key </br>

```
[root@master-node pki]# kubectl config set-credentials employee --client-certificate=$CA_LOCATION/employee.crt \
> --client-key=$CA_LOCATION/employee.key
User "employee" set.


kubectl config set-context employee-context --cluster=kubernetes --namespace=ccoms --user=employee
[root@master-node pki]# kubectl config set-context employee-context --cluster=kubernetes --namespace=ccoms --user=employee
Context "employee-context" created.
```

- You will see the error, since this user dont have any permissions
kubectl --context=employee-context get pods
```
[root@master-node pki]# kubectl --context=employee-context get pods
Error from server (Forbidden): pods is forbidden: User "employee" cannot list resource "pods" in API group "" in the namespace "ccoms"
```

# Create the role for managing deployments
- Create role
```
cat > ~/employee_role.yaml << EOD
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: ccoms
  name: emp-manager
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # You can also use ["*"]
EOD
  
kubectl create -f ~/employee_role.yaml
```
- Bind this role with employee user

```
cat > ~/employee_rolebinding.yaml << EOD
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: emp-manager-binding
  namespace: ccoms
subjects:
- kind: User
  name: employee
  apiGroup: ""
roleRef:
  kind: Role
  name: emp-manager
  apiGroup: ""
EOD

kubectl create -f ~/employee_rolebinding.yaml
```

- Test RBAC rule
kubectl --context=employee-context run --image ccoms/employee </br>
kubectl --context=employee-context get pods </br>

Below command will be failed since user dont have permission on other namespace
```linux
[root@master-node pki]# kubectl --context=employee-context get pods --namespace=default
Error from server (Forbidden): pods is forbidden: User "employee" cannot list resource "pods" in API group "" in the namespace "default"
```

Issues
======

Bigger context error when using integer variable in environment section
------------------------------------------------------------------------
```linux
[root@mum00aqm k8s-ccoms-saas-deployment]# kubectl apply -f ccoms-empms.yaml
Error from server (BadRequest): error when creating "ccoms-empms.yaml": Deployment in version "v1" cannot be handled as a Deployment: v1.Deployment.Spec: 
v1.DeploymentSpec.Template: v1.PodTemplateSpec.Spec: v1.PodSpec.Containers: []v1.Container: v1.Container.Env: []v1.EnvVar: v1.EnvVar.Value: ReadString: expects " or n, 
but found 8, error found in #10 byte of ...|,"value":8080}],"ima|..., bigger context ...|value":"admin"},{"name":"CCOMS_EMP_PORT","value":8080}],"image":"compucomm/emp-service",
"imagePullPo|...
```

**Solution::** 
If you are using any integer variable in environment section, keep that value in double quote </br>
use value: "8080" instead value: 8080


Evicted status of pods.
-----------------------
* Check why this node get into evicted state using kubectl describe command
```linux
[root@mum00aqm ~]# kubectl describe -n ccoms pod/proxy-ms-574975694d-t585r
Status:             Failed
Reason:             Evicted
Message:            Pod The node was low on resource: [DiskPressure].
IP:
```
* Remove all pods which are in evicted state
```linux
kubectl get pods -n ccoms | grep Evicted | awk '{print $1}' | xargs kubectl delete -n ccoms pod
```

network failed to set bridge addr ailedCreatePodSandBox "cni0" already has an IP address different from
------------------------------------------------------------------------------------------------------
* Reset cluster and run below commands
```
kubeadm reset -f
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down
ifconfig docker0 down    
ip link delete cni0
brctl delbr cni0 
umount $(df -HT | grep '/var/lib/kubelet/pods' | awk '{print $7}')
rm -rf /var/lib/cni/flannel/* && rm -rf /var/lib/cni/networks/cbr0/* && ip link delete cni0  
rm -rf /var/lib/cni/networks/cni0/*

systemctl enable kubelet
systemctl start kubelet
systemctl enable docker
systemctl start docker

## Always use cidr to work flannel plugin properly
kubeadm init --pod-network-cidr=10.244.0.0/16


kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
