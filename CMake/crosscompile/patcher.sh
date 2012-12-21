#/bin/bash
# args are:
# source directory to patch
# patch directory strip number
# location of patch file to apply

cd $1
patch -Ns $2 < $3

#important to do something with good return code here, echo fits the bill
#because patch may work well enough in some circumstances
echo done
