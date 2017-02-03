# Welcome to Ambra Project!

Read below for instructions on updating ambraproject.org:

# Adding Pages

To add a new page, create a new markdown (.md) file and add the following to the top:

```html
    ---
    layout: default
    title: YOUR TITLE
    ---
```

To list the new page on the documentation page, add the following:

```html
  navigation_weight: 0
```

The `navigation_weight` represents the position of the document in the document list page.

When done, create a new branch and submit a pull request.

Please contact us at dev@ambraproject.org with any questions, comments, or concerns.
Please use [Github Issues](https://github.com/PLOS/ambraproject/issues) to report any problems, or submit a pull request.