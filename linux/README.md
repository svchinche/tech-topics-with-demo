# Linux

Table of contents
=================

<!--ts-->
   * [Unit Files](#unit-files)
   * [Double vs Sigle square bracket for if condition](#double-vs-single-square-bracket-for-if-condition)
   * [cut](#cut)
   * [xargs](#xargs)
   * [sort](#sort)
   * [tr](#tr)
   * [sed](#sed)
   * [awk](#awk)
   * [How ssl works](#how-ssl-works)
   * [tricky interview quetions](#tricky-interview-quetions)
  

<!--te-->

Unit Files
==========

**Use Case:: Script or service should start at the time of machine boot**

We can do this by two ways.
* Using reboot annotation in crontab
* System unit file 

System Unit file
----------------
1. Create a script whch do a certain task, and that task we want it to be in running state after system boot.
```shell
[root@worker-node1 ansible_hosts]# cat  /root/startup_scripts/start_containers.sh 
#!/bin/bash

## Starting sonar cube container , no need to handle this case as since if container is in running mode it wont start 
docker start sonarqube-article

## starting nexus repo service is not required since it is enabled as part runlevels

## Starting elk containers 
cd /root/docker_projects/elk_project/docker-elk ; 
docker-compose up -d

## Starting ansible hosts
cd /root/docker_projects/ansible_hosts/ ; docker-compose start


###starting filebeat services
/etc/init.d/filebeat start
```

2. Create unit file for the resource/service that you want to control using systemctl command

```linux

# /etc/systemd/system/start_container.service
[Unit]
Description=Description for sample script goes here
After=docker.service

[Service]
Type=simple
ExecStart=/root/startup_scripts/start_containers.sh
TimeoutStartSec=0

[Install]
WantedBy=default.target
```
**Note:** File can be viewed directly from systemctl cat command
```
[root@worker-node1 ansible_hosts]# systemctl cat start_container.service
```
3. Reload the system daemon to get the new changes for systemctl command
systemctl daemon-reload

4. Enable the service
```
[root@worker-node1 ansible_hosts]# systemctl enable start_container.service
```

5. Check the logs of service 
```
[root@worker-node1 ansible_hosts]# journalctl -u start_container.service
-- Logs begin at Tue 2019-09-03 09:48:38 IST, end at Tue 2019-09-03 15:29:28 IST. --
Sep 03 09:50:08 worker-node1 systemd[1]: Started Description for sample script goes here.
Sep 03 09:50:15 worker-node1 start_containers.sh[5060]: sonarqube-article
Sep 03 09:50:17 worker-node1 start_containers.sh[5060]: Starting docker-elk_elasticsearch_1 ...
Sep 03 09:50:22 worker-node1 start_containers.sh[5060]: [97B blob data]
Sep 03 09:50:22 worker-node1 start_containers.sh[5060]: Starting docker-elk_logstash_1      ...
Sep 03 09:50:40 worker-node1 start_containers.sh[5060]: [134B blob data]
Sep 03 09:50:40 worker-node1 start_containers.sh[5060]: Starting host2 ...
Sep 03 09:50:40 worker-node1 start_containers.sh[5060]: Starting host3 ...
Sep 03 09:51:03 worker-node1 start_containers.sh[5060]: [155B blob data]
[root@worker-node1 ansible_hosts]#
```

Double vs Single square bracket for if condition
=========================

```linux
[root@mum00aqm test]# [[ $name =~ "suyo" ]] && echo "hi"
hi
[root@mum00aqm test]# [[ $name == "suyo" ]] && echo "hi"
[root@mum00aqm test]# [[ $name == "suyog" ]] && echo "hi"
hi
```
In above command, you can see == is for strict comparsion while ~ for patter matching, one more benefit of using double square bracket is its compact way to write if conditon, we can also use sigle square bracket

Difference between [ and [[ is, [ is command test command and command completion should be marked as  ] </b>
benefit of using [[ is, its not a command but its syntax and all these case are handled like unary operator expected mentioned in below command

both command are same, but whenever there whenever there is else condition is required then we need to use second option 
```
[[ $name = "suyog" ]] && echo "match" 
if [[ $name = "suyog" ]]; then echo "match"; fi
```
```linux
[root@mum00aqm test]# test 4 =5
-bash: test: 4: unary operator expected
```

cut
===
used for removing or replacing sections
```
[root@mum00aqm ~]# echo -e "Hi \n this is suyog, \n and my mob no is 9822622279" | cut -d' ' -f1
Hi

[root@mum00aqm ~]# echo -e "Hi \n this is suyog, \n and my mob no is 9822622279" | cut -d' ' -f1-4 --output-delimiter='%'
Hi%
%this%is%suyog,
%and%my%mob
```
xargs
=====

**Note::** xargs command in unix will not work as expected, if any of file name contains space or new line in it.</br>
to avoid this problem we use find -print0 to produce null separated file name and xargs-0 to handle null separated items

```linux
find /tmp -name "*.tmp" -print0 | xargs -0 rm
```




How to avoid "Argument list too long" error
------------------------------------------
xargs in unix or Linux was initially use to avoid "Argument list too long" errors and by using xargs you send sub-list to any command which is shorter than "ARG_MAX" and that's how xargs avoid "Argument list too long" error. You can see current value of "ARG_MAX" by using getconf ARG_MAX. Normally xargs own limit is much smaller than what modern system can allow, default is 4096. You can override xargs sub list limit by using "-s" command line option.

find –exec vs find + xargs
--------------------------
xargs with find command is much faster than using -exec on find. since -exec runs for each file while xargs operates on sub-list level. to give an example if you need to change permission of 10000 files xargs with find will be almost 10K time faster than find with -exec because xargs change permission of all file at once.


```linux
getconf -a . | grep ARG
ARG_MAX                            2097152
NL_ARGMAX                          4096
_POSIX_ARG_MAX                     2097152
LFS64_CFLAGS                       -D_LARGEFILE64_SOURCE
LFS64_LINTFLAGS                    -D_LARGEFILE64_SOURCE
XBS5_ILP32_OFFBIG_CFLAGS           -m32 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
POSIX_V6_ILP32_OFFBIG_CFLAGS       -m32 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
POSIX_V7_ILP32_OFFBIG_CFLAGS       -m32 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
```

tr
==
We use this command to translate and delete characters </br>
Here, you can see it translate character by character </br>
s flag is for squeese repitating character </br>
```linux
[root@k8s-master ~]# echo "{Hi i am suyog::}" | tr '{}:' '()-'
(Hi i am suyog--)

echo " Hi i am suyog" | tr '[:lower:]' '[:upper:]'
 HI I AM SUYOG

 echo " Hi i am suyog" | sed 's/suyog/sachin chinche/g'
 Hi i am sachin chinche
 
[root@k8s-master ~]# echo " Hi i am suyog" | tr 'suyog' 'sachin chinche'
 Hi i am sachi


echo "Hi i am   suyog     chinche" | tr -s '[:space:]' ' '
Hi i am suyog chinche 
```

sort
=====
```linux
[root@mum00aqm writeable]# cat emp.csv
3,amit,15000,500
2,suhas,12000,340
5,shubham,2111,450
17,Shantanu,45672,345
1,suyog,20000,1000
4,Suraj,21000,1100
12,Sanchit,22000,1150
7,Sachin,27000,1300

[root@mum00aqm writeable]# sed 's/,/ /g' emp.csv | sort -k4n
2 suhas 12000 340
17 Shantanu 45672 345
5 shubham 2111 450
3 amit 15000 500
1 suyog 20000 1000
4 Suraj 21000 1100
12 Sanchit 22000 1150
7 Sachin 27000 1300
```
**NOTE:** by default sort uses space as delimitor, we can specify different field sperator or delimeter using -t option as below

```linux
[root@k8s-workernode shell_learning]# cat emp.csv | sort -t, -k4n
3,amit,15000,500
1,suyog,20000,1000
4,Suraj,21000,1100
12,Sanchit,22000,1150
7,Sachin,27000,1300


[root@k8s-workernode shell_learning]# cat emp.csv | sort --field-separator=, -k4n
3,amit,15000,500
1,suyog,20000,1000
4,Suraj,21000,1100
12,Sanchit,22000,1150
7,Sachin,27000,1300
```
sed
===

Substitute/replace ccoms with bcoms
-----------------------------------
```
[root@mum00aqm ~]# sed 's/ccoms/bcoms/g' ext_ccoms.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: bcoms
  namespace: bcoms
spec:
  ports:
  - port: 8111
    targetPort: 8111
    protocol: TCP
  selector:
    app: proxy-ms
  externalIPs:
  - 10.180.86.187
 ```
 Delete the line which matches the pattern
 -----------------------------------------
```shell
[root@mum00aqm ~]# sed '/ccoms/d' ext_ccoms.yaml
---
apiVersion: v1
kind: Service
metadata:
spec:
  ports:
  - port: 8111
    targetPort: 8111
    protocol: TCP
  selector:
    app: proxy-ms
  externalIPs:
  - 10.180.86.187
```
Special characters with sed works very well
--------------------------------
```shell
[root@mum00aqm ~]# sed 's/- port: 8111/- port: 8888/g' ext_ccoms.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: ccoms
  namespace: ccoms
spec:
  ports:
  - port: 8888
    targetPort: 8111
    protocol: TCP
  selector:
    app: proxy-ms
  externalIPs:
  - 10.180.86.187
```
Special character with single quote
-----------------------------------
```shell
[root@mum00aqm ~]# cat ext_ccoms.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: 'ccoms'
  namespace: ccoms
spec:
  ports:
  - port: 8111
    targetPort: 8111
    protocol: TCP
  selector:
    app: proxy-ms
  externalIPs:
  - 10.180.86.187


[root@mum00aqm ~]# sed 's/name: '\''ccoms'\''/name: '\''bcoms'\''/g' ext_ccoms.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: 'bcoms'
  namespace: ccoms
spec:
  ports:
  - port: 8111
    targetPort: 8111
    protocol: TCP
  selector:
    app: proxy-ms
  externalIPs:
  - 10.180.86.187
```

**Some more deletion examples
**For deleting a specific line
```
sed -i '5d' file.txt
```
**Deleting line no ranges from x to y
```
sed -i '2,5d' file.txt
```
**Delete blank line in file
```
sed -i '^$/d' file.txt
```
**Delete the blank line or starting with 
```
sed-i '^$/d;^#/d' file.txt
```
awk
===

One of the best benefit of using awk that i found is, we can do basic calculation in command itself. See the example below
```
[root@mum00aqm ~]# echo "Do the sum of 4 and 5" | awk '{print $5 + $7}'
9
```

This command is similar to cut command, but awk suppresses leading whitespaces in command standard output, this is why we use awk the most

**Note:** We always keep action in curly bracket and before that we use search criteria
```
awk options 'selection _criteria {action }' file.txt
```

**Some builtin variables that we use frequently**
- NF - Last field in a line
- NR - Keep the count of number of input records, useful when you want to list file with line no
```
[root@mum00aqm ~]# echo "Do the sum of 4 and 5" | awk '{print $5 $NF}'
45
```
How SSL Works
=============

How SSL Works
=============


**What is trusted and self signed certificate**

Self Signed Certificate
-----------------------
openssl req -newkey rsa:2048 -nodes -keyout domain.key-x509 -days 365 -out domain.crt

Trusted Certificate
-----------------
Raise a csr 

openssl req  -new -newkey rsa:2048 -nodes -keyout privatekey.key –out certificatesigningrequest.csr



How to check validity of certificate?
------------------------------------
```
echo | openssl s_client  -connect <hostname>:<port no> -tls1_2  2>/dev/null | grep "public key is" | awk '{print $5}'
```

How to check cipher and protocol information?
------------------------------------------
```
echo | openssl s_client  -connect <hostname>:<port no> -"<protocol>" 2>/dev/null | grep -i supported

echo|  openssl s_client  -connect <hostname>:<port no>  -cipher <cipher> 2>/dev/null | grep -i supported
```

Tricky interview quetions
=========================

Command to search content in file, if matches it should show next 3 lines
--------------------------------------------------------------------------
```shell
[root@mum00aqm ~]# grep -A 3 '8111' ext_ccoms.yaml
  - port: 8111
    targetPort: 8111
    protocol: TCP
  selector:
    app: proxy-ms
```
*-A* : means after search context

How to find count of files and directories from current directory ?
-----------------------------------------------------
```shell
[root@k8s-workernode shell_learning]# find . -type d | expr $(wc -l) - 1
3
[root@k8s-workernode shell_learning]# find . -type f | expr $(wc -l) - 1
6
```

Count the occurences of special character in file ?
---------------------------------------------------
```
[root@mum00aqm ~]# cat test.date
*%$#%%$#%$#$@#$@#
[root@mum00aqm ~]# grep  -o "#" test.date | wc -l
5
```

Move all .txt files with .txt1, if some files already moved then command should ignore that since they are already moved
-----------------------------------------------------------------------------------------------

for eg. in below  xyz txt1 file already moved, command should ignore that
```
[root@mum00aqm test]# ll
total 0
-rw-r--r-- 1 root root 0 Nov 19 17:46 abc.txt
-rw-r--r-- 1 root root 0 Nov 19 17:46 cde.txt
-rw-r--r-- 1 root root 0 Nov 19 17:46 fgh.txt
-rw-r--r-- 1 root root 0 Nov 19 17:46 ghj.txt
-rw-r--r-- 1 root root 0 Nov 19 17:48 xyz.txt1
```

**Solution::**
```
[root@mum00aqm test]# for filename in $( ls *.txt |sed 's/.txt1$//g');do  mv $filename ${filename}1 ; done
[root@mum00aqm test]# ll
total 0
-rw-r--r-- 1 root root 0 Nov 19 17:46 abc.txt1
-rw-r--r-- 1 root root 0 Nov 19 17:46 cde.txt1
-rw-r--r-- 1 root root 0 Nov 19 17:46 fgh.txt1
-rw-r--r-- 1 root root 0 Nov 19 17:46 ghj.txt1
-rw-r--r-- 1 root root 0 Nov 19 17:48 xyz.txt1
```


