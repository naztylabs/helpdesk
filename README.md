# HelpDesk PowerShell Scripts
Welcome!

This repo serves as a list of things I've been working on for my specific environment. This will be updated shortly as I begin to export the majority of the stuff I've been working on to non-domain specific standards. 

# The scripts and some more information...
Helpdesk.ps1 is a GUI that combines a few different scripts together. I'm working on making this more straightforward by adding a sister file to go along with it. Currently it will load the form, but the buttons will be useless until I get the scripts loaded into another module.

Reload-Shell.ps1 is from my pure laziness. I can't be bothered to reopen a new shell, get prompted by UAC for credentials, put in the credentials, wait for everything to load, get prompted again yada yada yada. Reload-Shell will do exactly what it sounds like, it starts a new shell then closes the current one. 

Say-RemoteText is for friday fun days. This came from a Reddit thread and ever since I saw it there I knew it was destined for my office. Simply give it a computer and a text input and watch as users have a micro-panic attack as their computer comes to life. 

Show-LoggedonUser leverages QUser to pull the currently logged in user on a machine. It will also display whether the user is actively using the machine, and what time they last logged in. The ID column can then be used with Remote-Logoff to kick the user off remotely.

WhatIs is a data gathering function. It can be modified to be used with a database to log information about a specific computer, or it can be used to quickly identify what a computer is. It'll bring back BIOS, Computer make/model, Serial, Logged in user as well as monitor information. Currently, I'm adapting the command to work with Helpdesk.ps1 as a 'Get-Data' button to quickly grab and display information from a machine. 
