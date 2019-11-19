# Linux

Table of contents
=================

<!--ts-->
   * [Double vs Sigle square bracket for if condition](#double-vs-single-square-bracket-for-if-condition)
   * [cut](#cut)
   * [xargs](#xargs)
   * [sort](#sort)
   * [tr](#tr)
   * [sed](#sed)
   * [awk](#awk)
   * [tricky interview quetions](#tricky-interview-quetions)

<!--te-->



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

awk
===



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

How to find total no of files and directories from current directory ?
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
