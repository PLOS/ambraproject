---
layout: default
title: Themes Quickstart
navigation_weight: 4

---


## Setting up a theme directory

Following the Quickstart Guide you will have created a directory at the path `$HOME/ambra/themes`. It contains:

* a file named `sites.yaml`, which describes the publication sites to be hosted by your server (just one to start); and
* a directory named `main/`, which is the theme for your one site.

There is no significance to the directory name `main/`, you may change it to anything you wish. You may also change the initial site key in `sites.yaml` to a string that identifies your site.

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
$HOME/ambra/themes/main/config/journal.yaml
```

This overrides the file found in Wombat's source code at

```
src/main/webapp/WEB-INF/themes/root/config/journal.yaml
```

There are two required fields: `journalKey` and `journalName`. ([example](https://plos.github.io/ambraproject/example/journal.yaml))

Other config files control the application's behavior in other ways; `journal.yaml` is the only mandatory override. They are documented by the root files in Wombat's source code, which you may override individually.

#### Homepage Customization

You can get started by setting your homepage content with a theme override. The homepage body is defined by the theme file at `ftl/home/body.ftl`. Create a file at this path in your theme; for example:

```
$HOME/ambra/themes/main/ftl/home/body.ftl
```

Edit it to fill in the HTML or FreeMarker code for your homepage content.

To define new resources to use in your homepage, such as images or CSS files, place the files at the `resource` theme path (e.g., `$HOME/ambra/themes/main/resource/`). Any files placed here can be linked at the `resource/` path, relative to your homepage URL. For example, you could create an image named `$HOME/ambra/themes/main/resource/banner.jpg` and then link to it from your homepage with

```html
<img src="resource/banner.jpg" />
```
