Table of contents
=================

<!--ts-->
   * [Maven Lifecycle](#maven-lifecycle)
   * [Dependency vs Plugins](#dependency-vs-plugins)
   * [Junit vs TestNg](#Junit-vs-testng)
   * [Running Goals](#running-goals)
   * [Cucumber](#cucumber)
   * [Run test cases in Parallel](#run-test-cases-in-parallel)
   
  
<!--te-->

Maven Lifecycle
================

Maven lifecycle means , it defines a process for building and distributing a particular artifact (project).

Is that Process defined in ANT ? -- No

Default lifecycle -- clean , build , site 


Dependency vs Plugins
=====================

Dependency - It will download the required dependency from maven repo and will add it into class path. Which will be used while building (packaging) the project

Plugins - max work in maven is done through plugins and it is nothing but a small piece of code which will be added to enhance the capability of a product.


life-cycles (build, clean, and site) and the phases in each.

Bold one are the main phases


Plugin and goals in deep dive

Here, we used jacoco plugin and its goal ie. prepare-agent


Running goals
===========================
* Excecuting maven goals with phases
```
mvn -Drevision=1.2 clean:clean package dockerfile:build dockerfile:push
mvn -Drevision=1.2 dockerfile:tag@tag-version dockerfile:push@tag-version
mvn -Drevision=1.2 clean:clean install
```
* Execute goals on particular modules 
```
 mvn -Drevision=1.0.0 -pl eureka-server,countries-service,capitals-service clean:clean resources:resources compiler:compile  resources:testResources compiler:testCompile surefire:test
```


Cucumber
========

Automation testing framework that is used to write behavior driven development test. 
which use gerkin language

BDD
---
Similar to s/w driven development where we start with test.
whereas BDD start with Behaviour. We can show this to customer since it is understandle to everyonr.
The way behavior are written, that help them to understand the feature.

feature_file
------------


Background
----------
Background in Cucumber is used to define a step or series of steps that are common to all the tests in the feature file. 
It allows you to add some context to the scenarios for a feature where it is defined.
A Background is much like a scenario containing a number of steps. But it runs before each and every scenario were for a feature in which it is defined.



Run test cases in parallel
==========================

To run test cases on all modules parallely use -T flag.
mvn -T 4 surefire:test

**Parallel run works on each phase of maven


Using Parallel Parameter
First, let's enable parallel behavior in Surefire using the parallel parameter. It states the level of granularity at which we would like to apply parallelism.

The possible values are:

methods – runs test methods in separate threads
classes – runs test classes in separate threads
classesAndMethods – runs classes and methods in separate threads
suites – runs suites in parallel
suitesAndClasses – runs suites and classes in separate threads
suitesAndMethods – creates separate threads for classes and for methods
all – runs suites, classes as well as methods in separate threads
In our example, we use all:

```
<configuration>
    <parallel>all</parallel>
</configuration>
```
