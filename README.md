# HelpDesk PowerShell Scripts
Welcome!

This repo serves as a list of things I've been working on for my specific environment. This will be updated shortly as I begin to export the majority of the stuff I've been working on to non-domain specific standards. 

# The scripts and some more information...
Reload-Shell.ps1 is from my pure laziness. I can't be bothered to reopen a new shell, get prompted by UAC for credentials, put in the credentials, wait for everything to load, get prompted again yada yada yada. Reload-Shell will do exactly what it sounds like, it starts a new shell then closes the current one. 

Show-LoggedonUser leverages QUser to pull the currently logged in user on a machine. It will also display whether the user is actively using the machine, and what time they last logged in. The ID column can then be used with Remote-Logoff to kick the user off remotely.

WhatIs is a data gathering function. It can be modified to be used with a database to log information about a specific computer, or it can be used to quickly identify what a computer is. It'll bring back BIOS, Computer make/model, Serial, Logged in user as well as monitor information. 

ModelExport is a fun way to log information from network available AD computer objects. It will grab all the information that WhatIs grabs but export it into a CSV file, then sort the CSV file for easy viewing. If computers cannot be contacted, it'll wait 15 seconds before retrying. In the future I may adapt it to launch its own window as to not take over the current terminal, but we'll see. 

Still working on some other things, but will be updating this as I remember to...
