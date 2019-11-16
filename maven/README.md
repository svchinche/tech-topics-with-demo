Maven lifecycle means , it defines a process for building and distributing a particular artifact (project).

Is that Process defined in ANT ? -- No

Default lifecycle -- clean , build , site 


Dependency vs Plugins

Dependency - It will download the required dependency from maven repo and will add it into class path. Which will be used while building (packaging) the project

Plugins - max work in maven is done through plugins and it is nothing but a small piece of code which will be added to enhance the capability of a product.




life-cycles (build, clean, and site) and the phases in each.



Bold one are the main phases



Plugin and goals in deep dive

Here, we used jacoco plugin and its goal ie. prepare-agent


Running goals with examples
===========================
* Excecuting maven goals with phases
```
mvn -Drevision=1.2 clean:clean package dockerfile:build dockerfile:push
mvn -Drevision=1.2 dockerfile:tag@tag-version dockerfile:push@tag-version
mvn -Drevision=1.2 clean:clean install
```
* Execute goals on particular modules 
```
