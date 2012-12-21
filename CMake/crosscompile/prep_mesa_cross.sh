#/bin/bash
#This script configures the target platform's osmesa-config into place in
#in the mesa source tree
#args are:
#$1 mesa source directory
#$2 base config file to configure
#$3 target platform name
#$4 mesa install directory
echo $1 $2 $3 $4
echo cd $1
cd $1
cp $2 configs/$3
sed -i.original -e 's|linux-osmesa-static|'$3'|g' Makefile
sed -i.original -e 's|INSTALL_DIR = /usr/local|INSTALL_DIR = '$4'|g' configs/default
