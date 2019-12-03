Learning Java
================

Table of contents
=================

<!--ts-->
   * [Collections Framework](#collections-framework)
   * [Serialization](#serialization)

<!--te-->

Collections Framework
===================

**Java Collections Framework -heirarchy-- relationship between various api **

Iterator
--------
root interface , used to iterate to forward direction.
hasnext()
next()
remove()
through iterable method we get the reference of hasnext & next


List
----
* Stores elements in indexed approach
* can add duplicate elements (supports redudancy)

* ArryList 
    * ArrayList is implemented as a resizable array.
    * As more elements are added to ArrayList, its size is increased dynamically.
    * It's elements can be accessed directly by using the get and set methods, since ArrayList is essentially an array.

* Linkedlist
    * LinkedList is implemented as a double linked list. 
    * Its performance on add and remove is better than Arraylist, but worse on get and set methods. 
    * Single vs double linked list 
         * Single - Used for stack
         * Double Linked List -  implement stacks as well as heaps and binary trees.

* Vector
    * similar to Arraylist , but vector is synchronized.

* Queue
    * Will sort the data
    * front will point to last element 
    * rear will be point to first element which get added
    * In Priority queue- data will get sorted. and front will point least number
    * peeking - obtaining head of queue 
    * polling - removing head of queue


* Set
    * data is unique, data is unordered due to hashing
    * data is being added is not indexed
    * basically we get the hashcode of which we added

**Performance of tree set slower since it takes time for sorting the data.**
