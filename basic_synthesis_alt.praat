# This script does global synthesis of F1-F5 and B1-B5, with formant checking
# Bartlomiej Plichta; 02/08/12

endeditor
clearinfo
form LPC_synthesis
real Filter_order 11
real Time_step 0.01
sentence F1_change self
sentence F2_change self
sentence F3_change self
sentence F4_change self
sentence F5_change self
sentence B1_change self
sentence B2_change self
sentence B3_change self
sentence B4_change self
sentence B5_change self
optionmenu LPC_entire_file 1
option yes
option no
boolean Check_LPC_values 1
endform
save=0
intervals = 1
frame = 0
window=0.08
if save = 1
	select all
	top_sound = selected("Sound",1)
	numberOfSelectedSounds = numberOfSelected("Sound")
	select top_sound
	if numberOfSelectedSounds > 1
		exit Remove all objects except master sound before proceeding!
	endif
	pause You may want to rename your master sound
endif

# Set variables left over from the basic_synthesis.praat (crude, but works)
left_Interval_1$ = "self"
right_Interval_1$ = "self"
left_Interval_2$ = "self"
right_Interval_2$ = "self"
left_Interval_3$ = "self"
right_Interval_3$ = "self"
left_Interval_4$ = "self"
right_Interval_4$ = "self"
left_Interval_5$ = "self"
right_Interval_5$ = "self"
left_Interval_6$ = "self"
right_Interval_6$ = "self"
left_Interval_7$ = "self"
right_Interval_7$ = "self"
left_Interval_8$ = "self"
right_Interval_8$ = "self"
left_Interval_9$ = "self"
right_Interval_9$ = "self"
left_Interval_10$ = "self"
right_Interval_10$ = "self"


procedure from_editor
original_sound = selected("Sound")
original_sound$ = selected$("Sound")
duration = Get total duration
Rename... before
Resample... 10000 50
master_sound = selected("Sound")
template_sound = selected("Sound")
Rename... template
Edit
editor Sound template
pause Make a selection
Move begin of selection to nearest zero crossing
Move end of selection to nearest zero crossing
sel_start=Get begin of selection
sel_end=Get end of selection
cursor = Get cursor
# selection synthesis only
if lPC_entire_file$ = "no"
	call split_files
endif
endeditor
endproc

call from_editor
select template_sound
duration = Get total duration
midpoint = duration/2
master_sound_DB=Get intensity (dB)
To LPC (burg)... filter_order window time_step 50
Rename... Source
master_lpc = selected("LPC")
To Formant
Rename... Filter
master_formant = selected("Formant")
Copy... original
original_formant = selected("Formant")
select master_formant

#Get frame numbers from selection times
frame_start = Get frame number from time... sel_start
frame_end = Get frame number from time... sel_end

f1_before = Get value at time... 1 midpoint Hertz Linear
f2_before = Get value at time... 2 midpoint Hertz Linear
f3_before = Get value at time... 3 midpoint Hertz Linear
f4_before = Get value at time... 4 midpoint Hertz Linear
f5_before = Get value at time... 5 midpoint Hertz Linear

b1_before = Get bandwidth at time... 1 midpoint Hertz Linear
b2_before = Get bandwidth at time... 2 midpoint Hertz Linear
b3_before = Get bandwidth at time... 3 midpoint Hertz Linear
b4_before = Get bandwidth at time... 4 midpoint Hertz Linear
b5_before = Get bandwidth at time... 5 midpoint Hertz Linear

nframes = Get number of frames
start = 1
mid = nframes/2
end = nframes

interval = abs(round((frame_start-frame_end)/10))
frame_start=round(frame_start)
#Get frames and times for each interval
i1=frame_start
if i1 < 1
   select original_sound
   exit Could not get sufficient number of analysis frames. Please, change your selection.
endif
t1=Get time from frame number... frame_start
i2=frame_start+interval
t2=Get time from frame number... i2
i3=frame_start+(interval*2)
t3=Get time from frame number... i3
i4=frame_start+(interval*3)
t4=Get time from frame number... i4
i5=frame_start+(interval*4)
t5=Get time from frame number... i5
i6=frame_start+(interval*5)
t6=Get time from frame number... i6
i7=frame_start+(interval*6)
t7=Get time from frame number... i7
i8=frame_start+(interval*7)
t8=Get time from frame number... i8
i9=frame_start+(interval*8)
t9=Get time from frame number... i9
i10=frame_start+(interval*9)
t10=Get time from frame number... i10
i11=frame_start+(interval*10)
t11=Get time from frame number... i11


f1_t1_before = Get value at time... 1 t1 Hertz Linear
f1_t2_before = Get value at time... 1 t2 Hertz Linear
f1_t3_before = Get value at time... 1 t3 Hertz Linear
f1_t4_before = Get value at time... 1 t4 Hertz Linear
f1_t5_before = Get value at time... 1 t5 Hertz Linear
f1_t6_before = Get value at time... 1 t6 Hertz Linear
f1_t7_before = Get value at time... 1 t7 Hertz Linear
f1_t8_before = Get value at time... 1 t8 Hertz Linear
f1_t9_before = Get value at time... 1 t9 Hertz Linear
f1_t10_before = Get value at time... 1 t10 Hertz Linear
f1_t11_before = Get value at time... 1 t11 Hertz Linear

f2_t1_before = Get value at time... 2 t1 Hertz Linear
f2_t2_before = Get value at time... 2 t2 Hertz Linear
f2_t3_before = Get value at time... 2 t3 Hertz Linear
f2_t4_before = Get value at time... 2 t4 Hertz Linear
f2_t5_before = Get value at time... 2 t5 Hertz Linear
f2_t6_before = Get value at time... 2 t6 Hertz Linear
f2_t7_before = Get value at time... 2 t7 Hertz Linear
f2_t8_before = Get value at time... 2 t8 Hertz Linear
f2_t9_before = Get value at time... 2 t9 Hertz Linear
f2_t10_before = Get value at time... 2 t10 Hertz Linear
f2_t11_before = Get value at time... 2 t11 Hertz Linear

call formula

if f1_change$ <> "self"
	'f1_formula$'
endif
if f2_change$ <> "self"
	'f2_formula$'
endif
if f3_change$ <> "self"
	'f3_formula$'
endif
if f4_change$ <> "self"
	'f4_formula$'
endif
if f5_change$ <> "self"
	'f5_formula$'
endif
if b1_change$ <> "self"
	'f1b_formula$'
endif
if b2_change$ <> "self"
	'f2b_formula$'
endif
if b3_change$ <> "self"
	'f3b_formula$'
endif
if b4_change$ <> "self"
	'f4b_formula$'
endif
if b5_change$ <> "self"
	'f5b_formula$'
endif
if intervals=1

	#Interval 1
	for frame from i1 to i2
		
		if left_Interval_1$ <> "self"
			'f1_formula_1$'
		endif
		if right_Interval_1$ <> "self"
			'f2_formula_1$'
		endif
	time_begin_1=Get time from frame number... frame_start
	time_end_1=Get time from frame number... i2

	endfor
	
	#Interval 2
	for frame from i2 to i3
		if left_Interval_2$ <> "self"
			'f1_formula_2$'
		endif
		if right_Interval_2$ <> "self"
			'f2_formula_2$'
		endif

	endfor
	time_begin_2=Get time from frame number... i2
	time_end_2=Get time from frame number... i3

	#Interval 3
	for frame from i3 to i4
		if left_Interval_3$ <> "self"
			'f1_formula_3$'
		endif
		if right_Interval_3$ <> "self"
			'f2_formula_3$'
		endif
		
	endfor
	time_begin_3=Get time from frame number... i3
	time_end_3=Get time from frame number... i4
	
	#Interval 4
	for frame from i4 to i5
		if left_Interval_4$ <> "self"
			'f1_formula_4$'
		endif
		if right_Interval_4$ <> "self"
			'f2_formula_4$'
		endif
		
	endfor
	time_begin_4=Get time from frame number... i4
	time_end_4=Get time from frame number... i5
	
	#Interval 5
	for frame from i5 to i6
		if left_Interval_5$ <> "self"
			'f1_formula_5$'
		endif
		if right_Interval_5$ <> "self"
			'f2_formula_5$'
		endif		
	endfor
	time_begin_5=Get time from frame number... i5
	time_end_5=Get time from frame number... i6
	
	#Interval 6
	for frame from i6 to i7
		if left_Interval_6$ <> "self"
			'f1_formula_6$'
		endif
		if right_Interval_6$ <> "self"
			'f2_formula_6$'
		endif
		
	endfor
	time_begin_6=Get time from frame number... i6
	time_end_6=Get time from frame number... i7

	#Interval 7
	for frame from i7 to i8
		if left_Interval_7$ <> "self"
			'f1_formula_7$'
		endif
		if right_Interval_7$ <> "self"
			'f2_formula_7$'
		endif
		
	endfor
	time_begin_7=Get time from frame number... i7
	time_end_7=Get time from frame number... i8

	#Interval 8
	for frame from i8 to i9
		if left_Interval_8$ <> "self"
			'f1_formula_8$'
		endif
		if right_Interval_8$ <> "self"
			'f2_formula_8$'
		endif

	endfor
	time_begin_8=Get time from frame number... i8
	time_end_8=Get time from frame number... i9

	#Interval 9
	for frame from i9 to i10
		if left_Interval_9$ <> "self"
			'f1_formula_9$'
		endif
		if right_Interval_9$ <> "self"
			'f2_formula_9$'
		endif
		
	endfor
	time_begin_9=Get time from frame number... i9
	time_end_9=Get time from frame number... i10

	#Interval 10
	for frame from i10 to i11
		if left_Interval_10$ <> "self"
			'f1_formula_10$'
		endif
		if right_Interval_10$ <> "self"
			'f2_formula_10$'
		endif
	endfor
	time_begin_10=Get time from frame number... i10
	time_end_10=Get time from frame number... i11

endif

#for current_frame from 1 to 10
#f1_t = Get value at time... 1 t'current_frame' Hertz Linear
#f2_t = Get value at time... 2 t'current_frame' Hertz Linear
#print 'f2_t''newline$'
#endfor

select master_formant

f1_t1_after = Get value at time... 1 t1 Hertz Linear
f1_t2_after = Get value at time... 1 t2 Hertz Linear
f1_t3_after = Get value at time... 1 t3 Hertz Linear
f1_t4_after = Get value at time... 1 t4 Hertz Linear
f1_t5_after = Get value at time... 1 t5 Hertz Linear
f1_t6_after = Get value at time... 1 t6 Hertz Linear
f1_t7_after = Get value at time... 1 t7 Hertz Linear
f1_t8_after = Get value at time... 1 t8 Hertz Linear
f1_t9_after = Get value at time... 1 t9 Hertz Linear
f1_t10_after = Get value at time... 1 t10 Hertz Linear
f2_t1_after = Get value at time... 2 t1 Hertz Linear
f2_t2_after = Get value at time... 2 t2 Hertz Linear
f2_t3_after = Get value at time... 2 t3 Hertz Linear
f2_t4_after = Get value at time... 2 t4 Hertz Linear
f2_t5_after = Get value at time... 2 t5 Hertz Linear
f2_t6_after = Get value at time... 2 t6 Hertz Linear
f2_t7_after = Get value at time... 2 t7 Hertz Linear
f2_t8_after = Get value at time... 2 t8 Hertz Linear
f2_t9_after = Get value at time... 2 t9 Hertz Linear
f2_t10_after = Get value at time... 2 t10 Hertz Linear

call checkLPC

select master_lpc
select master_sound
plus master_lpc
Filter (inverse)
Rename... source
source_sound = selected("Sound")
plus master_formant
Filter
Rename... Resynthesized
resynthesized_sound = selected("Sound")
resynthesized_sound_DB=Get intensity (dB)
Scale intensity... master_sound_DB

To LPC (burg)... filter_order window time_step 50
Rename... Source_after
lpc_after = selected("LPC")
To Formant
Rename... formant_after
formant_after = selected("Formant")

f1_after = Get value at time... 1 midpoint Hertz Linear
f2_after = Get value at time... 2 midpoint Hertz Linear
f3_after = Get value at time... 3 midpoint Hertz Linear
f4_after = Get value at time... 4 midpoint Hertz Linear
f5_after = Get value at time... 5 midpoint Hertz Linear

b1_after = Get bandwidth at time... 1 midpoint Hertz Linear
b2_after = Get bandwidth at time... 2 midpoint Hertz Linear
b3_after = Get bandwidth at time... 3 midpoint Hertz Linear
b4_after = Get bandwidth at time... 4 midpoint Hertz Linear
b5_after = Get bandwidth at time... 5 midpoint Hertz Linear

call paste

if save = 1
	call save
endif

call draw
select final_sound
final_audio$ = selected$("Sound")
Edit
editor Sound 'final_audio$'
Select... sel_start sel_end

# selection synthesis only
if lPC_entire_file$ = "no"
	call recombine
endif
endeditor
Play

#End code

procedure paste
select resynthesized_sound
Rename... final_audio
final_audio$ = selected$("Sound")
final_sound = selected("Sound")
endproc

procedure save
select all
Write to binary file... data/'original_sound$'_resynthesis.Collection
select final_sound
Write to WAV file... data/'original_sound$'_res_token.wav
select original_sound
data_output_file$ = "data/'original_sound$'_data.txt"
filedelete 'data_output_file$'
fileappend 'data_output_file$' Int_number'tab$'Interval'tab$'F1_change'tab$'F2_change'tab$'F3_change'tab$'B1_change$'tab$'B2_change'tab$'B3_change'tab$'F1_int_change'tab$'F2_int_change'tab$'F1_before'tab$'F1_after'tab$'F2_before'tab$'F2_after'newline$'
fileappend 'data_output_file$' 1'tab$''time_begin_1:4' - 'time_end_1:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_1$''tab$''right_Interval_1$''tab$''f1_t1_before:0''tab$''f2_t1_before:0''tab$''f1_t1_after:0''tab$''f2_t1_after:0''newline$'
fileappend 'data_output_file$' 2'tab$''time_begin_2:4' - 'time_end_2:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_2$''tab$''right_Interval_2$''tab$''f1_t2_before:0''tab$''f2_t2_before:0''tab$''f1_t2_after:0''tab$''f2_t2_after:0''newline$'
fileappend 'data_output_file$' 3'tab$''time_begin_3:4' - 'time_end_3:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_3$''tab$''right_Interval_3$''tab$''f1_t3_before:0''tab$''f2_t3_before:0''tab$''f1_t3_after:0''tab$''f2_t3_after:0''newline$'
fileappend 'data_output_file$' 4'tab$''time_begin_4:4' - 'time_end_4:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_4$''tab$''right_Interval_4$''tab$''f1_t4_before:0''tab$''f2_t4_before:0''tab$''f1_t4_after:0''tab$''f2_t4_after:0''newline$'
fileappend 'data_output_file$' 5'tab$''time_begin_5:4' - 'time_end_5:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_5$''tab$''right_Interval_5$''tab$''f1_t5_before:0''tab$''f2_t5_before:0''tab$''f1_t5_after:0''tab$''f2_t5_after:0''newline$'
fileappend 'data_output_file$' 6'tab$''time_begin_6:4' - 'time_end_6:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_6$''tab$''right_Interval_6$''tab$''f1_t6_before:0''tab$''f2_t6_before:0''tab$''f1_t6_after:0''tab$''f2_t6_after:0''newline$'
fileappend 'data_output_file$' 7'tab$''time_begin_7:4' - 'time_end_7:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_7$''tab$''right_Interval_7$''tab$''f1_t7_before:0''tab$''f2_t7_before:0''tab$''f1_t7_after:0''tab$''f2_t7_after:0''newline$'
fileappend 'data_output_file$' 8'tab$''time_begin_8:4' - 'time_end_8:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_8$''tab$''right_Interval_8$''tab$''f1_t8_before:0''tab$''f2_t8_before:0''tab$''f1_t8_after:0''tab$''f2_t8_after:0''newline$'
fileappend 'data_output_file$' 9'tab$''time_begin_9:4' - 'time_end_9:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_9$''tab$''right_Interval_9$''tab$''f1_t9_before:0''tab$''f2_t9_before:0''tab$''f1_t9_after:0''tab$''f2_t9_after:0''newline$'
fileappend 'data_output_file$' 10'tab$''time_begin_10:4' - 'time_end_10:4''tab$''f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_10$''tab$''right_Interval_10$''tab$''f1_t10_before:0''tab$''f2_t10_before:0''tab$''f1_t10_after:0''tab$''f2_t10_after:0''newline$'

endproc

procedure draw
Erase all
select original_formant
Black
Speckle... time_begin_1 time_end_10 5000 30 yes
select formant_after
Red
Speckle... time_begin_1 time_end_10 5000 30 no
Black
One mark top... 'time_begin_1:4' no yes no 1
One mark top... 'time_begin_2:4' no yes yes 2
One mark top... 'time_begin_3:4' no yes yes 3
One mark top... 'time_begin_4:4' no yes yes 4
One mark top... 'time_begin_5:4' no yes yes 5
One mark top... 'time_begin_6:4' no yes yes 6
One mark top... 'time_begin_7:4' no yes yes 7
One mark top... 'time_begin_8:4' no yes yes 8
One mark top... 'time_begin_9:4' no yes yes 9
One mark top... 'time_begin_10:4' no yes yes 10
One mark top... 'time_end_10:4' no yes no 11
select original_sound
endproc


print MIDPOINT BEFORE
printline
printline
print F1'tab$'B1'tab$'F2'tab$'B2'tab$'F3'tab$'B3'tab$''newline$'
print 'f1_before:0''tab$''b1_before:0''tab$''f2_before:0''tab$''b2_before:0''tab$''f3_before:0''tab$''b3_before:0''tab$''f4_before:0''tab$''b4_before:0''tab$''f5_before:0''tab$''b5_before:0''tab$''newline$'
printline
print MIDPOINT AFTER
printline
printline
print F1'tab$'B1'tab$'F2'tab$'B2'tab$'F3'tab$'B3'tab$''newline$'
print 'f1_after:0''tab$''b1_after:0''tab$''f2_after:0''tab$''b2_after:0''tab$''f3_after:0''tab$''b3_after:0''tab$''f4_after:0''tab$''b4_after:0''tab$''f5_after:0''tab$''b5_after:0''tab$''newline$'
printline
print VALUES IN FRAMES'newline$'
print F1_change'tab$'F2_change'tab$'F3_change'tab$'B1_change$'tab$'B2_change'tab$'B3_change'tab$'F1_before'tab$'F1_after'tab$'F2_before'tab$'F2_after'newline$'

print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_1$''tab$''right_Interval_1$''tab$''f1_t1_before:0''tab$''f2_t1_before:0''tab$''f1_t1_after:0''tab$''f2_t1_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_2$''tab$''right_Interval_2$''tab$''f1_t2_before:0''tab$''f2_t2_before:0''tab$''f1_t2_after:0''tab$''f2_t2_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_3$''tab$''right_Interval_3$''tab$''f1_t3_before:0''tab$''f2_t3_before:0''tab$''f1_t3_after:0''tab$''f2_t3_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_4$''tab$''right_Interval_4$''tab$''f1_t4_before:0''tab$''f2_t4_before:0''tab$''f1_t4_after:0''tab$''f2_t4_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_5$''tab$''right_Interval_5$''tab$''f1_t5_before:0''tab$''f2_t5_before:0''tab$''f1_t5_after:0''tab$''f2_t5_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_6$''tab$''right_Interval_6$''tab$''f1_t6_before:0''tab$''f2_t6_before:0''tab$''f1_t6_after:0''tab$''f2_t6_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_7$''tab$''right_Interval_7$''tab$''f1_t7_before:0''tab$''f2_t7_before:0''tab$''f1_t7_after:0''tab$''f2_t7_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_8$''tab$''right_Interval_8$''tab$''f1_t8_before:0''tab$''f2_t8_before:0''tab$''f1_t8_after:0''tab$''f2_t8_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_9$''tab$''right_Interval_9$''tab$''f1_t9_before:0''tab$''f2_t9_before:0''tab$''f1_t9_after:0''tab$''f2_t9_after:0''newline$'
print 'f1_change$''tab$''f2_change$''tab$''f3_change$''tab$''b1_change$''tab$''b2_change$''tab$''b3_change$''tab$''left_Interval_10$''tab$''right_Interval_10$''tab$''f1_t10_before:0''tab$''f2_t10_before:0''tab$''f1_t10_after:0''tab$''f2_t10_after:0''newline$'

 
 
procedure formula

f1_formula$= "Formula (frequencies)... if row = 1 and col > frame_start and col < frame_end then 'f1_change$' else self fi"
f2_formula$= "Formula (frequencies)... if row = 2 and col > frame_start and col < frame_end then 'f2_change$' else self fi"
f3_formula$= "Formula (frequencies)... if row = 3 and col > frame_start and col < frame_end  then 'f3_change$' else self fi"
f4_formula$= "Formula (frequencies)... if row = 4 and col > frame_start and col < frame_end  then 'f4_change$' else self fi"
f5_formula$= "Formula (frequencies)... if row = 5 and col > frame_start and col < frame_end  then 'f5_change$' else self fi"

f1b_formula$= "Formula (bandwidths)... if row = 1 and col > frame_start and col < frame_end  then 'b1_change$' else self fi"
f2b_formula$= "Formula (bandwidths)... if row = 2 and col > frame_start and col < frame_end  then 'b2_change$' else self fi"
f3b_formula$="Formula (bandwidths)... if row = 3 and col > frame_start and col < frame_end  then 'b3_change$' else self fi"
f4b_formula$="Formula (bandwidths)... if row = 4 and col > frame_start and col < frame_end  then 'b4_change$' else self fi"
f5b_formula$="Formula (bandwidths)... if row = 5 and col > frame_start and col < frame_end  then 'b5_change$' else self fi"



f1_formula_1$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_1$' else self fi"
f1_formula_2$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_2$' else self fi"
f1_formula_3$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_3$' else self fi"
f1_formula_4$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_4$' else self fi"
f1_formula_5$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_5$' else self fi"
f1_formula_6$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_6$' else self fi"
f1_formula_7$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_7$' else self fi"
f1_formula_8$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_8$' else self fi"
f1_formula_9$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_9$' else self fi"
f1_formula_10$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_10$' else self fi"

f2_formula_1$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_1$' else self fi"
f2_formula_2$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_2$' else self fi"
f2_formula_3$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_3$' else self fi"
f2_formula_4$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_4$' else self fi"
f2_formula_5$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_5$' else self fi"
f2_formula_6$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_6$' else self fi"
f2_formula_7$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_7$' else self fi"
f2_formula_8$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_8$' else self fi"
f2_formula_9$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_9$' else self fi"
f2_formula_10$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_10$' else self fi"
endproc
 
procedure split_files
	if sel_start = 0
		exit Your selection is too close to the edge of the file
	elsif sel_end = 0
		exit Your selection is too close to the edge of the file
	else
		select template_sound
		Select... 0 sel_start
		Extract selected sound (preserve times)
		one=selected("Sound")
		Select... sel_start sel_end
		Extract selected sound (preserve times)
		two=selected("Sound")
		Select... sel_end duration
		Extract selected sound (preserve times)
		three=selected("Sound")
		endeditor
		select one
		Rename... beginning
		select two
		Rename... selection
		select three
		Rename... end
select two
	endif
endproc
 
procedure recombine
Extract selected sound (preserve times)
synthesized_selection=selected("Sound")
endeditor
Rename... synthesized_selection
select one
Copy... one_final
one_final=selected("Sound")
select synthesized_selection
Copy... synthesized_selection_final
synthesized_selection_final=selected("Sound")
select three
Copy... three_final
three_final=selected("Sound")
select one_final
plus synthesized_selection_final
plus three_final
Concatenate
Rename... lpc_selection_only
lpc_selection_only=selected("Sound")
select one
plus two
plus three
plus one_final
plus synthesized_selection_final
plus three_final
Remove
select lpc_selection_only
endproc
 

procedure checkLPC
# Check LPC values
select master_lpc
To Formant
Down to FormantGrid
test_formant_grid = selected("FormantGrid")
View & Edit
pause Check formant values
endproc
