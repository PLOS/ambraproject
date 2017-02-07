---
layout: default
title: Quickstart Guide
navigation_weight: 1


---

# Introduction

This Quickstart guide provides instructions for setting up a new instance of the Ambra stack.


# Table of Contents:

1. [Walkthrough of the Ambra core components](#walkthrough-of-the-ambra-core-components)
    1. [Wombat](#wombat)
    2. [Rhino](#rhino)
    3. [Content Repo](#content-repo-crepo)
2. [Pre-built WAR files](#pre-built-war-files)
3. [Compiling the components](#compiling-the-components)
    1. [System requirements](#system-requirements)
    2. [Setting up the databases](#setting-up-the-databases)
    3. [Compiling Rhino](#compiling-rhino)
    4. [Compiling Wombat](#compiling-wombat)
    5. [Compiling Content Repo](#compiling-content-repo)
4. [Setting up a theme directory](#setting-up-a-theme-directory)
    1. [Themes Configuration](#themes-configuration)
    2. [Theme Overrides](#theme-overrides)
5. [Deploying the artifacts to Tomcat](#deploying-the-artifacts-to-tomcat)
    1. [Viewing the "hello world" page for each component](#viewing-the-hello-world-page-for-each-component)
6. [Ingesting an article](#ingesting-an-article)

# Walkthrough of the Ambra core components

## Wombat

Wombat is the front-end component of the publishing platform. Wombat is a web application that pulls most of its article data from Rhino, and displays it using customizable FreeMarker templates. Since Wombat gets its data from Rhino, you will need a Rhino server running first.

## Rhino

Rhino is the back-end service for ingesting and storing article content and metadata. Rhino provides an API to create, read, update, and delete articles and associated data.

## Content Repo (CRepo)

The Content Repo is an append-only repository of article assets, including the manuscript XML and all images.

# Pre-built WAR files

You can set up and run Ambra without compiling any code. Simply use the `.war` files provided on our [Releases page](https://plos.github.io/ambraproject/releases.html), and follow the instructions for [deploying the artifacts to Tomcat](#deploying-the-artifacts-to-tomcat).

# Compiling the components

## System requirements

### Overview
1. Java 8
2. Mysql
3. Maven
4. Tomcat
5. Solr

### Java 8
The Java 8 development kit (JDK8) is required to develop and compile the Ambra webapp.

## Setting Up the Databases

### MySQL
Ambra requires a running MySQL server. Ambra should be compatible with the latest version of MySQL.

#### Ambra database

```bash
mysql -uroot -e "DROP DATABASE IF EXISTS ambra;"
mysql -uroot -e "CREATE DATABASE ambra;"
```

Import the ambra schema, `ambra-schema.sql` into the ambra database:

```bash
mysql -h 127.0.0.1 -P 3306 -uroot -p ambra < ambra-schema.sql
```

Add a journal to the database. For example:

```sql
INSERT INTO journal (`journalKey`, `title`) VALUES ("PLOS", "PLOSWorld");
```


Note that `journalKey` *must* be identical to the key configured in `journal.yaml` ([see below](#themes-configuration))

#### Content Repo database

```bash
mysql -uroot -e "DROP DATABASE IF EXISTS repo;"
mysql -uroot -e "CREATE DATABASE repo;"
```

### Maven

Maven is required to compile Ambra.

### Directories

You will need to create a home directory for the Ambra project, a configuration directory, and a datastore for CRepo.

Example:
```bash
  mkdir $HOME/ambra                         # home for the ambra project
  mkdir $HOME/ambra/datastores/crepostore   # crepo datastore directory
  sudo mkdir /etc/ambra                     # configuration directory
```

Rhino requires two configuration files placed in configuration directory.

1. `rhino.yaml` ([example](#https://plos.github.io/ambraproject/example/wombat.yaml))
2. `context.xml` ([example](#https://plos.github.io/ambraproject/example/context.xml))

The files listed above have some required fields - see the example files included in this project.

Clone the [Rhino GitHub project](https://github.com/PLOS/rhino.git). This will be your Rhino working directory.

## Compiling Rhino
Compile Rhino with Maven:
1. Navigate to the Rhino working directory - `cd ~/projects/rhino`
2. `mvn clean install`

## Compiling Wombat

Wombat requires a configuration file named `wombat.yaml` placed in the configuration directory.
`wombat.yaml` has some required fields - see the [example](#https://plos.github.io/ambraproject/example/context.xml) file.

Clone the [Wombat GitHub project](https://github.com/PLOS/wombat.git). This will be your Wombat working directory.

Compile Wombat with Maven:
1. Navigate to the Wombat working directory - `cd ~/projects/wombat`
2. `mvn clean install`

## Compiling Content Repo

1. Clone the [Content Repo GitHub project](https://github.com/PLOS/content-repo.git). This will be your CRepo working directory.
2. Make sure to configure `context.xml` in your configuration directory to use the content repo. See the [example](#https://plos.github.io/ambraproject/example/context.xml) file.

Compile CRepo with Maven:
1. Navigate to the CRepo working directory - `cd ~/projects/crepo`
2. `mvn clean install`

## Setting up a theme directory

Create a new directory to house your site's theme configuration. For example, `/var/themes`.

### Themes Configuration

Themes requires a file named `journal.yaml` placed in the theme config directory.

Using the example above, this directory would be `/var/themes/config/`.

There are two required fields: `journalKey` and `journalName` ([example](#https://plos.github.io/ambraproject/example/journal.yaml)).


### Theme Overrides

Every Freemarker Template, configuration, and resource file in Wombat can be overridden in themes. This allows you to customize your site.

For example to override `email.yaml`:
1. create a directory with the same directory structure as Wombat, starting from `src/main/webapp/WEB-INF/themes`
    1. In Wombat this file is located at `src/main/webapp/WEB-INF/themes/root/config/email.yaml`
    2. In your theme, this file should be located at `$YOUR_THEME_PATH/config/email.yaml`

#### Homepage

You can get started by setting your homepage content with a theme override. The homepage body is defined by the theme file `$YOUR_THEME_PATH/ftl/home/body.ftl`. Create a file at this path in your theme and fill it with the HTML or FreeMarker code for your homepage content.

To define new resources to use in your homepage, such as images or CSS files, place the files at the `$YOUR_THEME_PATH/resource` theme path. Any files placed here can be linked at the `resource/` path, relative to your homepage URL. For example, you could place an image named `banner.jpg` in the `resource` path and then link to it from your homepage with

```html
<img src="resource/banner.jpg" />
```

## Deploying the artifacts to Tomcat

If you have downloaded or compiled `.war` files, you may deploy them to a Tomcat instance as normal. (Consult the Tomcat documentation for details.)

You may also run each component from Maven. This is where you will set the application port as well as define the configuration directory:

1. Wombat: `mvn tomcat6:run -Dmaven.tomcat.port=8080 -Dwombat.configDir=/etc/ambra`
2. Rhino: `mvn tomcat6:run -Dmaven.tomcat.port=8082 -Drhino.configDir=/etc/ambra`
3. Crepo: `mvn tomcat6:run -Dmaven.tomcat.port=8081`

### Viewing the "hello world" page for each component

Go to `http://localhost:<PORT>` to view the root page for each application

1. Rhino: Swagger API interface
2. crepo: Swagger API interface
3. Wombat: debug or root page.

## Ingesting an article

PLOS provides some sample article package zip files for ingestion, located [here](http://www.ambraproject.org/downloads/article_examples).

You can ingest and publish an article package using Rhino's Swagger interface. For complete instructions, see "Ingesting the article into Rhino" in the [Ingestible-Package-Guide](https://plos.github.io/ambraproject/Ingestible-Package-Guide.html).
