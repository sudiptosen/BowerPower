BowerPower
=========

First of all thanks to "**whyleee**" for making bower.js available in Nuget. 

This project is just a small extension to main project **[bower]** on the Nuget Gallery

The goal of this project is the give a quick start to the bower based development in Visual Studio and integrate it in the existing Package Manager console.

  - It is very minimalistic
  - It extends Visual Studio's Package Manager Console's commands
  - It's a work in progress for now :)

Install
--
When you do 

```
Install-Package bowerpower
```
it automatically installs required dependencies


Please Note
---
For installing the package you have to run Visual Studio as **administrator**

----
                                                            
Two commands
---

```
PS> bowerinit
```

This tries to create a "Scripts" folder and then puts the .bowerrc and bower.json files in place.

You update the bower.json as stated in the [bower] documentation


```
PS> bowerinstall
```
This gets the specified modules in the "Scripts\vendor"


[node.js]:http://nodejs.org
[npm]:https://npmjs.org/
[bower]:http://www.nuget.org/packages/Bower/