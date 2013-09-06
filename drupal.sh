#!/bin/sh

# Drupal Install Script
# Jason 09/05/2013

web='/var/www/'
tmp='/var/www/temp/'
ver='7.23'
if [ $1 ]; then
  ver=`echo $1`
fi
if [ -d ${web}drupal-${ver} ]; then
  echo Drupal version ${ver} already installed
  exit 1
fi

cd $tmp
wget http://ftp.drupal.org/files/projects/drupal-${ver}.tar.gz
tar -zxvf drupal-${ver}.tar.gz
if [ $? -ne 0 ]; then
  exit 1
fi
rm -f ${tmp}drupal-${ver}.tar.gz
echo download complete
mv drupal-${ver} ${web}
cd ${web}
if [ -d ${web}drupal ]; then
  echo Removing symbolic link
  rm -f ${web}drupal
fi
ln -s drupal-${ver} drupal
if [ $? -ne 0 ]; then
  echo Failed to dynamically link drupal
  exit 1
fi
if [ ! -d ${web}drupal ]; then
  echo Symblic link failed, but command did not produce an error
  echo Please investigate
  exit 1
fi
echo Drupal ${ver} install is completed
if [ ! -d ${web}drupal/sites/default/files ]; then
  mkdir ${web}drupal/sites/default/files
  if [ $? -ne 0 ]; then
    echo The default files directory is missing
    echo Please investigate
  else 
    chmod 777 ${web}drupal/sites/default/files
  fi
fi
