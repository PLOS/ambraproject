---
layout: default
title: Quickstart Guide
navigation_weight: 2


---

# Introduction

This Quickstart guide provides instructions for setting up a new instance of the Ambra stack.

These instructions are targeted at Linux and iOS systems. We have not tried to install it in Windows environments.


# Table of Contents:

1. [Walkthrough of the Ambra core components](#walkthrough-of-the-ambra-core-components)
    1. [Wombat](#wombat)
    2. [Rhino](#rhino)
    3. [Content Repo](#content-repo)
2. [Obtaining the binaries](#obtaining-the-binaries)
3. [System setup](#system-setup)
    1. [Requirements](#requirements)
    2. [Setting up the databases](#setting-up-the-databases)
    3. [Directories](#directories)
    4. [Configuration files](#configuration-files)
4. [Setting up a theme directory](#setting-up-a-theme-directory)
    1. [Theme Overrides](#theme-overrides)
    2. [Journal Configuration](#journal-configuration)
    3. [Homepage Customization](#homepage-customization)
5. [Deploying the artifacts to Tomcat](#deploying-the-artifacts-to-tomcat)
    1. [Viewing the "hello world" page for each component](#viewing-the-hello-world-page-for-each-component)
6. [Ingesting an article](#ingesting-an-article)

# Walkthrough of the Ambra core components

## Wombat

Wombat is the front-end component of the publishing platform. Wombat is a web application that pulls most of its article data from Rhino, and displays it using customizable FreeMarker templates. Since Wombat gets its data from Rhino, you will need a Rhino server running first.

## Rhino

Rhino is the back-end service for ingesting and storing article content and metadata. Rhino provides an API to create, read, update, and delete articles and associated data.

## Content Repo

The Content Repo is an append-only repository of article assets, including the manuscript XML and all images.

# Quickstart using Docker

You can quickly bring up an auto configured Ambra stack using Docker instead of having to install Java and download all the binaries. [See our Docker setup guide](https://github.com/PLOS/Dockerfiles/wiki/Ambra-Quick-Start).

# Obtaining the binaries

If you have Tomcat installed on your system, you can set up and run Ambra without compiling any code. Download `.war` files from our [Releases page](https://plos.github.io/ambraproject/Releases.html), and follow the instructions for [deploying the artifacts to Tomcat](#deploying-the-artifacts-to-tomcat).

You can also check out the source code and compile the `.war` artifacts for youself. The source code repositories are located at:

* [Wombat](https://github.com/PLOS/wombat.git)
* [Rhino](https://github.com/PLOS/rhino.git)
* [Content Repo](https://github.com/PLOS/content-repo.git)

Maven is required to compile components of the Ambra stack. Each component can be compiled by executing `mvn install` from the checked-out directory.

# System setup

## Requirements

### Overview
1. Java 8
2. Tomcat
3. MySQL
4. Solr (optional)
5. Maven (optional)

### Java 8
Your runtime environment must support Java 8 or later. To develop and compile the webapps, the Java 8 Development Kit (JDK8) is required.

### Tomcat
Ambra has been tested with Tomcat 7 and should be compatible with the latest Tomcat.


### MySQL
Ambra requires a running MySQL server. It has been tested with version 5.6.28 and should be compatible with the latest version of MySQL.

## Setting Up the Databases

#### Ambra database

```bash
mysql -uroot -e "DROP DATABASE IF EXISTS ambra;"
mysql -uroot -e "CREATE DATABASE ambra;"
```

Download the Ambra schema ([`ambra-schema.sql`](https://plos.github.io/ambraproject/example/ambra-schema.sql)) and import it into the `ambra` database:

```bash
mysql -h 127.0.0.1 -P 3306 -uroot -p ambra < ambra-schema.sql
```

Add a journal to the database:

```sql
INSERT INTO journal (`journalKey`, `title`, `eissn`) VALUES ("my_journal", "My Journal", "0000-0000");
```

* `journalKey` - an identifier used in config files
* `title` - the journal title
* `eissn` - the journal's [electronic ISSN (e-ISSN)](http://www.issn.org/). Articles identify the journal to which they are added by e-ISSN (see the [Ingestible Package Guide](https://plos.github.io/ambraproject/Ingestible-Package-Guide.html) for details). For the sample database we will use a dummy value: `0000-0000`.

#### Content Repo database

```bash
mysql -uroot -e "DROP DATABASE IF EXISTS repo;"
mysql -uroot -e "CREATE DATABASE repo;"
```

Download the Content Repo schema ([`content-repo-schema.sql`](https://plos.github.io/ambraproject/example/content-repo-schema.sql)) and import it into the `repo` database:

```bash
mysql -h 127.0.0.1 -P 3306 -uroot -p repo < content-repo-schema.sql
```

Add a bucket named "corpus" to the database.

```sql
INSERT INTO buckets (`bucketName`) VALUES ("corpus");
```

## Setting Up Configuration
### Directories

Create the following directories:
- a directory to hold configuration files
- a directory to hold files in the Content Repo's datastore

```bash
  mkdir $HOME/ambra
  mkdir $HOME/ambra/config           # configuration directory
  mkdir $HOME/ambra/crepo_datastore  # Content Repo datastore directory
```

On a production system, `/etc/ambra` is recommended for the configuration directory.

### Configuration files

#### Shared
Rhino, Wombat, and Content Repo all run on Tomcat. For this quick start they will all run on the same Tomcat server and they will share the same `context.xml` ([example](https://plos.github.io/ambraproject/example/context.xml)).  Place this file in the configuration directory you created above.

#### Rhino
Rhino requires it's own configuration file placed in the configuration directory:
`rhino.yaml` ([example](https://plos.github.io/ambraproject/example/rhino.yaml)).
It has some required fields.

#### Content Repo
The shared `context.xml` in your configuration directory must contain a path to the Content Repo data store.

#### Wombat
Wombat requires it's own configuration file placed in the configuration directory: `wombat.yaml` ([example](https://plos.github.io/ambraproject/example/wombat.yaml)).
It has some required fields.
The `path` variable must have an actual path, don't use $HOME.

Wombat can be themed and will not start without having a theme installed.  Create the theme by downloading and extracting the following archive [`themes.tar.gz`](https://plos.github.io/ambraproject/example/themes.tar.gz).

```bash
cd $HOME/ambra/
wget https://plos.github.io/ambraproject/example/themes.tar.gz
tar -xvzf themes.tar.gz
```


## Deploying the applications to Tomcat

If you have downloaded or compiled `.war` files, you may deploy them to a Tomcat instance as normal. (Consult the Tomcat documentation for details.)

You may also run each component from Maven. This is where you will set the application port as well as define the configuration directory:

1. Wombat: `mvn tomcat6:run -Dmaven.tomcat.port=8080 -Dwombat.configDir=/etc/ambra`
2. Rhino: `mvn tomcat6:run -Dmaven.tomcat.port=8082 -Drhino.configDir=/etc/ambra`
3. Content Repo: `mvn tomcat6:run -Dmaven.tomcat.port=8081`

Note: Run these mvn commands from the directory you cloned each project.

### Viewing the "hello world" page for each component

Go to `http://localhost:<PORT>` to view the root page for each application.

1. Rhino: Swagger API interface
2. Content Repo: Swagger API interface
3. Wombat: Debug or root page

## Ingesting an article

PLOS provides some sample article package zip files for ingestion, located [here](http://downloads.ambraproject.org/article_examples).

You can ingest and publish an article package using Rhino's Swagger interface. For complete instructions, see "Ingesting the article into Rhino" in the [Ingestible Package Guide](https://plos.github.io/ambraproject/Ingestible-Package-Guide.html).
