---
layout: default
title: Working With Themes
navigation_weight: 3

---

We have included a sanitized version of our journal theme repository as reference to our implementation. We wanted show an example of how we set up our theme structure. We also wanted to provide anyone using Ambra as a journal platform with some example code and ideas for features we developed.

#The problem we were trying to solve

PLOS has seven journals as well as at least one supporting site. The journals share a lot of similarities in layout and features, but they have some differences, both major and minor. Our mega journal PLOS ONE has some very different features - for example: homepage and browsing features - than the other 6 journals.  

We also needed to make a distinction between mobile and desktop. Wombat is not a fully responsive site. Long form scientific papers do not render well on a small device. Creating a separate mobile site made more sense for our needs. 

A few use cases to illustrate: We wanted PLOS ONE to have a very different homepage layout than our other journals.  In the old ambra theme structure we would have to create 6 identical templates and a PLOS ONE template. Maintenance, testing and development were the opposite of efficient. 

In new ambra we strove to create a theme structure that would allow inheritance from a parent theme. This way we could have all the sites use the same parent homepage template and only override this template for PLOS ONE. 

We then wanted to be able to do the same thing for desktop and mobile pages. For example it was important for both the desktop and mobile sites to share page templates but have different headers and footers. 

We also wanted the themes to function very simply for users with fewer journals and a much simpler structure than we have. 

We settled on a system that allows you set up a hierarchy of parent themes in the wombat.yaml file. This solved our issue but it also works for the very simple case such as a journal having desktop AND mobile as well as a root theme. 

#Inheritance 

Wombat descends through the template hierarchy until it finds a matching .ftl, resource or config file (for example, logo.png, email.yaml, headerContent. ftl etc). To determine which file to use, Wombat selects the file using the hierarchy setup by your theme structure in the wombat.yaml file.

Wombat looks for files with specific names in the theme’s directories and uses the ??final?? matching template file in the hierarchy. ???You can choose whether you want to override a particular file or not.??? 

#Plos-Themes Inheritance Structure

For each of our journals, such as PLOS One and PLOS Biology, we set up this basic structure in our yaml file [see example](https://plos.github.io/ambraproject/example/wombat.yaml.plos):

- **Parent Theme: ```Plos```**
Theme common to all PLOS journal sites, regardless of the device type (desktop or mobile) and which journal it is.
PARENT:  ```root```  (files in wombat)
- **Device Specific Themes: ```DesktopPlos```, ```MobilePlos```**
Themes for a site category (device type) that are not specific to a journal. 
PARENT: ```mobile``` or ```desktop``` (files in wombat)
- **Journal Specific Theme: ```PlosOne```**
Themes for a journal that are not specific to a site category.
PARENT: ```Plos``` (files in themes)
- **Journal Site Specific Theme: ```DesktopPlosOne```**
Themes for individual sites. Each of these is specific to both a journal AND a device type.
PARENTS: 
1. ```PlosOne``` (files in themes)
2. ```DesktopPlos``` (files in themes) 

So the inheritance structure looks like this:

1. ```PLOS``` -  common to our entire organization
2. ```DesktopPlos``` - common to a device
3. ```PlosOne``` - specific to a journal regardless of device
4. ```DesktopPlosOne``` - specific to a journal and a device

#The hierarchy in practice

So back to our home page example, there were some requirements and how we tackled them in themes:

## All PLOS journal sites regardless of device have the same footer
footer.ftl file is placed in ```plos-themes/code/all_devices/all_sites/ftl/```
##Desktop sites for all journals have the same header- its different from mobile. 
header.ftl is placed in ```plos-themes/code/desktop/all_sites/ftl/```
##6 of our desktop journals sites need the same homepage, but PLOS One needs a completely separate one. 
For the 6 journals home.ftl is placed in ```plos-themes/code/desktop/all_sites/ftl/home/```.
For PLOS One home.ftl is placed in ```plos-themes/code/desktop/journals/PlosOne/ftl/home/```.
##Each of our journals has their own logo shared between the desktop and mobile sites
logo.png is placed in ```plos-themes/all_devices/journals/PlosOne/resource/img/``` - repeated for each journal





