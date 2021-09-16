#!/bin/bash

###################################################################
# Script for check new version of Element from github
# and download new version, if update is avaiable
#
# https://gist.github.com/MurzNN/ee64f98ab2e71b886c41d55594e5dd9e
#
###################################################################

# Directory where Element files must be placed
DIRECTORY_INSTALL=~/public_html
# Directory for temp files - must be different than install directory!
DIRECTORY_TMP=/tmp

VERSION_URL=https://api.github.com/repos/vector-im/element-web/releases/latest

command -v curl >/dev/null 2>&1 || { echo "You need to install "curl" package for this script: sudo apt install curl"; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "You need to install "tar" package for this script: sudo apt install tar"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "You need to install "jq" package for this script: sudo apt install jq"; exit 1; }

VERSION_INSTALLED=`cat $DIRECTORY_INSTALL/version`
VERSION_LATEST=`curl -s $VERSION_URL | jq -r '.name' | sed s/v//` || { echo "Error checking last Element version!"; exit 1; }

if ( [[ -z "$VERSION_LATEST" ]] || [ "$VERSION_LATEST" == "null" ] ); then
  echo "Error! Received bad version number from $VERSION_URL: $VERSION_LATEST"
  exit
fi

if ( [ "$VERSION_INSTALLED" != "$VERSION_LATEST" ] ); then
  echo "Element installed version is $VERSION_INSTALLED, in GitHub releases found fresher version: $VERSION_LATEST - updating..."
  DL_URL=`curl -s $VERSION_URL | jq -r '.assets[0].browser_download_url'`
  curl -L -o $DIRECTORY_TMP/element-latest.tar.gz $DL_URL || { echo "Error downloading element-latest.tar.gz"; exit 1; }
  mkdir $DIRECTORY_TMP/element-latest/
  tar -xf $DIRECTORY_TMP/element-latest.tar.gz --strip 1 -C $DIRECTORY_TMP/element-latest/
  find $DIRECTORY_INSTALL/* -not -name 'config*.json' -delete
  rm -f $DIRECTORY_INSTALL/config.sample.json
  mv $DIRECTORY_TMP/element-latest/* $DIRECTORY_INSTALL/
  rm -rf $DIRECTORY_TMP/element-latest
  rm $DIRECTORY_TMP/element-latest.tar.gz
  echo "Element succesfully updated from $VERSION_INSTALLED to $VERSION_LATEST";
else
  echo "Installed Element version $VERSION_INSTALLED, last is $VERSION_LATEST - no update found, exiting.";
fi
