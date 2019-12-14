Learning Spring
================


Table of contents
=================

<!--ts-->
   * [Unit Testing](#unit-testing)
 
<!--te-->

Unit testing
=============

Annotation 
* WebMvcTest - Unit testing mvc appln 
* webMvcTest - It will only launch only that particular controller
* MockMvc - main entry for server side spring mvc and used for firing request to webMvcTest
* MockBean is used to mocks to a sping AplicationContext
* Mockito.when - most popular mocking framework
retrive service with matching anystring with anystring then ruturn this mock
* mockcode - instead of using real code we use mock code

UnitTesting String mvc is too much simple.</br>
- Put mvctest to launch that controller
- MockBean - stub all the stub that we need to stub
- setup the mock
- fire the request
- checking what is expected
