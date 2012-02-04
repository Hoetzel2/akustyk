# # Rasterize for Akustyk
# # Bartlomiej Plichta Thu Feb  2 15:34:36 CST 2012
# The script requires ImageMagick to be installed. ImageMagick is a free command-line utility that powers a lot of image conversion software. It is available for Linux, Mac, and Windows.
# I recommend you use the "Simple" option for most purposes. For advanced applications, you can use the "Advanced" options. The command "Resize fit" resizes to fit the box to the number of pixels specified. It simply resizes the shorter edge to the specified number of pixels. The function "Resize fill" fills the box, thus resizing the longer edge to the specified number of pixels. For best results, enter the same number of pixels in the "Resolution" and "Resize fit/fill" boxes. The resulting file is in PNG format, chosen for best quality and broadest applications.

clearinfo
form Rasterize
comment Select output directory with trailing slash (Desktop by default)
sentence Output_directory Desktop
word File_name myFile
comment Select options for image format
choice Mode 1
button Simple
button Advanced
comment Simple options:
optionmenu Destination 1
option Webpage
option PowerPoint
option Word_draft
option Word_print
comment Advanced options:
real Resolution_dpi 150
optionmenu Transparency 1
option Flatten
option Preserve
comment Choose only one of the resize options:
real Resize_fit_px 0(=none)
real Resize_fill_px 0(=none)
real Resize_scale_percent 0(=none)
endform

call checkEnvironment

if resolution_dpi <> 0
   resolution$ = "-density 'resolution_dpi'x'resolution_dpi'"
else
   exit Resolution$ cannot be zero!
endif
if resize_fit_px <> 0
   resizeFit$ = "-resize 'resize_fit_px'"
else
   resizeFit$ = ""
endif
if resize_fill_px <> 0
   resizeFill$ = "-resize 'resize_fill_px'^"
else
   resizeFill$ = ""
endif

if resize_scale_percent <> 0
   resizeScale$ = "-resize 'resize_scale_percent'%"
else
   resizeScale$ = ""
endif

# if border_px$ <> "0x0"
#    border$ = "-bordercolor SkyBlue -border 'border_px$'"
# else
#    border$ = ""
# endif

if transparency$ = "Flatten"
   flatten$ = "-flatten"
else
   flatten$ = ""
endif

# Conversion commands
if mode$ = "Simple"
   if destination$ = "PowerPoint"
      resolution = 150
   elsif destination$ = "Word_draft"
      resolution = 300
   elsif destination$ = "Word_print"
      resolution = 600
   elsif destination$ = "Webpage"
      resolution = 100
   endif
   call saveEps
   call stripExt
   system_nocheck convert -density 'resolution'x'resolution' -flatten  -antialias 'epsFile$' 'bareFile$'.png
   echo Your files: 'file_name$'.eps and 'file_name$'.png have been saved in: 'output_directory$'
elsif mode$ = "Advanced"
   call saveEps
   call stripExt
   system_nocheck convert 'resolution$' 'flatten$' 'resizeFit$' 'resizeFill$' 'resizeScale$'  -antialias  'epsFile$' 'border$' 'bareFile$'.png
   echo Your files: 'file_name$'.eps and 'file_name$'.png have been saved in: 'output_directory$'
endif

procedure checkEnvironment
# Check environment
homePath$ = environment$("HOMEPATH")
homeDirectory$ = environment$("HOME")
if homePath$ = ""
   system$ = "unix"
   desktop$ = "'homeDirectory$'/Desktop/"
   syscmd$ = "system_nocheck"
else
   system$ = "win"
   desktop$ = "C:\'homePath$'\Desktop\'"
   syscmd$ = "system"
endif
endproc


procedure saveEps
if output_directory$ = "Desktop"
   epsFile$ = "'desktop$''file_name$'.eps"
else
   epsFile$ = "'output_directory$'/'file_name$'.eps"
endif
if fileReadable(epsFile$)
   exit This file already exists. Please, choose different name.
endif
Save as EPS file... 'epsFile$'
endproc

procedure stripExt
ext$ = right$(epsFile$,4)
bareFile$ = epsFile$ - ext$
endproc

