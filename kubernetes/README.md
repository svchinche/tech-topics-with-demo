Kubernetes 
==========


Table of contents
=================

<!--ts-->
   * [Kubernetes Architecture](#installing-ansible)
   * [Docker containers](#inventory)
   * [Resouces](#resources)
      * [Shell module](#shell-module)
   * [CoreDNS](#cordens)
   * [Issues](#issues)
<!--te-->

Resources
=========

```
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

CoreDNS
=======
- Updating existing core-dns file

* Create manifest file using existing configmap
``` kubectl get -n kube-system cm/coredns --export -o yaml > coredns-kube-system.yml  ```

* Add below content on above this line:: kubernetes cluster.local in-addr.arpa ip6.arpa { </br>
```
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

``` kubectl replace -n kube-system -f coredns-kube-system.yml ```

Note:: Here, we are using replace since we dont know how this ConfigMap is created. if you try to use apply it wont work.

- Adding Custom core-dns file


Issues
======

* Bigger context error when using integer variable in environment section
```
[root@mum00aqm k8s-ccoms-saas-deployment]# kubectl apply -f ccoms-empms.yaml
Error from server (BadRequest): error when creating "ccoms-empms.yaml": Deployment in version "v1" cannot be handled as a Deployment: v1.Deployment.Spec: 
v1.DeploymentSpec.Template: v1.PodTemplateSpec.Spec: v1.PodSpec.Containers: []v1.Container: v1.Container.Env: []v1.EnvVar: v1.EnvVar.Value: ReadString: expects " or n, 
but found 8, error found in #10 byte of ...|,"value":8080}],"ima|..., bigger context ...|value":"admin"},{"name":"CCOMS_EMP_PORT","value":8080}],"image":"compucomm/emp-service",
"imagePullPo|...
```

Solution :: If you are using any integer variable in environment section, keep that value in double quote </br>
use value: "8080" instead value: 8080
