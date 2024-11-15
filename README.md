# confetch
#### (Formerly bash-showoff-script)
A neat little bash script to make opening a terminal a little more exciting.

<img width="1201" alt="Screenshot 2024-07-19 at 17 19 58" src="https://github.com/user-attachments/assets/7b4118a9-5e9d-40c8-b965-79873803ca0d">

![simplescreenrecorder-2024-06-03_12 28 27-ezgif com-video-to-gif-converter(1)](https://github.com/THEWHITEBOY503/bash-showoff-script/assets/28698926/e9a746f4-b6da-4a47-a4f8-32b64642d364)


This script isn't anything terribly special. It's an overcomplicated series of if statements that do these simple tasks:

- Draws 5 colored bars
- Lists some basic info about your computer (IE: Your name, your computer model, the chassis type (which needs to be manually specified as of right now), and the RAM
- Lists the date and time
- Displays weather and moon info from [wttr.in](https://github.com/chubin/wttr.in)
- Displays [fastfetch](https://github.com/fastfetch-cli/fastfetch) or any other commands you want to run

This script keeps a copy of the weather report in the config directory. The script checks to see if its been updated in the last 12 hours, and if it hasn't, it grabs a new copy. This way your weather report sort of stays cached for if you go offline for a bit. 

## Setup
Until I can get the packages distributed to package managers, you can download the package file and install it manually.
At the time of writing, only a Debian/Ubuntu package (.deb) is published. You can install it with:
```bash
sudo apt install ./confetch_1.0-8_all.deb
```
<sub>If you'd like to use the shell script instead, try giving our `bashscript` branch a view!</sub>

Once installed, you can run `confetch` to start! On first run, you'll be greeted with a screen that tells you that confetch will use an API to grab your city name from your IP Geolocation. You are given the choice to consent to this, and if you do not consent, you can manually specify a city, or simply respond with `null` to disable the weather.

## Automation
To run the script every time you open a terminal, simply put `confetch` at the bottom of your `.bashrc` file. If that doesn't work, you can try specifying the full path: `/usr/bin/confetch_bin/start.sh`

## Customization
For infomation on how to change the variables and make it your own, [you can check out our GitHub Wiki through this link](https://github.com/THEWHITEBOY503/bash-showoff-script/wiki/Customizing-bash%E2%80%90showoff%E2%80%90script), or by clicking "Wiki" at the top of this page.

## To-do
- ~~Make the script not attempt to replace the weather files if not connected to the internet~~ (Fixed: Revision 5)
- ~~Automatically grab the user's name from the system~~ (Fixed: Revision 5)
- Figure out how to display other commands side by side (Eg: Displaying `fastfetch` and `fortune | cowsay` next to each other)
  - I tried using the same method I use for wtr and moon, but it came out terribly.
- ~~Re-download the files if the size = 0 (failed download)~~ (Fixed: Revision 8)
- ~~Automatically make sure curl is installed~~ (Fixed: Revision 7)
- Better macOS support
  - Color bars don't work
  - curl needs different syntax to work (Switch to this syntax for all distros?)
- ~~Automatically grab distro info~~ (Fixed: Revision 8)
- Update config file with update
- Run cURL asyncronously
    - Maybe it's time to switch to wget?
- Make file grab time out to keep terminal opening process short

## Tips & tricks!

If you have `lolcat` installed, try piping the output through lolcat!
![image](https://github.com/user-attachments/assets/644e05c7-b545-43f1-aa35-9a0484915b89)
