# diablo2lod
This is my Diablo II LoD Char Select, Startup, backup script working in bash (Linux)

# Explanation
This script seems complicated to just start a simple game in wine.
But then comes the issue of when you have over 50 characters in the game, it makes searching for a char difficult.

# What it does
Basically it starts with NOT having your savegames in the "Diablo II" save game folder (in Windows it's in users/Saved Games/Diablo II/)

What I did was MOVE the save game files into a newly created folder called d2sav inside Saved Games. Yes, I moved the OUT of the official Save Games Folder.

Why, you ask?

Next step. If you have to search through fifty characters in the game char selection menu, things could get awkward. So what I do is to find the save files and create a menu.
You select a character and it MOVES the character to the official Save Game folder and it asks the next question.
Which act do you want to start in? I usually go for act5
It starts the game now and you'll see only your selected character in the game. Select and Play. (feel free to make a new character)

While the game runs, it will check whether Game.exe is running in the processes.
When the game ends, there will be several things happening.

1) It will move the files in the official Save Game folder back to the selfcreated Save Game folder.

2) It will remove the .org files made with Atma (I like to make the best chars and yes, I use the gear I exported, call it a cheat :P)

3) It them looks whether you are connected to the internet.

4.1) If NO, it makes a copy of your savegames folder to ~/Documents/[YYYYmmdd_HHMMSS_username]

4.2) If YES, it makes a backup using rclone of all the savegames in gdrive.

# Notes
I installed rclone as it did exactly what I wanted and I have a gdrive account.
RClone can access about all webdrives, so change the script accordingly.
