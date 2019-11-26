Learning Java
================


Table of contents
=================

<!--ts-->
   * [Collections Framework](#collections-framework)
   * [Serialization]
   * [SerialVersionId]

<!--te-->

Collections Framework
===================

Java Collections Framework
- heirarchy-- relationship between various api
-

Iterator
--------
root interface , used to iterate to forward direction.
hasnext()
next()
remove()
through iterable method we get the reference of hasnext & next


List
----
- Stores elements in indexed approach
- can add duplicate elements (supports redudancy)

* ArryList 
- Data get added in indexed approach
- We can create dynamic arry is arraylist

* Linkedlist
- Sequence of link
Single -- 
Node - node contains data and the info/reference/pointer of next node
Doubly- Node contains data and the info of prev and next node

* Vector
- similar to Arraylist , but vector is synchronized.

Queue
- Will sort the data
- front will point to last element 
- rear will be point to first element which get added

In Priority queue- data will get sorted. and front will point least number
peeking - obtaining head of queue 
polling - removing head of queue


Set
- data is unique, data is unordered due to hashing
- data is being added is not indexed
- basically we get the hashcode of which we added

performance of tree set slower since it takes time for sorting the data
