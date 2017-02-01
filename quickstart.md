---
layout: default
title: Hank Quinlan, Horrible Cop
---
✮ = missing info

# Introduction

Welcome to the Ambra Quickstart guide, brought to you by PLoS


# Table of Contents:

1. Walkthrough of the Ambra core components
    1. Wombat
    1. Rhino
    1. Content Repo
1. Compiling the components
    1. System requirements
    1. Setting up the databases
    1. Compiling Rhino
    1. Compiling Wombat
    1. Compiling Content Repo
1. Setting up a theme directory
    1. Theme overrides 
1. Deploying the artifacts to Tomcat
    1. Viewing the "hello world" page for each component
1. Ingesting an article

# Walkthrough of the Ambra core components

## Wombat

wombat is the frontend component of our service-oriented publishing platform. Wombat is a web application that pulls most of its article data from Rhino (and the rest from Solr), and displays it using journal-specific freemarker templates. Since wombat gets its data from rhino and solr, you will need both of those servers running first.

## Rhino

Rhino is the back-end service for ingesting and storing article information. Rhino provides an API to create, read, update, and delete articles and article accessories. 

## Content Repo (crepo)

The Content Repo is a append-only repository of article assets, including the manuscript XML and all images.

# Compiling the components

## System requirements

### Overview
1. Java 8
1. Mysql
1. Maven
1. Tomcat
1. Solr

### Java 8
The Java 8 development kit (JDK8) is required to develop and compile the Ambra webapp.
✮ When we figure out the WAR distribution plan add either "go here to get the WARs" or "be aware you'll have to compile it yourself".

### MySQL
Ambra requires a running MySQL server. Ambra should be compatible with the latest version of MySQL.

#### ambra database

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

Note that `journalKey` *must* be identical to the key configured in `journal.yaml` (see below)     

#### crepo database

```bash
mysql -uroot -e "DROP DATABASE IF EXISTS repo;"
mysql -uroot -e "CREATE DATABASE repo;"
```

### Maven

Maven is required to compile Ambra.

### Directories

You will need to create a home directory for the Ambra project, a configuration directory, and a datastore for crepo.

Example:
  ```bash
  mkdir $HOME/ambra                         # home for the ambra project
  mkdir $HOME/ambra/datastores/crepostore   # crepo datastore directory
  sudo mkdir /etc/ambra                     # configuration directory
  ```
  
  Rhino requires two configuration files placed in configuration directory. 
  1. `rhino.yaml` 
  1. `context.xml`
  
  The files listed above have some required fields - see the example files included in this project.
  
  Clone the [Rhino github project](https://github.com/PLOS/rhino.git) into your ambra folder. This will be your Rhino working directory.
  
## Compiling Rhino
Compile Rhino with maven:
1. navigate to the rhino working directory - `cd ~/projects/rhino`
2. `mvn clean install`
 
## Compiling Wombat

Wombat requires a configuration file named `wombat.yaml` placed in the configuration directory.
`wombat.yaml` has some required fields - see the example `wombat.yaml` file included in this project. 

Clone the [Wombat github project](https://github.com/PLOS/wombat.git) into your ambra folder. This will be your Wombat working directory.

Compile Wombat with maven:
1. navigate to the wombat working directory - `cd ~/projects/wombat`
2. `mvn clean install`

## Setting up a theme directory

Create a new directory to house your site's theme configuration. For example, `/var/themes`

### Themes Configuration

Themes requires a file named `journal.yaml` placed in the theme config directory.

Using the example above, this directory would be `/var/themes/config/`.
 
There are two required fields - `journalKey` and `journalName`. see the example `journal.yaml` file included in this project.


### Theme Overrides

Every Freemarker Template, configuration, and resource file in Wombat can be overridden in themes. This allows you to customize your site.

For example to override `email.yaml`:
1. create a folder with the same directory structure as Wombat, starting from `src/main/webapp/WEB-INF/themes` 
    1. In Wombat this file is located at `src/main/webapp/WEB-INF/themes/root/config/email.yaml`
    1. In your theme, this file should be located at `$YOUR_THEME_PATH/config/email.yaml`

## Compiling Content Repo (crepo)

1. Clone the [crepo github project](https://github.com/PLOS/content-repo.git) into your projects folder. This will be your crepo working directory.

2. Make sure to configure `context.xml` in your configuration directory to use the content repo. Example: 

```xml
  <Resource name="jdbc/repoDB"
              auth="Container"
              type="javax.sql.DataSource"
              factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
              validationQuery="SELECT 1"
              testOnBorrow="true"
              driverClassName="com.mysql.jdbc.Driver"
              username="root"
              password=""
              url="jdbc:mysql://localhost:3306/repo"/>
              <!-- These credentials and url should match your MySQL server -->
```

Also See the example `context.xml` file included in this project.

Compile crepo with maven:
1. navigate to the crepo working directory - `cd ~/projects/crepo`
1. `mvn clean install`

## Deploying the artifacts to Tomcat

Use maven to deploy each component. This is where you will set the application port as well as define the configuration directory:
1. Wombat: `mvn tomcat6:run -Dmaven.tomcat.port=8080 -Dwombat.configDir=/etc/ambra`
1. Rhino: `mvn tomcat6:run -Dmaven.tomcat.port=8082 -Drhino.configDir=/etc/ambra`
1. Crepo: `mvn tomcat6:run -Dmaven.tomcat.port=8081`

### Viewing the "hello world" page for each component

Go to `http://localhost:<PORT>` to view the root page for each application

1. Rhino: Swagger API interface
1. crepo: Swagger API interface
1. Wombat: debug or root page.

## Ingesting an article

PLoS provides some sample article package zip files for ingestion, located [here](✮).

You can ingest and publish an article package using the Rhino Swagger interface. For complete instructions, see "Ingesting the article into Rhino" in the Ingestible-Package-Guide. 