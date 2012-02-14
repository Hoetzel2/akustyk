# This script sets up Akustyk as a Praat plug-in
# Bartlomiej Plichta 02/05/12
clearinfo
form Install_Akustyk
comment Set up Akustyk as a Praat plug-in
choice Setup 1
button Install
button Uninstall
endform
# Environment variables
home$ = homeDirectory$
desktopDirectory$ = "'home$'/Desktop"
prefs$ = preferencesDirectory$
akustykDownloaded$ = "'desktopDirectory$'/plugin_akustyk"
singleQuote$ = "'"
pluginDirectory$ = "'prefs$'/plugin_akustyk"
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
   akustykDownloaded$ = "'winDesktop$'\plugin_akustyk"
   copyDir$ = "xcopy 'akustykDownloaded$' 'prefs$'\plugin_akustyk\ /S /Y /Q"
   rmDir$ = "RD /S /Q 'prefs$'\plugin_akustyk"
elsif macintosh = 1
   system$ = "mac"
   pluginDirectory$ = "'singleQuote$''prefs$'/plugin_akustyk'singleQuote$'"
   copyDir$ = "cp -r 'akustykDownloaded$' 'pluginDirectory$'"
   rmDir$ = "rm -r 'pluginDirectory$'"
endif
if setup$ = "Install"
    # Check for existing installation:
    if fileReadable(installedAkustyk$)
       pause Akustyk is already installed. This will overwrite 'pluginDirectory$'
       system_nocheck 'rmDir$'
    endif
    if fileReadable(praatUserStartUp$)
       system_nocheck 'copyDir$'
       if fileReadable(installedAkustyk$)
	     pause Akustyk installed successfully. Restart Praat to take effect.
	     printline Akustyk has been installed in: 'pluginDirectory$'
	     call instructions
       else
	     pause Akustyk could not be installed. Try again!
       endif
    else
       pause Could not find plugin_akustyk on your Desktop
    endif
elsif setup$ = "Uninstall"
       prefs$ = preferencesDirectory$
       pluginDirectory$ = "'prefs$'/plugin_akustyk"
       pause Akustyk ('prefs$'/plugin_akustyk) will be removed
       system_nocheck 'rmDir$'
       installedAkustyk$ = "'pluginDirectory$'/praat-user-startUp"
       if fileReadable(installedAkustyk$)
          pause Failed to remove Akustyk. Try again.
	else
	  echo Akustyk has been uninstalled. Restart Praat to take effect.
	endif
endif
procedure instructions
   printline 'newline$' -- INSTRUCTIONS -- 'newline$'
   printline You need to set up Akustyk preferences before you can use the analysis tools.
   printline You can either choose from among preconfigured sound systems (Praat/Akustyk/Set preferences...
   printline or you can set up a custom sound system (Praat/Akustyk/Set custom vowel system...)
   printline For more information, visit HTTP://bartus.org
   printline You can email be at HTTP://bartus.org/akustyk/email.php or send email to plichtab@msu.edu
   printline Enjoy!
endproc
