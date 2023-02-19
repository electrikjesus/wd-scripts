#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "purpose: "
  echo "This will add microG, Aurora Store & Aurora Droid to Waydroid"
  echo ""
  echo "usage:"
  echo "Run the script, answer a question, done."
  echo ""
  echo "author: Jon West [electrikjesus@gmail.com]"
  echo ""
  
  exit 0
fi
PJFOLDER=$PWD
install="false"
HPATH=$HOME
# - Show menu
if command -v xmlstarlet >/dev/null 2>&1 ; then
    echo "xmlstarlet found"
else
    echo "xmlstarlet not found, installing"
    sudo apt install xmlstarlet
fi
if command -v aapt >/dev/null 2>&1 ; then
    echo "aapt found"
else
    echo "aapt not found, installing"
    sudo apt install aapt
fi

read -p "Do you want to install FOSS apps to Waydroid (y/n)?" choice
case "$choice" in 
  y|Y ) echo "yes" && install="true";;
  n|N ) echo "no" && echo "OK. You're the boss";;
  * ) echo "invalid";;
esac

if [ "$install" == "true" ]; then
	rm -rf $HPATH/.cache/wd-scripts/
	mkdir $HPATH/.cache/wd-scripts/
	cd $HPATH/.cache/wd-scripts/
	git clone https://github.com/BlissRoms-x86/vendor_foss foss
	cd $HPATH/.cache/wd-scripts/foss/
	bash update.sh
	shopt -s globstar
	for f in bin/*.apk bin/**/*.apk ; do
		waydroid app install $f
	done
	cd $PJFOLDER
	echo "All set. No need to restart container, just verify things worked"
fi

