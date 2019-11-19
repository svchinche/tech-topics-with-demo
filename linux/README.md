# Linux

Table of contents
=================

<!--ts-->
   * [Double vs Sigle square bracket for if condition](#double-vs-single-square-bracket-for-if-condition)
   * [xargs](#xargs)
   * [sort](#sort)
   * [tr](#tr)

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
