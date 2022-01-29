#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "purpose: "
  echo "This will connect waydroid to Android Studio"
  echo ""
  echo "usage:"
  echo "Run the script, answer a question, done."
  echo ""
  echo "author: Jon West [electrikjesus@gmail.com]"
  echo ""
  
  exit 0
fi

install_as="false"
HPATH=$HOME

if [ ! -f /opt/android-studio/bin/studio.sh ]; then
read -p "Do you want to download Android Studio and Install it? (y/n)?" choice

case "$choice" in 
  y|Y ) echo "yes"
	install_as="true";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac

if [ "$install_as" == "true" ]; then
	wget -o https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.1.1.20/android-studio-2021.1.1.20-linux.tar.gz $HPATH/Downloads/
	sudo apt-get install lib32z1 lib32ncurses* lib32stdc++6 adb
	cd $HPATH/Downloads
	tar xvzf $HPATH/Downloads/android-studio*.tar.gz -C /tmp
	sudo chown -R root:root /tmp/android-studio
	sudo mv /tmp/android-studio /opt/
	echo "export PATH=~/Android/sdk/platformtools:~/Android/sdk/tools:/opt/android-studio/bin:$PATH" >> $HPATH/.bashrc
	bash

fi

fi

#~ if [ -f /opt/android-studio/bin/studio.sh ]; then
	#~ $PATH/studio.sh
	#~ echo "Android Studio is starting now, please complete setup and launch your project. Then come back here and..."
	#~ read -p "Press enter to continue"
#~ else
	echo "Please start Android Studio and launch your project. Then come back here and..."
	read -p "Press enter to continue"
#~ fi



# - Grab IP: hostname -I | cut -d' ' -f1
get_ip="ip addr show eth0  | grep 'inet ' | cut -d ' ' -f 6 | cut -d / -f 1"
ip=$(echo $get_ip | sudo waydroid shell)
# - connect to AS using ADB

adb_command=$(adb connect $ip:5555)
running="already"
if [[ $adb_command == *"$running"* ]]; then
	echo "$adb_command"
	read -p "Do you want to disconnect ADB (y/n)?" choice
	case "$choice" in 
	  y|Y ) echo "yes" && adb disconnect $ip:5555 ;;
	  n|N ) echo "no";;
	  * ) echo "invalid";;
	esac 
else
	echo "$adb_command"
fi

# Done

