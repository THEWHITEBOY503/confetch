# bash-showoff-script
A neat little bash script to make opening a terminal a little more exciting.

![simplescreenrecorder-2024-06-03_12 28 27-ezgif com-video-to-gif-converter(1)](https://github.com/THEWHITEBOY503/bash-showoff-script/assets/28698926/e9a746f4-b6da-4a47-a4f8-32b64642d364)
![image](https://github.com/THEWHITEBOY503/bash-showoff-script/assets/28698926/482bc92d-5653-426a-98c9-01dc581885ff)

This script isn't anything terribly special. It:

- Draws 5 colored bars
- Lists some basic info about your computer (which can be easily changed by modifying the variables at the start of the script), including grabbing the amount of megabytes of RAM your system has
- Lists the date and time
- Displays weather and moon info from [wttr.in](https://github.com/chubin/wttr.in)
- Displays [fastfetch](https://github.com/fastfetch-cli/fastfetch) or any other commands you want to run

This script keeps a copy of the weather report in a specified directory, indicated by the $wtr_path and $moon_path variables. The script checks to see if its been updated in the last 12 hours, and if it hasn't it grabs a new copy. This way your weather report sort of stays cached for if you go offline for a bit. 

## Setup
You'll need cURL for this script to work. Install it how you normally would. (For Deb/Ubuntu this is `sudo apt install curl`)

To setup the script, simply download `start.sh`, then give it executable permissions with `chmod +x start.sh`. Open up the file and modify the variables to fit your setup. If nothing else, make sure you change `$wtr_path` and `$moon_path` so the program knows where to look.
I like making a folder in my home directory called `.scripts` to house the start script and weather files. So, in that case, `$wtr_path` would be `/home/conner/.scripts/wtr` and `$moon_path` would be `/home/conner/.scripts/moon`. Don't worry about needing to create these files beforehand, the script will automatically create them. 

You can also modify the operands for wttr.in to make your weather report look different. [Refer to wttr.in's help page.](https://wttr.in/:help)

## Automation
To run the script every time you open a terminal, simply point to the file at the bottom of your `.bashrc` file. For example, if I keep my script in /home/conner/.scripts/start.sh:

```
(.bashrc)

(...)
/home/conner/.scripts/start.sh
```

## To-do
- Make the script not attempt to replace the weather files if not connected to the internet
- Automatically grab the user's name from the system
- Figure out how to display other commands side by side (Eg: Displaying `fastfetch` and `fortune | cowsay` next to each other)
