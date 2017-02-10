---
layout: default
title: Quickstart Guide
navigation_weight: 2


---

# Introduction

This Quickstart guide provides instructions for setting up a new instance of the Ambra stack.


# Table of Contents:

1. [Walkthrough of the Ambra core components](#walkthrough-of-the-ambra-core-components)
    1. [Wombat](#wombat)
    2. [Rhino](#rhino)
    3. [Content Repo](#content-repo-crepo)
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

## Content Repo (CRepo)

The Content Repo is an append-only repository of article assets, including the manuscript XML and all images.

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
2. MySQL
3. Tomcat
4. Solr (optional)
5. Maven (optional)

### Java 8
Your runtime environment must support Java 8 or later. To develop and compile the webapps, the Java 8 Development Kit (JDK8) is required.

## Setting Up the Databases

### MySQL
Ambra requires a running MySQL server. Ambra should be compatible with the latest version of MySQL.

#### Ambra database

```bash
mysql -uroot -e "DROP DATABASE IF EXISTS ambra;"
mysql -uroot -e "CREATE DATABASE ambra;"
```

Download the Ambra schema ([`ambra-schema.sql`](https://plos.github.io/ambraproject/example/ambra-schema.sql)) and import it into the `ambra` database. For example:

```bash
mysql -h 127.0.0.1 -P 3306 -uroot -p ambra < ambra-schema.sql
```

Add a journal to the database. For example:

```sql
INSERT INTO journal (`journalKey`, `title`, `eissn`) VALUES ("my_journal", "My Journal", "0000-0000");
```

* The field `journalKey` is an identifier used in config files. It must match the key configured in `journal.yaml` ([see below](#themes-configuration)).
* The field `title` is the reader-facing display form of the title.
* The field `eissn` is the journal's [electronic ISSN (e-ISSN)](http://www.issn.org/). It must match the e-ISSN for articles ingested into the system (see the [Ingestible Package Guide](https://plos.github.io/ambraproject/Ingestible-Package-Guide.html) for details). On a toy system, use a dummy value such as `0000-0000`.

#### Content Repo database

```bash
mysql -uroot -e "DROP DATABASE IF EXISTS repo;"
mysql -uroot -e "CREATE DATABASE repo;"
```

### Directories

You will need to create a configuration directory and a directory to hold files in CRepo's datastore.

On a toy system, a recommended setup is:

```bash
  mkdir $HOME/ambra
  mkdir $HOME/ambra/crepo_datastore  # CRepo datastore directory
  mkdir $HOME/ambra/config           # configuration directory
```

On a production system, `/etc/ambra` is recommended for the configuration directory.

### Configuration files

#### Rhino

Rhino requires two configuration files placed in configuration directory.

1. `rhino.yaml` ([example](https://plos.github.io/ambraproject/example/rhino.yaml))
2. `context.xml` ([example](https://plos.github.io/ambraproject/example/context.xml))

The files listed above have some required fields - see the example files included in this project.

#### Wombat

Wombat requires a configuration file named `wombat.yaml` placed in the configuration directory.
`wombat.yaml` has some required fields - see the [example](https://plos.github.io/ambraproject/example/wombat.yaml) file.

#### Content Repo

In addition to the Rhino configuration, the `context.xml` in your configuration directory must also be configured to provide Content Repo with a directory to use as its data store. See the [example](https://plos.github.io/ambraproject/example/context.xml) file.

## Setting up a theme directory

Create a new directory to house your site's theme configuration. If you are using a `$HOME/ambra` directory as in the example above, then do

```bash
  mkdir -p $HOME/ambra/themes/my_theme
```

You may substitute your publication's name for `my_theme`.

On a production system, `/var/themes` is recommended instead of `$HOME/ambra/themes`.

### Theme Overrides

Every Freemarker Template, configuration, and resource file in Wombat can be overridden in your theme. This allows you to customize your site.

Wombat's built-in themes are located in its source code at

* `src/main/webapp/WEB-INF/themes/root`
* `src/main/webapp/WEB-INF/themes/desktop`
* `src/main/webapp/WEB-INF/themes/mobile`

You may [explore these directories](https://github.com/PLOS/wombat/tree/master/src/main/webapp/WEB-INF/themes) to find templates and configuration files that you can override. Two examples follow.

#### Journal Configuration

A theme requires a file named `journal.yaml` placed in the `config` directory at the theme path. For example:

```
$HOME/ambra/themes/my_theme/config/journal.yaml
```

This overrides the file found in Wombat's source code at

```
src/main/webapp/WEB-INF/themes/root/config/journal.yaml
```

There are two required fields: `journalKey` and `journalName`. [See an example.](https://plos.github.io/ambraproject/example/journal.yaml)

Other config files control the application's behavior in other ways; `journal.yaml` is the only mandatory override. They are documented by the root files in Wombat's source code, which you may override individually.

#### Homepage Customization

You can get started by setting your homepage content with a theme override. The homepage body is defined by the theme file at `ftl/home/body.ftl`. Create a file at this path in your theme; for example:

```
$HOME/ambra/themes/my_theme/ftl/home/body.ftl
```

Edit it to fill in the HTML or FreeMarker code for your homepage content.

To define new resources to use in your homepage, such as images or CSS files, place the files at the `resource` theme path (e.g., `$HOME/ambra/themes/my_theme/resource/`). Any files placed here can be linked at the `resource/` path, relative to your homepage URL. For example, you could create an image named `$HOME/ambra/themes/my_theme/resource/banner.jpg` and then link to it from your homepage with

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

Go to `http://localhost:<PORT>` to view the root page for each application.

1. Rhino: Swagger API interface
2. CRepo: Swagger API interface
3. Wombat: Debug or root page

## Ingesting an article

PLOS provides some sample article package zip files for ingestion, located [here](http://downloads.ambraproject.org/article_examples).

You can ingest and publish an article package using Rhino's Swagger interface. For complete instructions, see "Ingesting the article into Rhino" in the [Ingestible Package Guide](https://plos.github.io/ambraproject/Ingestible-Package-Guide.html).
