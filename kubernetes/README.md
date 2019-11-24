Docker and Kubernetes 
==========


Table of contents
=================

<!--ts-->
   * [Kubernetes Architecture](#installing-ansible)
   * [ReplocationController vs ReplicaSet Vs Deployment](#replocationController-vs-replicaSet-vs-deployment)
   * [Damonset vs Statefulset vs Deployment](#daemonset-vs-statefulset-vs-deployment)
   * [Docker containers](#inventory)
   * [Resouces](#resources)
   * [CoreDNS](#cordens)
   * [Issues](#issues)
<!--te-->

Resources
=========

```linux
[root@mum00aqm ~]# kubectl api-resources list  -o wide
NAME                              SHORTNAMES    KIND                             VERBS
bindings                                        Binding                          create
componentstatuses                 cs            ComponentStatus                  get list
configmaps                        cm            ConfigMap                        create delete deletecollection get list patch update watch
endpoints                         ep            Endpoints                        create delete deletecollection get list patch update watch
events                            ev            Event                            create delete deletecollection get list patch update watch
limitranges                       limits        LimitRange                       create delete deletecollection get list patch update watch
namespaces                        ns            Namespace                        create delete get list patch update watch
nodes                             no            Node                             create delete deletecollection get list patch update watch
persistentvolumeclaims            pvc           PersistentVolumeClaim            create delete deletecollection get list patch update watch
persistentvolumes                 pv            PersistentVolume                 create delete deletecollection get list patch update watch
pods                              po            Pod                              create delete deletecollection get list patch update watch
podtemplates                                    PodTemplate                      create delete deletecollection get list patch update watch
replicationcontrollers            rc            ReplicationController            create delete deletecollection get list patch update watch
resourcequotas                    quota         ResourceQuota                    create delete deletecollection get list patch update watch
secrets                                         Secret                           create delete deletecollection get list patch update watch
serviceaccounts                   sa            ServiceAccount                   create delete deletecollection get list patch update watch
services                          svc           Service                          create delete get list patch update watch
mutatingwebhookconfigurations                   MutatingWebhookConfiguration     create delete deletecollection get list patch update watch
validatingwebhookconfigurations                 ValidatingWebhookConfiguration   create delete deletecollection get list patch update watch
customresourcedefinitions         crd,crds      CustomResourceDefinition         create delete deletecollection get list patch update watch
apiservices                                     APIService                       create delete deletecollection get list patch update watch
controllerrevisions                             ControllerRevision               create delete deletecollection get list patch update watch
daemonsets                        ds            DaemonSet                        create delete deletecollection get list patch update watch
deployments                       deploy        Deployment                       create delete deletecollection get list patch update watch
replicasets                       rs            ReplicaSet                       create delete deletecollection get list patch update watch
statefulsets                      sts           StatefulSet                      create delete deletecollection get list patch update watch
tokenreviews                                    TokenReview                      create
localsubjectaccessreviews                       LocalSubjectAccessReview         create
selfsubjectaccessreviews                        SelfSubjectAccessReview          create
selfsubjectrulesreviews                         SelfSubjectRulesReview           create
subjectaccessreviews                            SubjectAccessReview              create
horizontalpodautoscalers          hpa           HorizontalPodAutoscaler          create delete deletecollection get list patch update watch
cronjobs                          cj            CronJob                          create delete deletecollection get list patch update watch
jobs                                            Job                              create delete deletecollection get list patch update watch
certificatesigningrequests        csr           CertificateSigningRequest        create delete deletecollection get list patch update watch
leases                                          Lease                            create delete deletecollection get list patch update watch
events                            ev            Event                            create delete deletecollection get list patch update watch
daemonsets                        ds            DaemonSet                        create delete deletecollection get list patch update watch
deployments                       deploy        Deployment                       create delete deletecollection get list patch update watch
ingresses                         ing           Ingress                          create delete deletecollection get list patch update watch
networkpolicies                   netpol        NetworkPolicy                    create delete deletecollection get list patch update watch
podsecuritypolicies               psp           PodSecurityPolicy                create delete deletecollection get list patch update watch
replicasets                       rs            ReplicaSet                       create delete deletecollection get list patch update watch
networkpolicies                   netpol        NetworkPolicy                    create delete deletecollection get list patch update watch
poddisruptionbudgets              pdb           PodDisruptionBudget              create delete deletecollection get list patch update watch
podsecuritypolicies               psp           PodSecurityPolicy                create delete deletecollection get list patch update watch
clusterrolebindings                             ClusterRoleBinding               create delete deletecollection get list patch update watch
clusterroles                                    ClusterRole                      create delete deletecollection get list patch update watch
rolebindings                                    RoleBinding                      create delete deletecollection get list patch update watch
roles                                           Role                             create delete deletecollection get list patch update watch
priorityclasses                   pc            PriorityClass                    create delete deletecollection get list patch update watch
storageclasses                    sc            StorageClass                     create delete deletecollection get list patch update watch
volumeattachments                               VolumeAttachment                 create delete deletecollection get list patch update watch
```

ReplocationController vs ReplicaSet Vs Deployment
==================================================
 All these are the replication types of replication.
 Pod is a basic execution unit of k8s application. smallest and simplest unit in k8s object model. 
 It is like docker host where we can create multiple container. in pod we can create one or more container in single pod. 
 Each pod is meant to run single instance. You should use multiple pods one for each instance. it is generally know as replication.

 ReplocationController
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
 
 

Damonset vs Statefulset vs Deployment
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

Issues
======

* Bigger context error when using integer variable in environment section
```linux
[root@mum00aqm k8s-ccoms-saas-deployment]# kubectl apply -f ccoms-empms.yaml
Error from server (BadRequest): error when creating "ccoms-empms.yaml": Deployment in version "v1" cannot be handled as a Deployment: v1.Deployment.Spec: 
v1.DeploymentSpec.Template: v1.PodTemplateSpec.Spec: v1.PodSpec.Containers: []v1.Container: v1.Container.Env: []v1.EnvVar: v1.EnvVar.Value: ReadString: expects " or n, 
but found 8, error found in #10 byte of ...|,"value":8080}],"ima|..., bigger context ...|value":"admin"},{"name":"CCOMS_EMP_PORT","value":8080}],"image":"compucomm/emp-service",
"imagePullPo|...
```

*Solution::* 
If you are using any integer variable in environment section, keep that value in double quote </br>
use value: "8080" instead value: 8080
