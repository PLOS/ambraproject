---
layout: default
title: Working With Themes
navigation_weight: 3

---

We have included a sanitized version of our journal theme repository as reference to our implementation. We wanted show an example of how we set up our theme structure. We also wanted to provide anyone using Ambra as a journal platform with some example code and ideas for features we developed.

# The problem we were trying to solve

PLOS has seven journals that share a lot of similarities in layout and features, but there are some differences.

Our mega journal _PLOS ONE_ has some unique features -- for example, homepage and browsing features -- that differ from the other journals.

For example, we wanted _PLOS ONE_ to have a very different homepage layout than our other journals.

We also needed to theme mobile and desktop differently. Wombat is not a fully responsive site: long-form scientific papers do not render well on a small device. Creating a separate mobile site made more sense for our needs.

We strove to create a theme structure that would allow inheritance from a parent theme. This way, we could have most sites use the same parent homepage template, and override this template for _PLOS ONE_.

We wanted to be able to do the same thing for desktop and mobile pages. For example, it was important for both the desktop and mobile sites to share templates, but have unique headers and footers.

We also wanted the themes to function very simply for users with fewer journals and a much simpler structure than we have.

We settled on a system that allows you set up a hierarchy of parent themes in the `wombat.yaml` file. This solved our issue and it also works for very simple cases.

# Inheritance

Wombat descends through the template hierarchy until it finds a matching `.ftl`, resource, or config file (for example, `logo.png`, `email.yaml`, `headerContent.ftl` etc). To determine which file to use, Wombat selects the file using the hierarchy setup by your theme structure in the `wombat.yaml` file.

If more than one file has the same name, Wombat will use the one furthest down the hierarchy.

# PLOS's Theme Inheritance Structure

For each of our journals, such as _PLOS One_ and _PLOS Biology_, we set up this basic structure in our yaml file [see example](https://plos.github.io/ambraproject/example/wombat.yaml.plos):

- **Parent Theme: ```Plos```**
Root theme common to all PLOS journal sites, regardless of the device type (desktop or mobile) and which journal it is.
PARENT:  ```root```  (files in wombat)
- **Device-Specific Themes: ```DesktopPlos```, ```MobilePlos```**
Themes for a site category (device type) that are not specific to a journal.
PARENT: ```mobile``` or ```desktop``` (files in wombat)
- **Journal-Specific Theme: ```PlosOne```**
Themes for a journal that are not specific to a site category.
PARENT: ```Plos``` (files in themes)
- **Journal-Site-Specific Theme: ```DesktopPlosOne```**
Themes for individual sites. Each of these is specific to both a journal AND a device type.
PARENTS:
1. ```PlosOne``` (files in themes)
2. ```DesktopPlos``` (files in themes)

So the inheritance structure looks like this:

1. ```PLOS``` -  common to our entire organization
2. ```DesktopPlos``` - common to a device
3. ```PlosOne``` - specific to a journal regardless of device
4. ```DesktopPlosOne``` - specific to a journal and a device

# The hierarchy in practice

So back to our home page example, here are some requirements and how we tackled them in themes:

## All PLOS journal sites regardless of device have the same footer.

The `footer.ftl` file is placed in ```plos-themes/code/all_devices/all_sites/ftl/```

## Desktop sites for all journals have the same header, but the header should not apply to mobile.

`header.ftl` is placed in ```plos-themes/code/desktop/all_sites/ftl/```

## Most of our desktop journals sites need the same homepage, but _PLOS One_ needs a completely separate one.

For the most journals, `home.ftl` is placed in ```plos-themes/code/desktop/all_sites/ftl/home/```.
For _PLOS One_, the `home.ftl` is placed in ```plos-themes/code/desktop/journals/PlosOne/ftl/home/```.

## Each of our journals has their own logo shared between the desktop and mobile sites

`logo.png` is placed in ```plos-themes/all_devices/journals/PlosOne/resource/img/``` - repeated for each journal
