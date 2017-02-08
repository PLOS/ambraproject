---
layout: default
title: Ingestible Package Guide
navigation_weight: 3

---

# Introduction

This guide will walk you through creating, ingesting, and publishing an article package in Ambra.
For instructions for setting up the Ambra stack, please see the Quickstart Guide.

# Table of Contents:

1. [The JATS standard](#the-jats-standard)
2. [The article package](#the-article-package)
    1. [manifest.xml](#manifestxml)
        1. [Manifest XML Example](#manifest-xml-example)
        2. [Required Tags](#required-tags)
    2. [manuscript.xml](#manuscriptxml)
        1. [eISSN](#eissn)
        2. [JATS deviations](#jats-deviations)
    3. [Printable](#printable)
    4. [Article Assets](#article-assets-figures-tables-and-supplementary-material)
        1. [Article Asset Types](#article-asset-types)
3. [Ingesting an article into Rhino](#ingesting-an-article-into-rhino)
    1. [Creating a Content Repo bucket](#creating-a-content-repo-bucket)
    2. [Uploading the article](#uploading-an-article)
    3. [Adding an article revision](#adding-an-article-revision)
4. [Viewing the article](#viewing-the-article)

# The JATS standard

JATS is a standardized markup for journal articles. When ingesting your article into Ambra, you will have to provide an XML version of your manuscript that complies with JATS.

Rhino supports JATS `1.1d2` and `1.1d3`.

The JATS standard will tell you which tags to use for an abstract, author list, references, etc. Find the standard [here](https://jats.nlm.nih.gov/index.html).

You can find example articles for the 1.1d3 version of JATS [here](https://jats.nlm.nih.gov/publishing/tag-library/1.1d3/chapter/samples.html).

# The Article Package

The article package is a zip file that contains all of the files that make up the article content. Each zip entry should be at the root level; the zip archive should not contain any subdirectories. There are a few required files, which are detailed below.

## manifest.xml

The manifest is an XML file that tells Rhino what is in the article package. It must be named `manifest.xml`.

All files present in the article package zip *must* be represented in the manifest XML, and the names must match.

Verify the layout of your `manifest.xml` with a DTD. It is kept in Rhino, at `/src/main/resources/manifest.dtd`. The DTD also contains an example manifest, as it would look for a PLOS article.

It is optional to include `manifest.dtd` in your article package. If you choose include it, it must be mentioned in the `ancillary` section of `manifest.xml`.

### Manifest XML Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE manifest SYSTEM "manifest.dtd">
<manifest>
  <articleBundle>
    <article uri="info:doi/my-article-id">
      <representation entry="my-article-id_xml" key="my-article-id_xml" mimetype="application/xml" type="manuscript"/>
      <representation entry="my-article-id_pdf" key="my-article-id_pdf" mimetype="application/pdf" type="printable"/>
    </article>
    <object type="figure" uri="info:doi/my-article-id_g001">
      <representation entry="my-article-id_g001.tif" key="my-article-id_g001.tif" mimetype="image/tiff" type="original"/>
      <representation entry="my-article-id_g001_medium.png" key="my-article-id_g001_medium.png" mimetype="image/png" type="medium"/>
      <representation entry="my-article-id_g001_large.png" key="my-article-id_g001_large.png" mimetype="image/png" type="large"/>
      <representation entry="my-article-id_g001_inline.png" key="my-article-id_g001_inline.png" mimetype="image/png" type="inline"/>
      <representation entry="my-article-id_g001_small.png" key="my-article-id_g001_small.png" mimetype="image/png" type="small"/>
    </object>
    <object type="graphic" uri="info:doi/my-article-id_e001">
      <representation entry="my-article-id_e001.tif" key="my-article-id_e001.tif" mimetype="image/tiff" type="original"/>
      <representation entry="my-article-id_e001_inline.png" key="my-article-id_e001_inline.png" mimetype="image/png" type="inline"/>
    </object>
    <object type="supplementaryMaterial" uri="info:doi/my-article-id_s001">
      <representation entry="my-article-id_s001.docx" key="my-article-id_s001.docx" mimetype="application/vnd.openxmlformats-officedocument.wordprocessingml.document" type="supplementary"/>
    </object>
    <object type="table" uri="info:doi/my-article-id_t001">
      <representation entry="my-article-id_t001.tif" key="my-article-id_t001.tif" mimetype="image/tiff" type="original"/>
      <representation entry="my-article-id_t001_medium.png" key="my-article-id_t001_medium.png" mimetype="image/png" type="medium"/>
      <representation entry="my-article-id_t001_large.png" key="my-article-id_t001_large.png" mimetype="image/png" type="large"/>
      <representation entry="my-article-id_t001_inline.png" key="my-article-id_t001_inline.png" mimetype="image/png" type="inline"/>
      <representation entry="my-article-id_t001_small.png" key="my-article-id_t001_small.png" mimetype="image/png" type="small"/>
    </object>
  </articleBundle>
  <ancillary>
    <file entry="manifest.xml" key="my-article-id_manifest.xml" mimetype="application/xml"/>
    <file entry="extra.xml" key="extra.xml" mimetype="application/xml"/>
  </ancillary>
</manifest>
```

### Required tags

The example above, as well as the manifest DTD, define all required tags.

1. The `xml` and `DOCTYPE` tags are required and can be copied verbatim from the example.
2. `manifest` must be used as the top-level container tag.
3. `articleBundle` contains everything used to display the article.
4. `article` defines the article URI (DOI).
    1. Must contain a `representation` tag for the XML and printable versions of your article.
5. `object` is a general container tag for graphics and supplementary material. It also requires `representation` tags, but the requirements differ based on object type. Graphics will be covered in more detail later in the guide.
6. `representation` requirements:
    1. `entry` - value is identical to the filename
    2. `key` - a unique identifier for the asset which will be posted to the Content Repo
    3. `mimetype` - MIME type of the asset
    4. `type` - varies based on object type, covered in "Graphics" below.
7. `ancillary` contains any extra files, represented in `file` nodes. Both `manifest.xml` and `manifest.dtd` must be listed here (if present).
    1. `file` nodes require `entry`, `key`, and `mimetype` attributes.

## Manuscript.xml

The manuscript XML contains the text for your article.

There are standard tags to use for the abstract, author list, citations, etc. Please consult the [JATS standard](https://jats.nlm.nih.gov/index.html) or refer to the example article packages [here](http://downloads.ambraproject.org/article_examples).

Each `object` asset from the manifest should be referenced by DOI somewhere in the manuscript.

### eISSN

The eISSN defined in your manuscript XML *must match* a journal eISSN defined in your Ambra database.

Example:

```xml
<issn pub-type="epub">1932-6203</issn>
```

### JATS deviations

There are two known issues when rendering a JATS article in Wombat:

1. The `<!DOCTYPE` tag should not be included.
    * If included, the article will not render, and Wombat will throw a DTD-not-found exception.
2. The `<copyright-statement>` tag is not rendered. Use the `<license-p>` tag instead.

PLOS is actively working to resolve these issues.

## Printable

The `printable` representation is a print-ready version of your article, generally a PDF.

## Article Assets (figures, tables, and supplementary material)

An article can have any number of article assets included, as long as they are defined in the manuscript AND the manifest.

Each included article asset requires at least one resized copy. The copy, or copies, will be one of the following types:

### Article Asset Types

1. `figure` - A general image. Requires `original`, `large`, `medium`, `small`, and `inline` representations.
2. `table` - Used to show tabular data in a graphical format. Requires `original`, `large`, `medium`, `small`, and `inline` representations.
3. `graphic` - Used for images shown in-line with text, such as mathematical formulae, icons, and logos. Requires `original` and `inline` representations.
4. `supplementaryMaterial` - used for supplementary material such as videos or other media. Requires *only* the `supplementary` type.

#### Figure and Table Size Types

1. `original` - The original image at its maximum resolution.
2. `large` - Used in the stand-alone image view and the image viewer. Should be able to fit on a standard computer screen.
3. `medium` - Used on the homepage. Should be less than half the size of the large version.
4. `inline` - Used within the article body. Should be slightly smaller than the medium version.
5. `small` - Used in issues and the current issue on the homepage. Should be less than half the size of the medium version.

The sizes for these images are not strict and tweaking may be necessary.

These requirements are also defined in the example XML above.

# Ingesting an article into Rhino

## Creating a Content Repo bucket

Rhino must be linked to a Content Repo bucket to store article files. The bucket's name is configured in the `rhino.yaml` file.

1. Visit the Content Repo root page where you'll see a browser interface.
2. Click on "Create a bucket" within the `buckets` section.
3. You'll see a bucket creation form. Enter the configured name (e.g., `corpus`).
4. Click the "Try it out!" button.

## Uploading an article

1. Visit the Rhino root page where you'll see a swagger interface.
2. Click on `ingestible-zip-controller`.
3. Click on `zipUpload` or anywhere on the green bar.
4. Click the "Browse..." button and upload your article package zipfile.
5. Click the "Try it out!" button.

This will ingest the article into Rhino and save the data to the database and Content Repo.

Ambra is designed with versioning in mind. This means when you ingest an article, it is staged into the `ArticleIngestion` table but not yet published. In order to actually view an article, you will need to add a new revision indicating that the ingested version is one you want to publish.

## Adding an article revision

1. Visit the Rhino root page where you'll see a swagger interface.
2. Click on `article-crud-controller`.
3. Click on `writeRevision`.
4. Enter the DOI. Any slash characters (`/`) in the DOI be escaped as `++` (for example, `10.0000/my-article` becomes `10.0000++my-article`).
5. Enter the ingestion number.
6. Click the "Try it out!" button.

By default, each new revision you create will receive incrementing revision numbers, starting at 1. Input an old revision number to overwrite it instead. If you want to change an article without displaying a revision history, just overwrite revision number 1.

# Viewing the article

Navigate to the article in Wombat: http://localhost:<$WOMBAT_PORT>/wombat/<$SITE_NAME>/article?id=<$DOI>

For example: http://localhost:8123/wombat/Desktop/article?id=my-article-id
