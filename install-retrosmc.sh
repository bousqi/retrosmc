#!/bin/bash

# This is a script by mcobit to install retrosmc to OSMC.
# I am not responsible for any harm done to your system.
# Using this is on your own risk.
# Script by mcobit

# Version 0.008

# Check if we are root. If so, cancel installation
if [[ $(id -u) -eq 0 ]]; then
    echo "This script should not be run as root. Please run as user $(whoami)!"
    exit 1
fi

# import variables from configfile
source "~/RetroPie/scripts/retrosmc-config.cfg"

# Shut down KODI if it is running
if [[ $(pgrep kodi) ]]; then
  echo "Detected a running instance of KODI. Shutting it down to free memory for installation"
  sudo systemctl stop kodi.service
  sudo systemctl stop mediacenter
fi

# setting up the menu
cmd=(dialog --backtitle "retrosmc installation - Version $CURRENT_VERSION" --menu "Welcome to the retrosmc installation.\nWhat would you like to do?\n " 14 50 16)

options=(1 "Install retrosmc"
         2 "Install Launcher Addon"
         3 "Remove Launcher Addon"
         4 "Update scripts")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
    case $choice in
        1)
            # create the config directory and file
            mkdir -p ~/RetroPie/scripts
            touch "~/RetroPie/scripts/retrosmc-config.cfg"

            # install some programs needed to run the installation and retrosmc
            sudo apt-get update 2>&1 | dialog --title "Updating package database..." --infobox "\nPlease wait...\n" 11 70
            sudo apt-get --show-progress -y install dialog git pv bzip2 psmisc libusb-1.0 alsa-utils 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Installing dialog and pv programs if they are not present" --gauge "\nPlease wait...\n" 11 70

            # download the retrosmc scripts and files
            wget --no-check-certificate -w 4 -O ~/RetroPie/scripts/retropie.sh https://raw.githubusercontent.com/bousqi/retrosmc/master/scripts/retropie.sh
            wget --no-check-certificate -w 4 -O ~/RetroPie/scripts/retropie_watchdog.sh https://raw.githubusercontent.com/bousqi/retrosmc/master/scripts/retropie_watchdog.sh
            wget --no-check-certificate -w 4 -O ~/RetroPie/scripts/kodi.service https://raw.githubusercontent.com/bousqi/retrosmc/master/scripts/kodi.service
            chmod +x ~/RetroPie/scripts/retropie.sh
            chmod +x ~/RetroPie/scripts/retropie_watchdog.sh

            sudo sed "s/\bkodi-user\b/$(whoami)/g" -i ~/RetroPie/scripts/kodi.service
            sudo mv ~/RetroPie/scripts/kodi.service /lib/systemd/system

            # refreshing systemd cache
            sudo systemctl daemon-reload

            # add fix to config.txt for sound
            if [[ ! $(grep "dtparam=audio=on" "/boot/config.txt") ]]; then
              sudo su -c 'echo -e "dtparam=audio=on" >> "/boot/config.txt"'
            fi

            # set the output volume
            amixer set PCM 100

            # clone the retropie git and start the installation
            cd
            git clone https://github.com/RetroPie/RetroPie-Setup.git
            cd ~/RetroPie-Setup
            sudo ./retropie_setup.sh

            # check for the right configuration and existance of the es_input file to ensure joystick autoconfig to work (important on update)
#             if [ ! "$(grep Action ~/.emulationstation/es_input.cfg)" ]; then
#                 mkdir "~/.emulationstation"
#                 cat > "~/.emulationstation/es_input.cfg" << _EOF_
# <?xml version="1.0"?>
# <inputList>
#   <inputAction type="onfinish">
#     <command>/opt/retropie/supplementary/emulationstation/scripts/inputconfiguration.sh</command>
#   </inputAction>
# </inputList>
# _EOF_
#             fi

            # end installation
            dialog --title "FINISHED!" --msgbox "\nEnjoy your retrosmc installation!\nPress OK to return to the menu.\n" 11 70

            # restart script
            exec ~/install-retrosmc.sh
            ;;

        2)
            # get the addon archive file from github
            wget --no-check-certificate -w 4 -O plugin.program.retrosmc-launcher-0.0.3.tgz https://github.com/bousqi/retrosmc/raw/master/plugin.program.retrosmc-launcher-0.0.3.tgz 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading Addon" --gauge "\nPlease wait...\n"  11 70

            # extract the addon to the kodi addon directory
            if [[ -d ~/.kodi/addons/plugin.program.retropie-launcher ]]; then
              rm -r ~/.kodi/addons/plugin.program.retropie-launcher
            fi
            (pv -n plugin.program.retrosmc-launcher-0.0.3.tgz | sudo tar xzf - -C ~/.kodi/addons/ ) 2>&1 | dialog --title "Extracting Addon" --gauge "\nPlease wait...\n" 11 70
            dialog --backtitle "RetroPie-OSMC setup script" --title "Installing Addon" --msgbox "\nAddon installed.\n" 11 70

            # remove archive file
            rm plugin.program.retrosmc-launcher-0.0.3.tgz

            # restart script
            exec ~/install-retrosmc.sh
            ;;

        3)
            # delete the addon from kodi addon directory
            if [[ -d ~/.kodi/addons/plugin.program.retrosmc-launcher ]]; then
              rm -r ~/.kodi/addons/plugin.program.retrosmc-launcher
            fi
            if [[ -d ~/.kodi/addons/plugin.program.retropie-launcher ]]; then
             rm -r ~/.kodi/addons/plugin.program.retropie-launcher
            fi
            dialog --backtitle "RetroPie-OSMC setup script" --title "Removing Addon" --msgbox "\nAddon removed.\n" 11 70

            # restart script
            exec ~/install-retrosmc.sh
            ;;

        4)
            # download new versions of all scripts and make them executable
            wget --no-check-certificate -w 4 -O ~/RetroPie/scripts/retropie.sh.1 https://raw.githubusercontent.com/bousqi/retrosmc/master/scripts/retropie.sh
            wget --no-check-certificate -w 4 -O ~/RetroPie/scripts/retropie_watchdog.sh.1 https://raw.githubusercontent.com/bousqi/retrosmc/master/scripts/retropie_watchdog.sh
            wget --no-check-certificate -w 4 -O ~/install-retrosmc.sh.1 https://raw.githubusercontent.com/bousqi/retrosmc/master/install-retrosmc.sh
            chmod +x ~/RetroPie/scripts/retropie.sh.1
            chmod +x ~/RetroPie/scripts/retropie_watchdog.sh.1
            chmod +x ~/install-retrosmc.sh.1

            # replace old with new scripts
            mv ~/install-retrosmc.sh.1 ~/install-retrosmc.sh
            mv ~/RetroPie/scripts/retropie.sh.1 ~/RetroPie/scripts/retropie.sh
            mv ~/RetroPie/scripts/retropie_watchdog.sh.1 ~/RetroPie/scripts/retropie_watchdog.sh

            # restart script
            exec ~/install-retrosmc.sh
            ;;
    esac
done

sudo systemctl restart kodi.service
