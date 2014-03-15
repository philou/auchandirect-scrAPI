#!/bin/sh

# --level=inf infinite recursion depth
# --no-clobber don't download the same file many times
# --convert-links convert links to work locally
# --quota 100000k end after 100M downloaded
# --wait=1 downloads fail more often if too aggressive
# -e robots=off ignore no-robots site directive
# --adjust-extension suffix files with .html, otherwise mechanize doesn't parse them
# --restrict-file-names=ascii convert file names so that ruby can read them


wget --recursive --level=inf --no-clobber --convert-links --quota 100000k --exclude-directories=/assets,/static,/apropos,/boutique*,/rayon*,/img --wait=1 --user-agent=Mozilla --domains=auchandirect.fr -e robots=off --adjust-extension --restrict-file-names=ascii 'www.auchandirect.fr'

