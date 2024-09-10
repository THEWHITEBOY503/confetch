#!/bin/bash
# Hello :) Welcome to my cool showoff script
# Revision: 8-1
FILES=$HOME/.config/confetch
# Configure your options here. These are the options I used on my laptop, provided as an example/placeholder.
if [ -e $HOME/.config/confetch/consent ] ; then
    echo "Consent File found" &> /dev/null
    CONSENT=true
else
    CONSENT=false
    echo "No consent file found." &> /dev/null
    source /usr/bin/confetch_bin/firstrun.sh
fi
source ~/.config/confetch/config.txt


if [ $USERGRAB = 1 ]; then
    tUSER="$(tr '[:lower:]' '[:upper:]' <<< ${USER:0:1})${USER:1}"
elif [ $USERGRAB = 2 ]; then
    tUSER=$USER
else
    tUSER=$USERGRAB
fi
if [ $DISTRO = true ] ; then
    tDISTRO=$(cat /etc/issue | awk '{print $1}')
    if [ "$ISLINUX" = true ]; then
        tDISTRO="$tDISTRO Linux"
    fi
else
    tDISTRO=$DISTRO
    # Set this to true or false if you want 'Linux' appended to the end of your script based off of $ISLINUX.
    APPEND=true
    if [ $APPEND = true ] ; then
        if [ $ISLINUX = true ] ; then 
            tDISTRO="$tDISTRO Linux"
        fi
    fi
fi
if [ "$MODEL" = true ] ; then
    if ! cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null; then
        if grep -q -i "Microsoft" /proc/sys/kernel/osrelease || grep -q -i "WSL" /proc/sys/kernel/osrelease; then
            tMODEL="Windows Subsystem for Linux"
        else
            # Failed to grab the model identifier. (Probably running on WSL).
            tMODEL="Computer"
        EF1="Warning: Model grab failed. Defaulting to "Computer"; Set MODEL manually in config.txt to dismiss this message."
        fi
    else
        tMODEL=$(cat /sys/devices/virtual/dmi/id/product_name)
    fi
else
    tMODEL=$MODEL
fi
source $HOME/.config/confetch/consent
if [ $CONSENT = true ] ; then
    ip=$(curl -s https://api.ipify.org)

    # Use ipinfo.io to get location information
    response=$(curl -s https://ipinfo.io/${ip}/json)

    # Extract the city from the JSON response using jq
    CITY=$(echo $response | jq -r '.city')
fi
# Path to where you want to keep the wtr and moon files
wtr_path="$FILES/wtr"
moon_path="$FILES/moon"

if [ $RAM = true ] ; then
    tRAM=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))"M"
else
    tRAM=$RAM
fi

# This part creates the color bars. Feel free to change the numbers for the colors, this is your software now :)
# If ANIMATE is true, this part animates. If not, it just displays the logo. You can also change the sleep time with $SLEEP.
clear
if [ "$ANIMATE" = true ] ; then
    echo -e "\e[101m          \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    echo -e "\e[102m      \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    echo -e "\e[102m      \e[0m"
    echo -e "\e[106m    \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    echo -e "\e[102m      \e[0m"
    echo -e "\e[106m    \e[0m"
    echo -e "\e[105m  \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m   $tUSER's $DEVICE"
    echo -e "\e[103m        \e[0m   "
    echo -e "\e[102m      \e[0m   "
    echo -e "\e[106m    \e[0m   "
    echo -e "\e[105m  \e[0m   "
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m   $tUSER's $DEVICE"
    echo -e "\e[103m        \e[0m     $tDISTRO"
    echo -e "\e[102m      \e[0m   "
    echo -e "\e[106m    \e[0m   "
    echo -e "\e[105m  \e[0m   "
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m   $tUSER's $DEVICE"
    echo -e "\e[103m        \e[0m     $tDISTRO"
    echo -e "\e[102m      \e[0m       "
    echo -e "\e[106m    \e[0m         $tMODEL"
    echo -e "\e[105m  \e[0m           $tRAM OK"
else
    clear
    echo -e "\e[101m          \e[0m   $tUSER's $DEVICE"
    echo -e "\e[103m        \e[0m     $tDISTRO"
    echo -e "\e[102m      \e[0m       "
    echo -e "\e[106m    \e[0m         $tMODEL"
    echo -e "\e[105m  \e[0m           $tRAM OK"
fi

echo "Hello, $tUSER."
echo
echo $TODAY
echo $TIMENOW
# Function to check if the computer is online so it doesn't waste time trying to redownload the weather file
check_online() {
    if ping -c 1 $1 &> /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}
host="wttr.in"
if check_online $host; then
    online=true
else
    online=false
fi

# Checking if the wtr and moon files exist
if [ -e "$wtr_path" ]; then
    # Get the wtr file's modification time in seconds
    modification_time=$(date -r "$wtr_path" "+%s")

    # Get the current time in second
    current_time=$(date "+%s")

    # Calculate the time difference in seconds
    time_difference=$((current_time - modification_time))

    # Check if the file is older than 12 hours (43200 seconds)
    if [ "$time_difference" -gt 43200 ]; then
        # If the time is different, download a new copy of the file
        if [ "$online" = true ]; then
            if [ $CITY = "null" ] ; then
                echo "" > $wtr_path
            else
                curl -s wttr.in/$CITY?$WTROPTIONS > $wtr_path
            fi
            curl -s wttr.in/moon?$MOONOPTIONS > $moon_path
            if [ $CITY = "null" ]; then
                FILE_SIZE=$(stat --format=%s "$moon_path")
            else
                FILE_SIZE=$(stat --format=%s "$wtr_path")
            fi
            # Check if the file size is as expected. If not, the download probably failed, so try one more time.
            if [ "$FILE_SIZE" -lt 1700 ]; then
                if [ $CITY = "null" ]; then
                    curl -s wttr.in/moon?$MOONOPTIONS > $moon_path
                else
                    curl -s wttr.in/$CITY?$WTROPTIONS > $wtr_path
                fi
            fi
        fi
        # Easter egg-- Hello from the dev! Thanks for taking a look at my (shitty) software. <3 -CS
    else
        # The file's already new enough, so we don't need to download an updated version.
        # Remove the &>/dev/null if you want it to log on the splash screen (for whatever reason)
        if [ $CITY = "null" ]; then
            FILE_SIZE=$(stat --format=%s "$moon_path")
        else
            FILE_SIZE=$(stat --format=%s "$wtr_path")
        fi
        if [ "$FILE_SIZE" -lt 1700 ]; then
            if [ "$online" = true ]; then
                if [ $CITY = "null" ]; then
                    curl -s wttr.in/moon?$MOONOPTIONS > $moon_path
                else
                    curl -s wttr.in/$CITY?$WTROPTIONS > $wtr_path
                fi
            fi
        fi
    fi
else
    # File not found, so downloading the file.
    # Remove the &>/dev/null if you want it to log on the splash screen (for whatever reason)
    echo "Downloading new moon and wtr files" &>/dev/null
    if [ "$online" = true ]; then
        if [ $CITY = "null" ] ; then
            echo "" > $wtr_path
        else
            curl -s wttr.in/$CITY?$WTROPTIONS > $wtr_path
        fi
        curl -s wttr.in/moon?$MOONOPTIONS > $moon_path
        if [ $CITY = "null" ]; then
            FILE_SIZE=$(stat --format=%s "$moon_path")
        else
            FILE_SIZE=$(stat --format=%s "$wtr_path")
        fi
        # Check if the file size is as expected. If not, the download probably failed, so try one more time.
        if [ "$FILE_SIZE" -lt 1700 ]; then
            if [ "$online" = true ]; then
                if [ $CITY = "null" ]; then
                    curl -s wttr.in/moon?$MOONOPTIONS > $moon_path
                else
                    curl -s wttr.in/$CITY?$WTROPTIONS > $wtr_path
                fi
            fi
        fi
    fi
fi
echo
if [ -e "$wtr_path" ]; then
    # Calculate the time since last update in hours
    hours=$(( (current_time - modification_time) / 60 / 60))
    # This statement decides whether to say 'hour' or 'hours'
    if [ $hours = 1 ]; then
        LAST="(As of $hours hour ago)"
    else
        LAST="(As of $hours hours ago)"
    fi
    if [ $CITY = "null" ] ; then
        echo "Moon phase: $LAST"
    else
        if [ $hidecity = true ] ; then
            echo "Here's the weather $LAST:"
        else
            echo "Here's the weather in $CITY $LAST:"
        fi
    fi
    # Display the content of the files side by side
    # If you'd rather they display on top of each other, change $WTRSIDE at the top of the file to false
    if [ "$WTRSIDE" = true ]; then
        
        paste $wtr_path $moon_path | column -s $'\t' -t
    else
        cat $wtr_path
        cat $moon_path
    fi
fi
if [ "$EF1" ]; then
    echo $EF1
fi
# Modify this file to execute your own commands
source ~/.config/confetch/commands.txt
