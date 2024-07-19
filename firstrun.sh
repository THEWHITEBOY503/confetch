#!/bin/bash

clear
center_text() {
    local text="$1"
    local term_width
    term_width=$(tput cols)  # Get the width of the terminal

    # Calculate padding
    local padding=$(( (term_width - ${#text}) / 2 ))

    # Print spaces to center the text
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}
# Function to print bold centered text
center_bold_text() {
    local text="$1"
    local term_width
    term_width=$(tput cols)  # Get the width of the terminal

    # Calculate padding
    local padding=$(( (term_width - ${#text}) / 2 ))

    # Print spaces to center the text
    printf "%*s\033[1m%s\033[0m%*s\n" $padding "" "$text" $padding ""
}

prompt_yes_no() {
    local prompt_message="$1"
    local user_input

    while true; do
        read -p "$prompt_message (y/n): " user_input
        case "$user_input" in
            [Yy]* ) return 0;;  # Return 0 for Yes
            [Nn]* ) return 1;;  # Return 1 for No
            * ) echo "Please answer Y or n.";;
        esac
    done
}
CONFIG_DIR="$HOME/.config/confetch"
CONFIG_FILE="$CONFIG_DIR/config.txt"
mkdir -p "$CONFIG_DIR"
# Generate example config file
if [ ! -f "$CONFIG_FILE" ]; then
    cat <<EOL > "$CONFIG_FILE"
# Missing something? It's not recommended, but you can modify the executable, since it's just bash.
# sudo nano /usr/bin/confetch_bin/start.sh
# (or whatever your text editor of choice is)

### --- Username Selection ---
### Grabs your username from Bash $USER variable
### Example UNIX username: conner
### USERGRAB=1 to capitalize the first letter. Output: Conner
### USERGRAB=2 to keep the username as it is. Output: conner
### Add quotation marks to manually specify a name. Output: HamBurger

USERGRAB=1

DEVICE="Laptop"

### ---Distro Selection ---
### If you set DISTRO=true, it will grab your distro name using /etc/issue
### Otherwise, if you set it to a string (eg: `DISTRO="Ubuntu Linux"`), the distro value on the output will be whatever your string is.
### If you set ISLINUX=true, it appends "Linux" to your distro name.
### Example 1: ISLINUX=true DISTRO=true   Output: Ubuntu Linux
### Example 2: ISLINUX=true DISTRO="Hamburger"    Output: Hamburger Linux
### Example 3: ISLINUX=false DISTRO=true    Output: Ubuntu

ISLINUX=true
DISTRO=true

### --- Model Selection ---
### Grabs your hardware name
### Example: Latitude 7490, Parallels ARM Virtual Machine, etc
### If set to 'true' (no quotations), it will grab the model name from /sys/devices/virtual/dmi/id/product_name
### To set the value manually, simply encase it in quotation marks, "like this".

MODEL=true

### --- Weather Settings ---
### To choose operands for wttr.in, visit https://wttr.in/:help

WTROPTIONS="2FnQ"
MOONOPTIONS="F"
## If true, weather and moon display side by side. If false, weather displays above moon.
WTRSIDE=true

### --- RAM Display ---
## If you'd like to lie- I mean, manually specify your RAM count, simply set RAM="123456M" or RAM="16G" or whatever
RAM=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))"M"

### --- Animation settings ---

ANIMATE=true
## Seconds between drawing frames for animation.
SLEEP=0.05


# To set which commands appear after the weather, add these commands in commands.txt
# Sorry if you were expecting to add them here. :(
EOL
fi

center_bold_text "Welcome to confetch!"
echo
echo "It seems like this is your first time running this program. (At least, this user's first time.)"
echo
center_bold_text "Config files will be created at $HOME/.config/confetch."
echo
echo "In that directory, .config will have all of the variables to configure confetch. If you want to make your own commands run after the weather output, put them in commands.txt."
echo
echo
echo "This program has a feature that uses your Geolocation via your IP address to determine your city, for weather purposes. If you do not consent to this, you will be prompted to enter your city manually. Entering null will disable weather."
echo "This program nor its developers do not collect or share your IP or city with anyone but the APIs used for this info."
echo "For more information, please visit <placeholder>."
echo
center_bold_text "If at any point you'd like to reset your consent settings, run 'rm $HOME/.config/confetch/consent'"
center_bold_text "By selecting yes or no, you've verified that you've read this messsage."
if prompt_yes_no "Do you consent to having your city name extracted from your IP?"; then
    echo "True"
    echo "CONSENT=true" > $CONFIG_DIR/consent
else
    read -p "Okay, please manually specify your city: " user_input
    if [ $user_input = "null" ] ; then
        echo "Entering null will disable weather. If you do this, you'll have to reset your config using the command above. Continuing in 5 seconds..."
        sleep 5
    fi
    echo "CITY=$user_input" >> "$CONFIG_FILE"
    echo "CONSENT=false" > $CONFIG_DIR/consent
fi
echo "" > $CONFIG_DIR/commands.txt
