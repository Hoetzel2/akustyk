README Akustyk 1.9
==========
# Source Code #
Akustyk is open-source software to be used as an add-on to [Praat](http://praat.org). The source code should work in a very similar way on Windows, Mac OSX, and Linux, though installation is platform-specific.
# Installation #

## Windows ##
On Windows XP or higher, the `akustyk` folder needs to be copied into your home directory. 
You need to uncompress the downloaded archive and copy the directory `akustyk` into your home directory. The user's Windows login name is represented below as `YourLoginName`

Then, you need to move the file `praat-user-startUp` file aout of `akustyk` and into your home directory as well. Open the file with a text editor (e.g., Notepad) and change the value of the variable `platform$` to `winxp` so the line reads: `"platform$ = "winxp"`
### Windows XP ###
The path on Windows XP is: `C:\Documents and Settings\YourLoginName\`
### Windows Vista and 7 ### 
The path on Windows Vista and 7 is: `C:\Users\YourLoginName\`
## Mac OSX ##
Right-click or Command-click on the file: `akustyk_for_mac.zip` Save the file to our desktop. Unzip the ZIP archive to your desktop (you should end up with a folder called `akustyk`)

* Open Terminal
* Type `chflags no hidden ~/Library/` and press Enter. You should now be able to see the Library folder in Finder under your username.
* Move the entire folder `akustyk` to the following location: `~/Library/Preferences/akustyk/` (`~/` stands for your home directory -- not under Macintosh HD, but under your username)
* Inside the `akustyk` folder, find the file called `praat-user-startUp` and move it to the root of your home directory `~/` 
* Open the file in a tex editor and change the value of the variable `platform$` as follows:
`"platform$="mac"`
* Start Praat. Akustyk is now installed, you should see Akustyk menus at the bottom of the `Praat` menu in the Praat Objects Window.

## Linux ##
On Linux download the archive, open the terminal and enter the following:

* `cp ~/Downloads/akustyk_1.9.tar.gz ~/`
* `tar xzf akustyk_1.9.tar.gz`
* `cp ~/akustyk/praat-user-startUp ~/`
* `gedit ~/praat-user-startUp` 
*  edit the line: `"platform$=linux"`
*  save the file and close gedit
*  start Praat, you should now see Akustyk menus added to the Praat UI

Next, you need to open the file `praat-user-startUp` in a text editor

     

