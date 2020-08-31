#!/bin/bash

# Diablo II LoD Startup, choose char and act, backup script.
# Made by CharlieK in 2020
# Thanks for Johnny5WD for pointing out I should not hardcode paths as well as him pushing me in proper coding.
# This is my first real script.

# Finding the .d2s Savegame files.
d2s=($(find $HOME -type f -name "*.d2s" ! -path "*/test/*" ! -path "*/Diablo II/*" ! -path "*/Documents/*" ! -path "*/Trash/*" -printf "%f\n" | sort -u | xargs -0) )
# Finding the personal savegame folder (this is NOT the official folder).
d2p=$(find $HOME -type d -name "d2sav" ! -path "*/Diablo II/*" ! -path "*/Documents/*" ! -path "*/Trash/*")

# Finding the official Save Games folder.
savegame=$(find $HOME -type d -name "Diablo II" ! -path "*/ProgramData/*" ! -path "*/Trash/*" ! -path "*/Documents/*")

# Finding the Documents folder in $HOME.
dox=$(find $HOME -type d -name "Documents" ! -path "*/Trash/*" ! -path "*/.wine/*" ! -path "*/GOG.com/*")

# The only hardcoded location: The backup folder of Diablo II LoD.
gdrive="gdrive:path/to/savefolder/$(date +%Y%m%d_%H%M%S)_$USER"

# finding the executable. (note I don't use Game.exe as many games could use this).
# Note that Diablo II.exe actually runs Game.exe by default.
game=$(find $HOME -name "Diablo II.exe")

# Select Savegame File prompt
prompt="Please select a file: "

# This script will look for any savegames I put in d2sav.
# It will then list the files for you to choose.
# Upon selecting a number, it will MOVE the character from my personal savegame folder to the official savegame folder.
# Basically if you have more than 15 characters, the list inside the Select Character Menu will get eerily Long.
# I wrote/researched this based on an idea of Johnny5WD.
PS3="$prompt"
select option in "${d2s[@]}"; do
    if (( REPLY == 1 + ${#d2s[@]} )) ; then
        exit
    elif (( REPLY > 0 && REPLY <= ${#d2s[@]} )) ; then
        printf "You picked $option\n"
	mv "$d2p/""${option%%.*}".* "$savegame/"
        break
    else
        echo "Invalid option. Try another one."
    fi
done

clear
# The next line let's you choose which act you want to start in.
read -p "Act 1 - 5: " act

# Let's now run the game with the parameters I find most agreeable to my situation.
wine "$game" -act"$act" -vsync -800 -nosound

# sleep 2 is done to give the script some time.
# Without it, it will run to the backup process before Game.exe is loaded.
sleep 2

# We will now look whether Game.exe is running (Diablo II.exe runs Game.exe, so now it's good to look at it)
# If Game.exe is running, check again in 5 seconds.
# If the process ends, go to the next part of the script.
while true
do
    if [[ -z "$(pgrep -a wine | pgrep -i Game.exe | awk '{print $1}')" ]];
    then
        break
    else
        sleep 5
    fi
done
clear

# Move all files back to your personal save folder and remove any Atma .org file.
mv "$savegame/"*.* "$d2p/"
rm -f "$d2s"*.org
rm -f "$d2p"*.org

# Check for internet connection and backup accordingly
# If connected: Backup to Gdrive
# If not connected: Backup to ~/Documents/[YYYYmmdd_HHMMSS_username]
echo "Checking Internet Status: "
wget -q --tries=5 --timeout=10 --spider storin.nl > /dev/null 2>&1
	if [[ $? -eq 0 ]]; then
		clear
		echo "Status is online. Backing up to gdrive"
		rclone --config ~/.config/rclone/rclone.conf copy "$d2p" "$gdrive"
	else
		clear
		echo "Status is offline: Now backing up savegames to Documents"
		cp -r "$d2p" "$dox/$(date +%Y%m%d_%H%M%S)_$USER"
fi
