#!/usr/bin/env bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "purpose: "
  echo "This will enable/disable the Android on-screen keyboard"
  echo ""
  echo "usage:"
  echo "Run the script, answer a question, done."
  echo ""
  echo "author: Jon West [electrikjesus@gmail.com]"
  echo ""
  
  exit 0
fi

state=$(echo "pm list packages -d 2>/dev/null | grep com.android.inputmethod.latin | wc -l" | sudo waydroid shell)

if [ "$state" == 1 ]; then
	kb_state="Disabled"
else
	kb_state="Enabled"
fi
echo "Keyboard is currently: $kb_state"
read -p "Do you want to (1) Enable, or (2) Disable" choice
case "$choice" in 
  1 ) echo "pm enable com.android.inputmethod.latin" | sudo waydroid shell;;
  2 ) echo "pm disable com.android.inputmethod.latin" | sudo waydroid shell;;
  * ) echo "invalid";;
esac



