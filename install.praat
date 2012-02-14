# This script sets up a Praat plug-in
# Bartlomiej Plichta 02/05/12
# The plug-in directory "plugin_YourPluginName" should be placed on the Desktop of the user's operating system
# The script has been tested on Linux, Mac OS X, and Windows 7. Further testing may be required on other platforms.
clearinfo
form Install_Plugin
comment Set up a Praat plug-in
choice Setup 1
button Install
button Uninstall
endform
# Your Plug-in name:
pluginName$ = "plugin_akustyk"
# Environment variables
home$ = homeDirectory$
desktopDirectory$ = "'home$'/Desktop"
prefs$ = preferencesDirectory$
akustykDownloaded$ = "'desktopDirectory$'/'pluginName$'"
singleQuote$ = "'"
pluginDirectory$ = "'prefs$'/'pluginName$'"
praatUserStartUp$ = "'akustykDownloaded$'/praat-user-startUp"
installedAkustyk$ = "'pluginDirectory$'/praat-user-startUp"
if unix = 1
   system$ = "unix"
   copyDir$ = "cp -r 'akustykDownloaded$' 'prefs$'"
   rmDir$ = "rm -r 'pluginDirectory$'"
elsif windows = 1
   system$ = "windows"
   winPath$ = environment$("USERPROFILE")
   winDesktop$ = "'winPath$'\Desktop"
   akustykDownloaded$ = "'winDesktop$'\'pluginName$'"
   copyDir$ = "xcopy 'akustykDownloaded$' 'prefs$'\'pluginName$'\ /S /Y /Q"
   rmDir$ = "RD /S /Q 'prefs$'\'pluginName$'"
elsif macintosh = 1
   system$ = "mac"
   pluginDirectory$ = "'singleQuote$''prefs$'/'pluginName$''singleQuote$'"
   copyDir$ = "cp -r 'akustykDownloaded$' 'pluginDirectory$'"
   rmDir$ = "rm -r 'pluginDirectory$'"
endif
if setup$ = "Install"
    # Check for existing installation:
    if fileReadable(installedAkustyk$)
       pause 'pluginName$' is already installed. This will overwrite 'pluginDirectory$'
       system_nocheck 'rmDir$'
    endif
    if fileReadable(praatUserStartUp$)
       system_nocheck 'copyDir$'
       if fileReadable(installedAkustyk$)
	     pause 'pluginName$' installed successfully. Restart Praat to take effect.
	     printline 'pluginName$' has been installed in: 'pluginDirectory$'
	     call instructions
       else
	     pause 'pluginName$' could not be installed. Try again!
       endif
    else
       pause Could not find 'pluginName$' on your Desktop
    endif
elsif setup$ = "Uninstall"
       prefs$ = preferencesDirectory$
       pluginDirectory$ = "'prefs$'/'pluginName$'"
       pause Plugin ('prefs$'/'pluginName$') will be removed
       system_nocheck 'rmDir$'
       installedAkustyk$ = "'pluginDirectory$'/praat-user-startUp"
       if fileReadable(installedAkustyk$)
          pause Failed to remove 'pluginName$'. Try again.
	else
	  echo 'pluginName$' has been uninstalled. Restart Praat to take effect.
	endif
endif
procedure instructions
   # Change instructions for your Plug-in:
   printline 'newline$' -- INSTRUCTIONS -- 'newline$'
   printline You need to set up Akustyk preferences before you can use the analysis tools.
   printline You can either choose from among preconfigured sound systems (Praat/Akustyk/Set preferences...
   printline or you can set up a custom sound system (Praat/Akustyk/Set custom vowel system...)
   printline For more information, visit HTTP://bartus.org
   printline You can email be at HTTP://bartus.org/akustyk/email.php or send email to plichtab@msu.edu
   printline Enjoy!
endproc
