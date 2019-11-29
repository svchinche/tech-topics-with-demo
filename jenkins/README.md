Devops and Jenkins 
================


Table of contents
=================

<!--ts-->
   * [Devops](#devops)
   * [How to start working in devops](#how-to-start-working-in-devops)
   * [Jenkins](#jenkins)
      * [Declarative vs scripted](#declarative-vs-scripted)
      * [Resuming build from failed stage](#resuming-build-from-failed-stage)
      * [Backup and Restoration](#backup-and-restoration)
   * [Monolithic vs Microservice](#monolithic-vs-microservice )
   * [Working with Docker Private Registry](#working-with-docker-private-registry)
   * [Roles and Responsibilities of Devops Engg](#roles-and-responsibilities-of-devops-engg)
   * [Roles and Responsibilities of Cloud Engg](#roles-and-responsibilities-of-cloud-engg)
   * [Best Practices for Devops](#best-practices-for-devops)
   * [Best practices for Jenkins](#best-practices-for-jenkins)
<!--te-->

Devops
 ==============
Devops is a collection architecture, tools that increases organization ability to deliver applications and services at rapid pace


How to start working in devops
==============================
You should have proper understanding of how below things implemented manually.
- How projects get build ?
- How Central code repository is managed for multiple teams.(git workflow strategies) ?
- How unit testing is helpful to test individual module ?

Jenkins
=======

Declarative vs Scripted
-----------------------

**declarative:** must be enclosed within a pipeline {} block 

**scripted:** always are enclosed within a node {} block

* Use case :

Resuming build from failed stage
--------------------------------


Backup and Restoration
--------------------

Monolithic vs Microservice 
==========================

* Difference between monolithic and microservice based application
    * Monolythic application 
        - All the code resides in one big app and separate database is used to store database. 
        - At the end of the day all one big program does your work
        - Easy when your team and project is small, what if your project grows.

    * Microservice based application 
        - Microservices are Awesomesome
        - Agility
        - Speedy deployment

    * Disadvantages of microservices 
        - Microservice make terribe to analyze the issue 

Working with Docker Private Registry
=======================

* Create a certificate

``` openssl req -newkey rsa:4096 -nodes -sha256 -keyout /etc/certs/ca.key -x509 -days 365 -out /etc/certs/ca.crt ```

* Create docker registry container 

``` docker run -d -p 5000:5000 --restart=always --name registry -v /etc/certs:/etc/certs  -v /root/docker_registry/images:/var/lib/registry -e REGISTRY_HTTP_TLS_CERTIFICATE=/etc/certs/ca.crt -e REGISTRY_HTTP_TLS_KEY=/etc/certs/ca.key registry ```

* Docker logs registry ---> check if any errors
  remove registry container if there are any issue while starting
``` docker stop $(docker ps -aqf "ancestor=registry"); docker rm $(docker ps -aqf "ancestor=registry") ```

* Tag all images which you want to push to docker registry 
```docker tag eureka-server:0.1 k8s-master:5000/eureka-server:0.1 ```
``` docker tag eureka-cnts-svc:0.1 k8s-master:5000/eureka-cnts-svc:0.1 ```
``` docker tag eureka-capitals-svc:0.1  k8s-master:5000/eureka-capitals-svc:0.1 ```

* Push docker images 
```
docker push k8s-master:5000/eureka-server:0.1
docker push k8s-master:5000/eureka-cnts-svc:0.1
docker push k8s-master:5000/eureka-capitals-svc:0.1
```

* Client node: 
Copy certificate and run this command on client node
``` scp -pr root@k8s-master:/etc/certs/ca.crt /etc/docker/certs.d/k8s-master:5000/ ```

How to start working in devops
==============================

Roles and Responsibilites of Devops Engg
=======================================

Roles and Responsibilities of Cloud Engg
========================================

Best Practices for Devops
=======================

Best practices for Jenkins
==========================
