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
