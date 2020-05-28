# retrosmc by mcobit (updated by Bousqi)

Easy script to get RetroPie installed alongside KODI on bare raspbian lite

This contains work from the RetroPie project as well as some open source libraries and binaries like SDL1.2/2 etc.
Also this is an **alpha release** right now. So I am not responsible for anything you do with this to your system.

I got something for the brave who want to test it:

Disclaimer and other useful information. _Read **before** installing_!

> First things first: I am NOT responsible if this does any harm to your system! I suggest only to install this on a system that the old installer wasn't run on already. You should have at least 2 GB of free space on your SD card.
>
> Please report bugs and don't expect everything to work. This is now a full RetroPie installation, all scripts and files should be present.
> 
> This will only work on a Raspberry Pi 1, 2 or 3! NOT on the Vero.

## Installation

1. Install KODI on a fresh Raspbian Lite
  `sudo apt install kodi`

2. SSH into your Kodi installation. The default account is `pi` and the password is also `raspberry`.
* Move to the home directory
  `cd /home/pi` and download the installation script
  `wget https://raw.githubusercontent.com/bousqi/retrosmc/master/install-retrosmc.sh
`.
* Make the script executable `chmod +x install-retrosmc.sh`.
* Run the script `./install-retrosmc.sh`.

You will see a pretty self-explanatory menu.
Choose what you want to do and wait for a while.

If you are installing Retrosmc, please choose "Basic Installation" when the RetroPie-Setup menu pops up.
When the Binaries Installation finished, choose "cancel" to return to the Retrosmc menu.

You can exit the menu by choosing "cancel" at the bottom after every task.

If you have installed the "Launcher Addon", after a restart of Kodi, you will find your shortcut in the Program add-ons in Kodi.

## Custom Menu Item

If you want to create a custom menu item, here is a little symbol for you, that I hope, matches the Kodi skin style.
The link should contain the following command:
`System.Exec(/home/osmc/RetroPie/scripts/retropie.sh)`

Have fun!

## Credits

* RetroPie (Took the `rootfs` from the RetroPie project - You folks rock!)
* OSMC (Our beloved platform this is running on - Keep up the good work!)
* `jcnventura3` for the launcher add-on - Just works
* Thanks to all testers
* Thanks to mcobit for the OSMC script
