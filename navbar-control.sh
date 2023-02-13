#!/usr/bin/env bash

# purpose: Hide/Show Waydroid navbar
# Will set the following depending on what is detected:
#		qemu.hw.mainkeys=1
#		
# Then it will ask if you are using Waydroid 10 or 11 and
# make the proper anbox.conf changes for you
#
# author: Jon West [electrikjesus@gmail.com]

nb_disabled=""
enable="false"
disable="false"

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "purpose: "
  echo "Hide/Show Waydroid navbar"
  echo "the waydroid_base.prop found in /var/lib/waydroid/"
  echo ""
  echo "This will set the following depending on what is selected:"
  echo "	qemu.hw.mainkeys=1"
  echo ""
  echo "usage:"
  echo "Run the script, answer a few questions, done."
  echo ""
  echo "author: Jon West [electrikjesus@gmail.com]"
  echo ""
  
  exit 0
fi

FILENAME='/var/lib/waydroid/waydroid_base.prop'
I=0
for LN in $(cat $FILENAME)
do
	if [ "$LN" == "qemu.hw.mainkeys=1" ]; then
		echo "navbar disabled :)"
		nb_disabled="true"
	fi
done

# Present Menu
# If navbar is disabled
if [ "$nb_disabled" ]; then
	read -p "Navbar is disabled, do you want to enable it (y/n)?" choice
	case "$choice" in 
	  y|Y ) echo "yes" && enable="true";;
	  n|N ) echo "no";;
	  * ) echo "invalid";;
	esac

# Else, it must be enabled
else
	read -p "Navbar is enabled. Do you want to disable it (y/n)?" choice
	case "$choice" in 
	  y|Y ) echo "yes" && disable="true";;
	  n|N ) echo "no";;
	  * ) echo "invalid";;
	esac
fi
if [ "$enable" == "true" ]; then
  sudo sh -c "sed -i '/qemu.hw.mainkeys=1/d' /var/lib/waydroid/waydroid_base.prop" && echo "All Set. Please restart container to see changes. Thanks for using!" || echo "Process Failed, please try again!"
fi
if [ "$disable" == "true" ]; then
  sudo sh -c "echo 'qemu.hw.mainkeys=1' >> /var/lib/waydroid/waydroid_base.prop" && echo "All Set. Please restart container to see changes. Thanks for using!" || echo "Process Failed, please try again!"
fi


