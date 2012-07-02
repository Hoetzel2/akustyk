# akustyk for Praat. Copyright @2012 Bartlomiej Plichta
# http://bartus.org/akustyk
# Praat is software developed by Paul Boersma and David Weenink at University of Amsterdam
include praat.ini
include normalize_form.praat
# table sniffer
sniff_ncol = Get number of columns
if sniff_ncol <> 16
	exit Your table is not well-formed
endif
if file$ <> normalized_spreadsheet$
exit You cannot change this file name
endif
if fileReadable (normalized_spreadsheet$)
	pause This will overwrite normalized spreadsheet!
	filedelete 'normalized_spreadsheet$'
	fileappend "'normalized_spreadsheet$'" vowel_ipa'tab$'sex_code'tab$'speak_id'tab$'vowel_code'tab$'f1_norm'tab$'f2_norm'tab$'f3_norm'tab$'f0'tab$'place_p'tab$'manner_p'tab$'voice_p'tab$'place_f'tab$'manner_f'tab$'voice_f'tab$'category_1'tab$'category_2'tab$'vowel_pk
else 
	fileappend "'normalized_spreadsheet$'" vowel_ipa'tab$'sex_code'tab$'speak_id'tab$'vowel_code'tab$'f1_norm'tab$'f2_norm'tab$'f3_norm'tab$'f0'tab$'place_p'tab$'manner_p'tab$'voice_p'tab$'place_f'tab$'manner_f'tab$'voice_f'tab$'category_1'tab$'category_2'tab$'vowel_pk
endif

# start file type sniffer
check$ = Get column label... 2
if check$ = "speak_id"
exit This data has already been normalized!
endif

tableofreal_ID$ = selected$ ("TableOfReal")
originalTable = selected("TableOfReal")
Copy... Sort
Sort by column... 2 0
nrow=Get number of rows
last_speaker=Get value... nrow 2
Remove
select TableOfReal 'tableofreal_ID$'
if file$ = ""
exit You must enter the file name and path!
endif

pause THIS MAY TAKE A WHILE.

# set fixed number of vowels for all.
number_of_vowels = 158

if last_speaker_number = 0
	speaker_number = last_speaker
	#pause Estimated last speaker = 'last_speaker'. Click CONTINUE if this is correct.
else
	speaker_number = last_speaker_number
endif
clearinfo
select originalTable
Copy... masterGlobalTable
masterGlobalTable = selected("TableOfReal")
normalizeTableOfReal = Copy... Normalize
speaker_check = Copy... speaker_check

if normalization_type$ = "Watt and Fabricius"
	call normalizeWF speaker_check speaker_number
	select masterGlobalTable
	plus normalizeTableOfReal
	plus globalMeansTable
	Remove
	select globalMasterRescaled
endif

if normalization_type$ = "Lobanov"
	clearinfo
	# This makes sure the speaker series is not missing a number
	for i from 1 to speaker_number
		Insert row (index)... i
		Set value... i 2 i
	endfor
	for speaker_code from 1 to speaker_number
			Extract rows where column... 2 "equal to" speaker_code
			Rename... speaker'speaker_code'
			nrow=Get number of rows
			if nrow=1
				print speaker 'speaker_code' missing 'newline$'		
			else
				Remove row (index)... 1
				speaker_mean_f1 = Get column mean (index)... 4
				speaker_st_dev_f1 = Get column stdev (index)... 4
				speaker_mean_f2 = Get column mean (index)... 5
				speaker_st_dev_f2 = Get column stdev (index)... 5
				speaker_mean_f3 = Get column mean (index)... 6
				speaker_st_dev_f3 = Get column stdev (index)... 6
				nrow=Get number of rows
				for current_row from 1 to nrow
					sex_code = Get value... current_row 1
					vowel_code = Get value... current_row 3
					f1 = Get value... current_row 4
					f2 = Get value... current_row 5
					f3 = Get value... current_row 6
					f0 = Get value... current_row 7

					# this is for the new spreadsheets
					place_p_code  = Get value... current_row 8
					manner_p_code  = Get value... current_row 9
					voice_p_code  = Get value... current_row 10
					place_f_code  = Get value... current_row 11
					manner_f_code  = Get value... current_row 12
					voice_f_code  = Get value... current_row 13
					category_1_code  = Get value... current_row 14
					category_2_code  = Get value... current_row 15
					vowel_pk  = Get value... current_row 16
					
					f1_norm = (f1 - speaker_mean_f1)*150/speaker_st_dev_f1 + 500
					f2_norm = (f2 - speaker_mean_f2)*500/speaker_st_dev_f2 + 1500
					f3_norm = (f3 - speaker_mean_f3)*500/speaker_st_dev_f3 + 2500
					call vowel_codes
					# this line is for the new spreadsheets
					fileappend "'file$'" 'newline$''vowel_ipa$''tab$''sex_code''tab$''speaker_code''tab$''vowel_code''tab$''f1_norm:0''tab$''f2_norm:0''tab$''f3_norm:0''tab$''f0:0''tab$''place_p_code''tab$''manner_p_code''tab$''voice_p_code''tab$''place_f_code''tab$''manner_f_code''tab$''voice_f_code''tab$''category_1_code''tab$''category_2_code''tab$''vowel_pk'
				endfor
			endif
	Remove
	select TableOfReal speaker_check
	endfor
endif

# Perform intrinsic normalization
# Intrinsic normalization

if normalization_type$ = "Nordstrom and Lindblom"
	Extract rows where column... 4 "greater than" 600
	Rename... f1_over_600
	Extract rows where column... 1 "equal to" 1
	Rename... maleF3
	f3_mean_male = Get column mean (index)... 6
	select TableOfReal Normalize
	Extract rows where column... 4 "greater than" 600
	Rename... f1_over_600
	Extract rows where column... 1 "equal to" 2
	Rename... femaleF3
	f3_mean_female = Get column mean (index)... 6
	k=f3_mean_male/f3_mean_female
	select TableOfReal Normalize
	nrow = Get number of rows
	for current_row from 1 to nrow			
		sex_code = Get value... current_row 1
		speaker_code = Get value... current_row 2
		vowel_code = Get value... current_row 3
		f1 = Get value... current_row 4
		f2 = Get value... current_row 5
		f3 = Get value... current_row 6
		f0 = Get value... current_row 7
		
		# this is for the new spreadsheets
		place_p_code  = Get value... current_row 8
		manner_p_code  = Get value... current_row 9
		voice_p_code  = Get value... current_row 10
		place_f_code  = Get value... current_row 11
		manner_f_code  = Get value... current_row 12
		voice_f_code  = Get value... current_row 13
		category_1_code  = Get value... current_row 14
		category_2_code  = Get value... current_row 15
		vowel_pk  = Get value... current_row 16
		if sex_code=1
			f1_norm = f1
			f2_norm = f2
			f3_norm = f3
		elsif sex_code=2
			f1_norm = f1*k
			f2_norm = f2*k
			f3_norm = f3*k
		endif
		call vowel_codes
		# this line is for the new spreadsheets
		fileappend "'file$'" 'newline$''vowel_ipa$''tab$''sex_code''tab$''speaker_code''tab$''vowel_code''tab$''f1_norm:0''tab$''f2_norm:0''tab$''f3_norm:0''tab$''f0:0''tab$''place_p_code''tab$''manner_p_code''tab$''voice_p_code''tab$''place_f_code''tab$''manner_f_code''tab$''voice_f_code''tab$''category_1_code''tab$''category_2_code''tab$''vowel_pk'
	endfor
	clearinfo
	print k = 'k:2''newline$'
endif

if normalization_type$ = "Nearey"
	clearinfo
	Insert column (index)... 17
	Set column label (index)... 17 f1_old
	Insert column (index)... 18
	Set column label (index)... 18 f2_old
	Insert column (index)... 19
	Set column label (index)... 19 f3_old
	nrow = Get number of rows
	for current_row from 1 to nrow
		get_f1=Get value... current_row 4
		Set value... current_row 17 get_f1
		get_f2=Get value... current_row 5
		Set value... current_row 18 get_f2
		get_f3=Get value... current_row 6
		Set value... current_row 19 get_f3
	endfor
	Formula... if col = 4 then ln (self) else self fi
	Formula... if col = 5 then ln (self) else self fi
	Formula... if col = 6 then ln (self) else self fi
	all_speakers_f1 = Get column mean (index)... 4
	all_speakers_f2 = Get column mean (index)... 5
	all_speakers_f3 = Get column mean (index)... 6
	all_speakers = (all_speakers_f1 + all_speakers_f2 + all_speakers_f3)/3
	Copy... speaker_check
	
	# This makes sure the speaker series is not missing a number
	for i from 1 to speaker_number
		Insert row (index)... i
		Set value... i 2 i
	endfor

	for speaker_code from 1 to speaker_number
		Extract rows where column... 2 "equal to" speaker_code
		Rename... speaker'speaker_code'
		nrow=Get number of rows
		if nrow=1
			print speaker 'speaker_code' missing 'newline$'		
		else
			Remove row (index)... 1
			speaker_mean_f1 = Get column mean (index)... 4
			speaker_st_dev_f1 = Get column stdev (index)... 4
			speaker_mean_f2 = Get column mean (index)... 5
			speaker_st_dev_f2 = Get column stdev (index)... 5
			speaker_mean_f3 = Get column mean (index)... 6
			speaker_st_dev_f3 = Get column stdev (index)... 6
			speaker = (speaker_mean_f1 + speaker_mean_f2 + speaker_mean_f3)/3
			f=exp(all_speakers-speaker)
			nrow = Get number of rows
			for current_row from 1 to nrow
				sex_code = Get value... current_row 1
				vowel_code = Get value... current_row 3
				f1 = Get value... current_row 17
				f2 = Get value... current_row 18
				f3 = Get value... current_row 19
				f0 = Get value... current_row 7

				# this is for the new spreadsheets
				place_p_code = Get value... current_row 8
				manner_p_code  = Get value... current_row 9
				voice_p_code  = Get value... current_row 10
				place_f_code  = Get value... current_row 11
				manner_f_code  = Get value... current_row 12
				voice_f_code  = Get value... current_row 13
				category_1_code = Get value... current_row 14
				category_2_code = Get value... current_row 15
				vowel_pk  = Get value... current_row 16
				f1_norm = f1*f
				f2_norm = f2*f
				f3_norm = f3*f
				call vowel_codes
				# this line is for the new spreadsheets
				fileappend "'file$'" 'newline$''vowel_ipa$''tab$''sex_code''tab$''speaker_code''tab$''vowel_code''tab$''f1_norm:0''tab$''f2_norm:0''tab$''f3_norm:0''tab$''f0:0''tab$''place_p_code''tab$''manner_p_code''tab$''voice_p_code''tab$''place_f_code''tab$''manner_f_code''tab$''voice_f_code''tab$''category_1_code''tab$''category_2_code''tab$''vowel_pk'
			endfor
		endif
		select TableOfReal speaker_check
	endfor
endif

if normalization_type$ = "Nearey without F3"
	clearinfo
	Insert column (index)... 17
	Set column label (index)... 17 f1_old
	Insert column (index)... 18
	Set column label (index)... 18 f2_old
	Insert column (index)... 19
	Set column label (index)... 19 f3_old
	nrow = Get number of rows
	for current_row from 1 to nrow
		get_f1=Get value... current_row 4
		Set value... current_row 17 get_f1
		get_f2=Get value... current_row 5
		Set value... current_row 18 get_f2
		get_f3=Get value... current_row 6
		Set value... current_row 19 get_f3
	endfor
	Formula... if col = 4 then ln (self) else self fi
	Formula... if col = 5 then ln (self) else self fi
	Formula... if col = 6 then ln (self) else self fi
	all_speakers_f1 = Get column mean (index)... 4
	all_speakers_f2 = Get column mean (index)... 5
	all_speakers_f3 = Get column mean (index)... 6
	all_speakers = (all_speakers_f1 + all_speakers_f2)/2
	Copy... speaker_check
	# This makes sure the speaker series is not missing a number
	for i from 1 to speaker_number
		Insert row (index)... i
		Set value... i 2 i
	endfor
	for speaker_code from 1 to speaker_number
		Extract rows where column... 2 "equal to" speaker_code
		Rename... speaker'speaker_code'
		nrow=Get number of rows
		if nrow=1
			print speaker 'speaker_code' missing 'newline$'		
		else
			Remove row (index)... 1
			speaker_mean_f1 = Get column mean (index)... 4
			speaker_st_dev_f1 = Get column stdev (index)... 4
			speaker_mean_f2 = Get column mean (index)... 5
			speaker_st_dev_f2 = Get column stdev (index)... 5
			speaker_mean_f3 = Get column mean (index)... 6
			speaker_st_dev_f3 = Get column stdev (index)... 6
			speaker = (speaker_mean_f1 + speaker_mean_f2)/2
			f=exp(all_speakers-speaker)
			nrow = Get number of rows
			for current_row from 1 to nrow
				sex_code = Get value... current_row 1
				vowel_code = Get value... current_row 3
				f1 = Get value... current_row 17
				f2 = Get value... current_row 18
				f3 = Get value... current_row 19
				f0 = Get value... current_row 7

				# this is for the new spreadsheets
				place_p_code = Get value... current_row 8
				manner_p_code  = Get value... current_row 9
				voice_p_code  = Get value... current_row 10
				place_f_code  = Get value... current_row 11
				manner_f_code  = Get value... current_row 12
				voice_f_code  = Get value... current_row 13
				category_1_code = Get value... current_row 14
				category_2_code = Get value... current_row 15
				vowel_pk  = Get value... current_row 16

				f1_norm = f1*f
				f2_norm = f2*f
				f3_norm = f3

				call vowel_codes

				# this line is for the new spreadsheets
				fileappend "'file$'" 'newline$''vowel_ipa$''tab$''sex_code''tab$''speaker_code''tab$''vowel_code''tab$''f1_norm:0''tab$''f2_norm:0''tab$''f3_norm:0''tab$''f0:0''tab$''place_p_code''tab$''manner_p_code''tab$''voice_p_code''tab$''place_f_code''tab$''manner_f_code''tab$''voice_f_code''tab$''category_1_code''tab$''category_2_code''tab$''vowel_pk'
			endfor
		endif
		Remove
		select TableOfReal speaker_check
	endfor
	# Close normalization type statements
endif

if normalization_type$ = "Hertz to Bark"
	clearinfo
	Formula... if col >3 and col < 7 then hertzToBark (self) else self fi
	Set column label (index)... 4 f1_norm
	Set column label (index)... 5 f2_norm
	Set column label (index)... 6 f3_norm
	Write to headerless spreadsheet file... 'file$'
endif


if add_to_objects$ = "yes"
	select all
	Remove
	if fileReadable (file$)
		Read TableOfReal from headerless spreadsheet file... 'file$'
		Rename... normalized
		endif
	else
		#select all
		#minus TableOfReal 'tableofreal_ID$'
		#Remove
		#select all
endif

procedure vowel_codes
include all_codes.praat
endproc
procedure normalizeWF .speakerCheck .speakerNumber
.meansCounter = 0
.ncol = Get number of columns
space$ = " "
labels$ = ""
globalMeansTable = Create TableOfReal... meansTable 1 7
for .j from 1 to 7
	select .speakerCheck
	label$ = Get column label... .j
	select globalMeansTable
	Set column label (index)... .j 'label$'
endfor
Insert column (index)... 8
Set column label (index)... 8 f1sf1
Insert column (index)... 9
Set column label (index)... 9 f2sf2
Insert column (index)... 10
Set column label (index)... 10 f1n
Insert column (index)... 11
Set column label (index)... 11 f2n
Insert column (index)... 12
Set column label (index)... 12 f1s
Insert column (index)... 13
Set column label (index)... 13 f2s
select .speakerCheck
	for .i from 1 to .speakerNumber
		Insert row (index)... .i
		Set value... .i 2 .i
	endfor
	for .speakerCode from 1 to .speakerNumber
		select .speakerCheck
		speaker'.speakerCode' = Extract rows where column... 2 "equal to" .speakerCode
		Rename... speaker'.speakerCode'
		#Check for dummy row
		.nrow = Get number of rows
		if .nrow = 1
			printline Speaker '.speakerCode' is missing
			select speaker'.speakerCode'
			Remove
		else
			Sort by column... 2 0
			.dummy = Get value... 1 3
			if .dummy == 0
				Remove row (index)... 1
			endif
			.nrow=Get number of rows
			call getUniqueVowels speaker'.speakerCode' .nrow
			for .i from 1 to getUniqueVowels.vowelCounter
				select speaker'.speakerCode'
				.vowelCode = getUniqueVowels.vowels [.i]
				.vowel'.vowelCode' = Extract rows where column... 3 "equal to" .vowelCode
				Rename... tableVowel'.vowelCode'
				call getMeansTable .vowel'.vowelCode' .vowelCode .speakerCode
			endfor
			select speaker'.speakerCode'
			Remove
			select .speakerCheck
		endif
	endfor
#Check for empty rows
select globalMeansTable
Sort by column... 2 3
.dummy = Get value... 1 3
if .dummy == 0
	Remove row (index)... 1
endif
## means table created by this point
.meansCounter = 0
.globalCounter = 0
select globalMeansTable
.meansSpeakerCheck = Copy... meansSpeakerCheck
Sort by column... 2 0
for .i from 1 to .speakerNumber
	Insert row (index)... .i
	Set value... .i 2 .i
endfor
for .speakerCode from 1 to .speakerNumber
	select .meansSpeakerCheck
	speakerMeans'.speakerCode' = Extract rows where column... 2 "equal to" .speakerCode
	Rename... speakerMeans'.speakerCode'
	#Check for dummy row
	Sort by column... 2 3
	.nrow = Get number of rows
	if .nrow = 1
		printline Speaker '.speakerCode' is missing
		select speakerMeans'.speakerCode'
		Remove
	else
		Sort by column... 2 3
		.dummy = Get value... 1 1
		if .dummy == 0
			Remove row (index)... 1
		endif
		.nrowSp = Get number of rows
		call getFs speakerMeans'.speakerCode'
		call getUniqueVowels speakerMeans'.speakerCode' .nrowSp
		call getMeansS speakerMeans'.speakerCode' globalMeansTable getUniqueVowels.vowelCounter
		select speakerMeans'.speakerCode'
		Remove
	endif
endfor
select .speakerCheck
plus .meansSpeakerCheck
Remove
select masterGlobalTable
call getIndividualVowels .speakerNumber
call rescale
endproc
procedure getUniqueVowels .table .totalNrow
select .table
# Obtain unique vowels
.vowelCounter = 0
Sort by column... 3 0
for .v from 1 to .totalNrow-1
    .vowel1 = Get value... .v 3
    .vowel2 = Get value... .v+1 3
    if .vowel1 != .vowel2
        .vowelCounter += 1
        .vowels [.vowelCounter] = .vowel1
    endif
endfor
.vowelCounter += 1
.vowels [.vowelCounter] = .vowel2
endproc

procedure getMeansTable .vowelTable .vowelCode .spNum
#for .i from 1 to .vowelCounter
	select .vowelTable
	.ipa$ = Get row label... 1
	.f1Mean = Get column mean (index)... 4
	.f2Mean = Get column mean (index)... 5
	.f3Mean = Get column mean (index)... 6
	.sex_code = Get value... 1 1
	.speaker_code = Get value... 1 2
	.vowel_code = Get value... 1 3
	if .vowelCode != .vowel_code
		exit Vowels don't match!
	endif
	.f0Mean = Get column mean (index)... 7
	Remove
	select globalMeansTable
	.tempNRow = Get number of rows
	.meansCounter = .tempNRow + 1
	Insert row (index)... .meansCounter
	Set row label (index)... .meansCounter '.ipa$'
	Set value... .meansCounter 1 .sex_code
	Set value... .meansCounter 2 .speaker_code
	Set value... .meansCounter 3 .vowel_code
	Set value... .meansCounter 4 '.f1Mean:3'
	Set value... .meansCounter 5 '.f2Mean:3'
	Set value... .meansCounter 6 '.f3Mean:3'
	Set value... .meansCounter 7 '.f0Mean:3'
	Sort by column... 2 3
endproc

procedure getFs .speakerTable
	select .speakerTable
	Sort by column... 2 3
	.tempSpeakerTable = To Table... rowLabel
	.fleeceMeanF1 = Get minimum...  f1
	.fleeceMeanF2 = Get maximum... f2
	.gooseMeanF1 = .fleeceMeanF1
	.gooseMeanF2 = .fleeceMeanF1
	.trapMeanF1 = Get maximum... f1
	.trapMeanF2 = (.fleeceMeanF2 + .gooseMeanF2 )/ 2
	.f1S = ((.fleeceMeanF1 + .trapMeanF1 + .gooseMeanF1) / 3)
	.f2S = ((.fleeceMeanF2 + .trapMeanF2 + .gooseMeanF2) / 3)
	Remove
	select .speakerTable
endproc

procedure getMeansS .speakerTable .meansTable .vowelCounter
select globalMeansTable
Sort by column... 2 3
select .speakerTable
for .i from 1 to .vowelCounter
	select .speakerTable
	Sort by column... 2 3
	#.vowelCode = getUniqueVowels.vowels [.i]
	.vowelCode = Get value... .i 3
	.speakerCode = Get value... .i 2
	.f1Mean = Get value... .i 4
	.f2Mean = Get value... .i 5
	.f1sf1 = .f1Mean / getFs.f1S
	.f2sf2 = .f2Mean / getFs.f2S
	select globalMeansTable
	normalizeWF.meansCounter += 1
	Set value... normalizeWF.meansCounter 8 '.f1sf1:3'
	Set value... normalizeWF.meansCounter 9 '.f2sf2:3'
	Set value... normalizeWF.meansCounter 12 'getFs.f1S:3'
	Set value... normalizeWF.meansCounter 13 'getFs.f2S:3'
endfor
endproc
procedure getIndividualVowels .speakerNumber
.globalRowCounter = 0
select masterGlobalTable
Insert column (index)... 17
Insert column (index)... 18
Set column label (index)... 17 f1s
Set column label (index)... 18 f2s
.speakerCheck = Copy... speakerCheck
	for .i from 1 to .speakerNumber
		Insert row (index)... .i
		Set value... .i 2 .i
	endfor
	for .speakerCode from 1 to .speakerNumber
		select .speakerCheck
		.speaker'.speakerCode' = Extract rows where column... 2 "equal to" .speakerCode
		Rename... speaker'.speakerCode'
		#Check for dummy row
		.nrow = Get number of rows
		if .nrow = 1
			printline Speaker '.speakerCode' is missing
		else
			Sort by column... 2 0
			.dummy = Get value... 1 3
			if .dummy == 0
				Remove row (index)... 1
			endif
			.nrowIdv = Get number of rows
			for .i from 1 to .nrowIdv
				select .speaker'.speakerCode'
				.f1 = Get value... .i 4
				.f2 = Get value... .i 5
				.vowel_pk = Get value... .i 16
				.vowel_ipa$ = Get row label... .i
				.sex_code = Get value... .i 1
				.speaker_code = Get value... .i 2
				.vowel_code = Get value... .i 3
				.f3_norm = Get value... .i 6
				.f0 = Get value... .i 7
				.place_p_code  = Get value... .i 8
				.manner_p_code  = Get value... .i 9
				.voice_p_code  = Get value... .i 10
				.place_f_code  = Get value... .i 11
				.manner_f_code  = Get value... .i 12
				.voice_f_code  = Get value... .i 13
				.category_1_code  = Get value... .i 14
				.category_2_code  = Get value... .i 15
				select globalMeansTable
				.speakerTemp'.speakerCode' = Extract rows where column... 2 "equal to" .speakerCode
				Rename... speakerTemp'.speakerCode'
				Sort by column... 2 0
				.f1S = Get value... 1 12
				.f2S = Get value... 1 13
				.f1Sf1 = .f1 / .f1S
				.f2Sf2 = .f2 / .f2S
				Remove
				.f1_norm = '.f1Sf1:3'
				.f2_norm = '.f2Sf2:3'
				select masterGlobalTable
				#printline '.vowel_pk''tab$''.f1Sf1:3''tab$''.f2Sf2:3''tab$''.f1S'
				fileappend "'file$'" 'newline$''.vowel_ipa$''tab$''.sex_code''tab$''.speaker_code''tab$''.vowel_code''tab$'
... '.f1_norm''tab$''.f2_norm''tab$''.f3_norm:0''tab$'
... '.f0:0''tab$''.place_p_code''tab$''.manner_p_code''tab$''.voice_p_code''tab$'
... '.place_f_code''tab$''.manner_f_code''tab$''.voice_f_code''tab$''.category_1_code''tab$'
... '.category_2_code''tab$''.vowel_pk'
				.globalRowCounter += 1
				Set value... .globalRowCounter 17 .f1_norm
				Set value... .globalRowCounter 18 .f2_norm
			endfor
		endif
		select .speaker'.speakerCode'
		Remove
	endfor
endproc
procedure rescale
select masterGlobalTable
globalMasterRescaled = Copy... globalMasterRescaled
Insert column (index)... 19
Insert column (index)... 20
Set column label (index)... 19 f1n
Set column label (index)... 20 f2n
select globalMeansTable
.tempMeansTable = To Table... rowLabel
Rename... tempMeansTable
.f1Min = Get minimum... f1sf1
.f1Max = Get maximum... f1sf1
.f2Min = Get minimum... f2sf2
.f2Max = Get maximum... f2sf2
Remove
select globalMasterRescaled
.nrow = Get number of rows
for .i from 1 to .nrow
	.f1N = Get value... .i 17
	.f2N = Get value... .i 18
	.f1NR = 250 + (500 * (.f1N  - .f1Min) / (.f1Max - .f1Min ))
	.f2NR = 850 + (1400 * (.f2N  - .f2Min) / (.f2Max - .f2Min ))
	Set value... .i 19 '.f1NR:3'
	Set value... .i 20 '.f2NR:3'
endfor
endproc
print SUMMARY
printline
printline
print 'normalization_type$' normalization completed'newline$'
print Records found = 'records_found''newline$'
print File "'file$'" successfully created'newline$'
print 'file$' added to objects? = 'add_to_objects$'
