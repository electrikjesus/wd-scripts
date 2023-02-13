#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "purpose: "
  echo "This will add Smart-Dock (Alternative Desktop Mode) to Waydroid"
  echo ""
  echo "usage:"
  echo "Run the script, answer a question, done."
  echo ""
  echo "author: Jon West [electrikjesus@gmail.com]"
  echo ""
  
  exit 0
fi
PJFOLDER=$PWD
echo -e $PJFOLDER
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo -e "SCRIPTPATH: $SCRIPTPATH"
HPATH=$HOME
echo -e "HOME: $HPATH"
FILEPATH="system/priv-app/SmartDock"
SYSAPP="SmartDock.apk"
PERMISSIONS="android.permission.ACCESS_COARSE_LOCATION
android.permission.ACCESS_FINE_LOCATION
android.permission.RECEIVE_BOOT_COMPLETED
android.permission.VIBRATE
android.permission.ACCESS_WIFI_STATE
android.permission.CHANGE_WIFI_STATE
android.permission.ACCESS_LOCATION_EXTRA_COMMANDS
android.permission.BLUETOOTH
android.permission.BLUETOOTH_ADMIN
android.permission.CALL_PHONE
android.permission.CAMERA
android.permission.DISABLE_KEYGUARD
android.permission.FLASHLIGHT
android.permission.GET_TASKS
android.permission.KILL_BACKGROUND_PROCESSES
android.permission.MODIFY_AUDIO_SETTINGS
android.permission.PROCESS_OUTGOING_CALLS
android.permission.READ_CALENDAR
android.permission.READ_CONTACTS
android.permission.READ_PHONE_STATE
android.permission.READ_SYNC_SETTINGS
android.permission.READ_SYNC_STATS
android.permission.RECEIVE_SMS
android.permission.RECORD_AUDIO
android.permission.SEND_SMS
android.permission.SET_WALLPAPER
android.permission.USE_CREDENTIALS
android.permission.WAKE_LOCK
android.permission.WRITE_CALENDAR
android.permission.WRITE_CONTACTS
android.permission.WRITE_EXTERNAL_STORAGE
android.permission.WRITE_SYNC_SETTINGS
android.permission.ACCESS_NETWORK_STATE
android.permission.CHANGE_NETWORK_STATE
android.permission.INTERNET
android.permission.NFC
android.permission.GET_ACCOUNTS
android.permission.READ_CALL_LOG
android.permission.WRITE_CALL_LOG
android.permission.BROADCAST_STICKY
android.permission.ACCESS_NOTIFICATION_POLICY
android.permission.ACCESS_NOTIFICATIONS
android.permission.ANSWER_PHONE_CALLS
android.permission.USE_FINGERPRINT
android.permission.USE_BIOMETRIC
android.permission.FOREGROUND_SERVICE
android.permission.WRITE_SECURE_SETTINGS
android.permission.ACTIVITY_RECOGNITION
android.permission.READ_EXTERNAL_STORAGE
android.permission.WRITE_EXTERNAL_STORAGE
android.permission.ACCESS_BACKGROUND_LOCATION
android.permission.INSTANT_APP_FOREGROUND_SERVICE
android.permission.ACCESS_MEDIA_LOCATION
android.permission.WRITE_SETTINGS
android.permission.SYSTEM_ALERT_WINDOW
android.permission.BIND_ACCESSIBILITY_SERVICE
android.permission.WRITE_SECURE_SETTINGS
android.permission.CHANGE_CONFIGURATION
android.permission.READ_LOGS
android.permission.DUMP"

# - Show menu

read -p "Do you want to install Smart-Dock to Waydroid (y/n)?" choice
case "$choice" in 
  y|Y ) echo "yes" && install="true";;
  n|N ) echo "no" && echo "OK. You're the boss";;
  * ) echo "invalid";;
esac

if [ "$install" == "true" ]; then
	sudo systemctl stop waydroid-container.service
	sudo e2fsck -f /var/lib/waydroid/images/system.img
	sudo resize2fs /var/lib/waydroid/images/system.img 2G
	sudo mount -o loop /var/lib/waydroid/images/system.img /mnt

	for i in $SYSAPP ; do
		sudo rm -rf /mnt/$FILEPATH
		sudo mkdir -p /mnt/$FILEPATH
		sudo cp $SCRIPTPATH/assets/$SYSAPP /mnt/$FILEPATH
		ls -a /mnt/$FILEPATH
		sudo chmod 644 /mnt/$FILEPATH/
		sudo chown root:root /mnt/$FILEPATH
	done

	sudo umount /mnt
	sudo systemctl restart waydroid-container.service
	#~ waydroid session start &
	read -p "Start waydroid service in a separate terminal and once running, come back here and press return"
	sleep 20
	waydroid app install $SCRIPTPATH/assets/$SYSAPP
	
	
	#~ sudo waydroid app remove cu.axel.smartdock
	
	for p in $PERMISSIONS ; do
#		echo "pm grant cu.axel.smartdock $p" | sudo -S waydroid shell 2> /dev/null
		echo "pm grant cu.axel.smartdock $p" | sudo -S waydroid shell
	done
	
	echo "settings put secure enabled_notification_listeners %nlisteners:cu.axel.smartdock/cu.axel.smartdock.service.ServiceNotificationIntercept" | sudo -S waydroid shell
	
	echo "settings put secure enabled_notification_listeners %nlisteners:cu.axel.smartdock/cu.axel.smartdock.service.CallNotificationListener" | sudo -S waydroid shell
	echo "settings put secure enabled_accessibility_services cu.axel.smartdock/cu.axel.smartdock.AccessibilityService" | sudo -S waydroid shell
	echo "settings put secure accessibility_enabled 1" | sudo -S waydroid shell
	
	#~ cd $PJFOLDER
	echo "All set. You need to restart container to verify things worked"
fi

