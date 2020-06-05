mongo.
=====

1. connect to mongo database using connection string.
```
mongo --host mongo.ccoms --port 27017 -u "admin" -p "admin123" --authenticationDatabase "admin"
```
2. chnage database.
```
rs0:PRIMARY> use admin
switched to db admin
```

3. See the collections
```
rs0:PRIMARY> show collections
department
employee
organization
system.keys
system.users
system.version
```
