#!/bin/bash
# These are placeholders (ie these are what I used when making this), so replace these with your own machine specs.
USER="Conner"
DEVICE="MacBook"
DISTRO="Ubuntu Linux"
MODEL="MacBook Pro 13-inch (Early 2015)"
# Automatically grab the amount of megabytes of RAM. If you'd like to lie-- I mean manually specify the amount of RAM, comment this line and uncomment the one below it.
RAM=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))"M"
#RAM="32036M"
CITY="Dallas"

# Path to where you want to keep the wtr and moon files
wtr_path="/home/conner/.scripts/wtr"
moon_path="/home/conner/.scripts/moon"

# This part creates the color bars. Feel free to change the numbers, this is your software now :)
clear
echo -e "\e[101m          \e[0m"
sleep 0.03
clear
echo -e "\e[101m          \e[0m"
echo -e "\e[103m        \e[0m"
sleep 0.03
clear
echo -e "\e[101m          \e[0m"
echo -e "\e[103m        \e[0m"
echo -e "\e[102m      \e[0m"
sleep 0.03
clear
echo -e "\e[101m          \e[0m"
echo -e "\e[103m        \e[0m"
echo -e "\e[102m      \e[0m"
echo -e "\e[106m    \e[0m"
sleep 0.03
clear
echo -e "\e[101m          \e[0m"
echo -e "\e[103m        \e[0m"
echo -e "\e[102m      \e[0m"
echo -e "\e[106m    \e[0m"
echo -e "\e[105m  \e[0m"
sleep 0.03
clear
echo -e "\e[101m          \e[0m   $USER's $DEVICE"
echo -e "\e[103m        \e[0m   "
echo -e "\e[102m      \e[0m   "
echo -e "\e[106m    \e[0m   "
echo -e "\e[105m  \e[0m   "
sleep 0.03
clear
echo -e "\e[101m          \e[0m   $USER's $DEVICE"
echo -e "\e[103m        \e[0m     $DISTRO"
echo -e "\e[102m      \e[0m   "
echo -e "\e[106m    \e[0m   "
echo -e "\e[105m  \e[0m   "

sleep 0.03
clear
echo -e "\e[101m          \e[0m   $USER's $DEVICE"
echo -e "\e[103m        \e[0m     $DISTRO"
echo -e "\e[102m      \e[0m       "
echo -e "\e[106m    \e[0m         $MODEL"
echo -e "\e[105m  \e[0m           $RAM OK"

echo "Hello, $USER."
echo
TODAY=$(date +"Today's date is %A, %B %d %Y.")
TIMENOW=$(date +"The local time is %r")
echo $TODAY
echo $TIMENOW
echo

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
        curl -s wttr.in/$CITY?2FnQ > wtr
        curl -s wttr.in/moon?F > moon
    else
        # The file's already new enough, so we don't need to download an updated version.
        # Remove the &>/dev/null if you want it to log on the splash screen (for whatever reason)
        echo "File is already new." &>/dev/null
    fi
else
    # File not found, so downloading the file.
    # Remove the &>/dev/null if you want it to log on the splash screen (for whatever reason)
    echo "Downloading new moon and wtr files" &>/dev/null
    curl -s wttr.in/$CITY?2FnQ > $wtr_path
    curl -s wttr.in/moon?F > $moon_path
fi
echo "Here's the weather in $CITY:"
# Display the content of the files side by side
# If you'd rather they display on top of each other, comment out this line and uncomment the two lines below it
paste $wtr_path $moon_path | column -s $'\t' -t
# cat $wtr_path
# cat $moon_path

# Calculate the time since last update in hours
hours=$(( (current_time - modification_time) / 60 / 60))
# This statement decides whether to say 'hour' or 'hours'
if [ $hours = 1 ]; then
    echo "Last updated: $hours hour ago"
else
    echo "Last updated: $hours hours ago"
fi

# Put whatever other commands you want to run here.
# neofetch
fastfetch
