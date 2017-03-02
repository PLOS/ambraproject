#!/bin/sh

# Execute this script to archive the contents of the `themes/` directory
# and replace the contents of the `themes.tar.gz` archive.
#
# The `themes.tar.gz` file is present in this directory for the end user to
# download. The rest is the source, in case further edits are needed.

tar -cvzf themes.tar.gz themes/
