# bch disengagement task eye tracking analysis
# Jan 8 2023
# Ran Wei

# GENERATING EVENT DURATIONS BASED ON EEG TAGS --------------------------------
# install.packages("XML")
# install.packages("dplyr")
library("XML")
library("methods")


# IMPORT GAZE DATA  --------------------------------------------------
df_bchdisengagement_301_18mo <- as.data.frame(read.delim("/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/Disengagement_V3_Current-301-18-GazeData.txt", header = TRUE))

############################# STOP HERE: # of Trials ###########################
# how many trials are there in the gaze data 
length(as.data.frame(table(df_bchdisengagement_301_18mo$TrialID))$Var1)
# you should see a number between 0 and 54
############################# GO ###############################################

############################# STOP HERE: Sampling Rate #########################
# check sampling rate in the gaze data 
df_bchdisengagement_301_18mo$RTTime[12] - df_bchdisengagement_301_18mo$RTTime[11]
df_bchdisengagement_301_18mo$RTTime[122] - df_bchdisengagement_301_18mo$RTTime[121]
# you should see "3" twice, meaning we're sampling every 3 ms 
1000/3
# 333.333 samples per second, so basically keeping the default setting = 300hz
# if you see numbers other than 3 & 3 & 333 above, poke Ran 
############################# GO ###############################################

# trial duration = CirStep 1500 + TargetOn 500 + DistractorOn 2600 + StimuliOff 250
# 1500+500+2600+250
# 4850/(1000/300) = 1455
# allowed duration: [4800, 5000] - harmonized across eye trackers 
# 4800/(1000/300)
# 5000/(1000/300)
# the first row represents trial ID
# the second trial represents the duration of each trial
# you shoudd see numbers between 1440 and 1500 (number of time bins in a trial, each bin is 3 ms)

############################# STOP HERE: Trial Duration ########################
# check if all trials are similar in duration (sometimes eprime fails to record the entire trial)
table(df_bchdisengagement_301_18mo$TrialID)
# if a trial is shorter than 1440 or longer than 1500, remove it - there must have been a cutoff or delay
# un-comment codes below if trials are shorter than 1450 or longer than 1500; replace the xxx with trial ID

# df_bchdisengagement_301_18mo <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$TrialID != xxx, ]

# if you excluded a trial, let's confirm again the trial has been excluded  
# length(as.data.frame(table(df_bchdisengagement_301_18mo$TrialID))$Var1)
# you should see the remaining # of trials 
############################# GO ###############################################



# creating ID to mark each row
df_bchdisengagement_301_18mo$ID <- 1:nrow(df_bchdisengagement_301_18mo) 

# hist(df_bchdisengagement_301_18mo$CursorX)
# summary(df_bchdisengagement_301_18mo$CursorX)
# hist(df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye)
# summary(df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye)
# hist(df_bchdisengagement_301_18mo$GazePointPositionDisplayXLeftEye)
# summary(df_bchdisengagement_301_18mo$GazePointPositionDisplayXLeftEye)
# hist(df_bchdisengagement_301_18mo$GazePointPositionDisplayYLeftEye)
# summary(df_bchdisengagement_301_18mo$GazePointPositionDisplayYLeftEye)
# hist(df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye)
# summary(df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye)
# hist(df_bchdisengagement_301_18mo$GazePointValidityLeftEye)
# summary(df_bchdisengagement_301_18mo$GazePointValidityLeftEye)
# hist(df_bchdisengagement_301_18mo$GazePointValidityRightEye)
# summary(df_bchdisengagement_301_18mo$GazePointValidityRightEye)


############################# STOP HERE ########################################
# sanity check: no NAs, meaning you should see a string of 0s from the codes below
sum(is.na(df_bchdisengagement_301_18mo$GazePointPositionDisplayXLeftEye))
sum(is.na(df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye))
sum(is.na(df_bchdisengagement_301_18mo$GazePointPositionDisplayYLeftEye))
sum(is.na(df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye))
sum(is.na(df_bchdisengagement_301_18mo$GazePointValidityLeftEye))
sum(is.na(df_bchdisengagement_301_18mo$GazePointValidityRightEye))
############################# GO ###############################################


# checking validity  ---------------------------------------------
# with Tobii Spectrum, treating validity > 1 as NA
summary(df_bchdisengagement_301_18mo$GazePointValidityLeftEye)
table(df_bchdisengagement_301_18mo$GazePointValidityLeftEye)
summary(df_bchdisengagement_301_18mo$GazePointValidityRightEye)
table(df_bchdisengagement_301_18mo$GazePointValidityRightEye)

# The Tobii Pro X3-120 model can have 0 or 4 validity codes values only, which means eyes were found or not found, correspondently.
# https://connect.tobii.com/s/article/What-Do-Validity-Codes-Mean?language=en_US
# any data with both eyes = 4 should be interpolated 
# this file only has 0 and 1, so everything is valid 
# any data with both eyes >= 2 should be interpolated but there's none
# similar to NZ data 
# commented out all the following codes for validity values other than 1 and 0

### skip ###
# df_bchdisengagement_301_18mo$ValidityLeftPlusRightEye <- df_bchdisengagement_301_18mo$GazePointValidityLeftEye + df_bchdisengagement_301_18mo$GazePointValidityRightEye
# table(df_bchdisengagement_301_18mo$ValidityLeftPlusRightEye)
# checking these points - are the gaze positions uniformly -1?
# df_botheye4 <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$ValidityLeftPlusRightEye == 8, ]
# summary(df_botheye4$GazePointPositionDisplayXLeftEye)
# summary(df_botheye4$GazePointPositionDisplayXRightEye)
# summary(df_botheye4$GazePointPositionDisplayYLeftEye)
# summary(df_botheye4$GazePointPositionDisplayYRightEye)
# yes, in all of these cases the gaze data is missing; no further manipulation needed
### skip ###

# calculating X gaze position based on validity, left eye, and rig --------
# if both eyes have validity = 0 (eye found), average; otherwise, use the good eye
# because validity = 0/1 and can not be negative, then if the sum of left and right eye = 0, then both eyes have good validity
df_bchdisengagement_301_18mo$botheyesvalid <- df_bchdisengagement_301_18mo$GazePointValidityLeftEye + df_bchdisengagement_301_18mo$GazePointValidityRightEye
df_bchdisengagement_301_18mo$botheyesvalid <- ifelse(df_bchdisengagement_301_18mo$botheyesvalid == 0, 1, 0)
summary(df_bchdisengagement_301_18mo$botheyesvalid)


# hence for segments where one eye = -1, replace with the other eye

df_bchdisengagement_301_18mo$lefteyenoX <- ifelse(df_bchdisengagement_301_18mo$GazePointPositionDisplayXLeftEye == -1, 999, 0)
df_bchdisengagement_301_18mo$righteyenoX <- ifelse(df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye == -1, 222, 0)
df_bchdisengagement_301_18mo$missingeye <- df_bchdisengagement_301_18mo$lefteyenoX + df_bchdisengagement_301_18mo$righteyenoX
table(df_bchdisengagement_301_18mo$missingeye)

# if only left eye missing, df_bchdisengagement_301_18mo$missingeye == 999
# if only right eye missing, df_bchdisengagement_301_18mo$missingeye == 222
# if both eyes missing, df_bchdisengagement_301_18mo$missingeye == 1221
# if both eyes intact, df_bchdisengagement_301_18mo$missingeye == 0

# !!! THE FOLLOWING LINES ARE SEQUENTIAL AND SHOULD BE RUN TOGETHER 
# it doesn't matter GazePointPositionDisplay is negative or positive - take an average first 
df_bchdisengagement_301_18mo$gazepointpositiondisplayX <- (df_bchdisengagement_301_18mo$GazePointPositionDisplayXLeftEye + df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye)/2

# if left eye missing, replace with right eye data 
df_bchdisengagement_301_18mo$gazepointpositiondisplayX <- ifelse(df_bchdisengagement_301_18mo$missingeye == 999, 
                                                         df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye, 
                                                         df_bchdisengagement_301_18mo$gazepointpositiondisplayX)
# if right eye missing, replace with left eye data 
df_bchdisengagement_301_18mo$gazepointpositiondisplayX <- ifelse(df_bchdisengagement_301_18mo$missingeye == 222, 
                                                         df_bchdisengagement_301_18mo$GazePointPositionDisplayXLeftEye, 
                                                         df_bchdisengagement_301_18mo$gazepointpositiondisplayX)
# if both eyes missing, replace with -1 
df_bchdisengagement_301_18mo$gazepointpositiondisplayX <- ifelse(df_bchdisengagement_301_18mo$missingeye == 1221, 
                                                                  -1, 
                                                                   df_bchdisengagement_301_18mo$gazepointpositiondisplayX)

#### END OF SEQUENCE

datlefteyemissing <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$GazePointPositionDisplayXLeftEye == -1, ]
datrighteyemissing <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye == -1, ]



############################# STOP HERE ########################################
# check the outputs below
# if left eye missing but right eye not missing
# then gazepointpositiondisplayX = GazePointPositionDisplayXRightEye
datonlylefteyemissing <- datlefteyemissing[datlefteyemissing$GazePointPositionDisplayXRightEye != -1, ]
summary(datonlylefteyemissing$gazepointpositiondisplayX - datonlylefteyemissing$GazePointPositionDisplayXRightEye)
# all 0 - check!

# if RIGHT eye missing but LEFT eye not missing
# then gazepointpositiondisplayX = GazePointPositionDisplayXLeftEye
datonlyrighteyemissing <- datrighteyemissing[datrighteyemissing$GazePointPositionDisplayXLeftEye != -1, ]
summary(datonlyrighteyemissing$gazepointpositiondisplayX - datonlyrighteyemissing$GazePointPositionDisplayXLeftEye)
# all 0 - check!

# if both eyes missing, gazepointpositiondisplayX = -1 
datbotheyemissing <- datlefteyemissing[datlefteyemissing$GazePointPositionDisplayXRightEye == -1, ]
summary(datbotheyemissing$gazepointpositiondisplayX)
# all should be -1; check!

# if neither eye missing, gazepointpositiondisplayX = average between left and right eye 
datnoeyemissing <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$GazePointPositionDisplayXRightEye != -1, ]
datnoeyemissing <- datnoeyemissing[datnoeyemissing$GazePointPositionDisplayXLeftEye != -1, ]
summary(datnoeyemissing$gazepointpositiondisplayX - ((datnoeyemissing$GazePointPositionDisplayXLeftEye + datnoeyemissing$GazePointPositionDisplayXRightEye)/2))
# all 0 - check! 
############################# GO ###############################################


# calculating Y gaze position based on validity, left eye, and rig --------

df_bchdisengagement_301_18mo$lefteyenoY <- ifelse(df_bchdisengagement_301_18mo$GazePointPositionDisplayYLeftEye == -1, 999, 0)
df_bchdisengagement_301_18mo$righteyenoY <- ifelse(df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye == -1, 222, 0)
df_bchdisengagement_301_18mo$missingeye <- df_bchdisengagement_301_18mo$lefteyenoY + df_bchdisengagement_301_18mo$righteyenoY
table(df_bchdisengagement_301_18mo$missingeye)

# if only left eye missing, df_bchdisengagement_301_18mo$missingeye == 999
# if only right eye missing, df_bchdisengagement_301_18mo$missingeye == 222
# if both eyes missing, df_bchdisengagement_301_18mo$missingeye == 1221
# if both eyes intact, df_bchdisengagement_301_18mo$missingeye == 0

# !!! THE FOLLOWING LINES ARE SEQUENTIAL AND SHOULD BE RUN TOGETHER 
# it doesn't matter GazePointPositionDisplay is negative or positive - take an average first 
df_bchdisengagement_301_18mo$gazepointpositiondisplayY <- (df_bchdisengagement_301_18mo$GazePointPositionDisplayYLeftEye + df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye)/2

# if left eye missing, replace with right eye data 
df_bchdisengagement_301_18mo$gazepointpositiondisplayY <- ifelse(df_bchdisengagement_301_18mo$missingeye == 999, 
                                                                   df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye, 
                                                                   df_bchdisengagement_301_18mo$gazepointpositiondisplayY)
# if right eye missing, replace with left eye data 
df_bchdisengagement_301_18mo$gazepointpositiondisplayY <- ifelse(df_bchdisengagement_301_18mo$missingeye == 222, 
                                                                   df_bchdisengagement_301_18mo$GazePointPositionDisplayYLeftEye, 
                                                                   df_bchdisengagement_301_18mo$gazepointpositiondisplayY)
# if both eyes missing, replace with -1 
df_bchdisengagement_301_18mo$gazepointpositiondisplayY <- ifelse(df_bchdisengagement_301_18mo$missingeye == 1221, 
                                                                   -1, 
                                                                   df_bchdisengagement_301_18mo$gazepointpositiondisplayY)

#### END OF SEQUENCE

datlefteyemissing <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$GazePointPositionDisplayYLeftEye == -1, ]
datrighteyemissing <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye == -1, ]



############################# STOP HERE ########################################
# check the outputs below
# if left eye missing but right eye not missing
# then gazepointpositiondisplayY = GazePointPositionDisplayYRightEye
datonlylefteyemissing <- datlefteyemissing[datlefteyemissing$GazePointPositionDisplayYRightEye != -1, ]
summary(datonlylefteyemissing$gazepointpositiondisplayY - datonlylefteyemissing$GazePointPositionDisplayYRightEye)
# all 0 - check!

# if RIGHT eye missing but LEFT eye not missing
# then gazepointpositiondisplayY = GazePointPositionDisplayYLeftEye
datonlyrighteyemissing <- datrighteyemissing[datrighteyemissing$GazePointPositionDisplayYLeftEye != -1, ]
summary(datonlyrighteyemissing$gazepointpositiondisplayY - datonlyrighteyemissing$GazePointPositionDisplayYLeftEye)
# all 0 - check!

# if both eyes missing, gazepointpositiondisplayY = -1 
datbotheyemissing <- datlefteyemissing[datlefteyemissing$GazePointPositionDisplayYRightEye == -1, ]
summary(datbotheyemissing$gazepointpositiondisplayY)
# all should be -1; check!

# if neither eye missing, gazepointpositiondisplayY = average between left and right eye 
datnoeyemissing <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$GazePointPositionDisplayYRightEye != -1, ]
datnoeyemissing <- datnoeyemissing[datnoeyemissing$GazePointPositionDisplayYLeftEye != -1, ]
summary(datnoeyemissing$gazepointpositiondisplayY - ((datnoeyemissing$GazePointPositionDisplayYLeftEye + datnoeyemissing$GazePointPositionDisplayYRightEye)/2))
# all 0 - check! 
############################# GO ###############################################


# INTERPOLATION ----------------------------------------------------------
# Leppänen paper:
# The threshold for the longest interpolated (nonvalid) segment was set to 200 ms; 
# data recorded at 300 Hz
# To be conservative, I set it to 11 segs: 100 ms



# X Axis interpolation ---------------------------------------------------------------

# creating new columns gazepointpositiondisplayX_ITP gazepointpositiondisplayY_ITP
# so that we can replace all -1 with NA 
# and then forward fill all the NAs with the last observation 

df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPprep <- df_bchdisengagement_301_18mo$gazepointpositiondisplayX
df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPprep[df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPprep == "-1"] <- NA
na_DF <- df_bchdisengagement_301_18mo[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPprep), ] 
# sanity check: this na_DF lists all the rows that were previously -1 but are now NA

library("zoo")
library("dplyr")

# with these dplyr package calls, remember to have ARRANGE because datasets are not always
# arranged according RTTime
# which introduces problems when we take the first row of a particular dataframe 
# to get onset time/SRT
## NEED TO CHANGE MAXGAP BASED ON SAMPLING RATE HERE#

# max gap = 30 = 100/(1000/300)
# consistent with NZ 


df_bchdisengagement_301_18mo <- df_bchdisengagement_301_18mo %>% 
  arrange(RTTime) %>%
  group_by(TrialID) %>%
  mutate(gazepointpositiondisplayX_ITP = na.locf(gazepointpositiondisplayX_ITPprep, na.rm = FALSE, maxgap = 30)) %>% 
  ungroup()
df_bchdisengagement_301_18mo <- as.data.frame(df_bchdisengagement_301_18mo)
# manuall checked spreadsheet: gaps with 11 cells were interpolated, whereas gaps with 12 rows were not interpolated


# X BORDERCHECK ------------------------------------------------------

# X objectdisplay -----------------------------------------------------
# regardless of what's on the screen, we're not interpolating gazes that cross borders 
# object display = what is on the screen
# see LEAP bch Disengagement Notes for screen layout 


# CurrentOnscreenObject versus CurrentOnscreenObject  -----------------------------
# library("stringr")
# df_bchdisengagement_301_18mo$CurrentObject_CurrentOnscreenObject <- str_c(df_bchdisengagement_301_18mo$CurrentObject, "_", 
#                                                  df_bchdisengagement_301_18mo$CurrentOnscreenObject)

# table(df_bchdisengagement_301_18mo$CurrentObject_CurrentOnscreenObject)
# they are different
# based on the TETsetgazedataproperty package calls, CurrentOnscreenObject is accurate 
# also manually checked the spreadsheet; CurrentOnscreenObject is accurate

# removing the CurrentObject variable so it doesn't get mistakenly used
df_bchdisengagement_301_18mo$CurrentObject <- NULL

# table(df_bchdisengagement_301_18mo$CurrentOnscreenObject)
# cirstep 24570*(1000/300)/54
# DistractOn 42118*(1000/300)/54
# StimuliOff 4230*(1000/300)/54
# TargetOn 8100*(1000/300)/54
# the segment durations checked out 

# replacing cirstep with Fixation to be consistent with Dhaka data 
df_bchdisengagement_301_18mo$CurrentOnscreenObject[df_bchdisengagement_301_18mo$CurrentOnscreenObject == "CirStep"] <- "Fixation"


# determining the correct position by time period
library("stringr")
df_bchdisengagement_301_18mo$correctpos <- str_c(df_bchdisengagement_301_18mo$CurrentOnscreenObject, "_", 
                                                           df_bchdisengagement_301_18mo$DistractLoc)
table(df_bchdisengagement_301_18mo$correctpos)

df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "_Left"] <- 9999 #child could look anywhere as long as on screen 
df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "_Right"] <- 9999
df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "Fixation_Left"] <- 9999
df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "Fixation_Right"] <- 9999
df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "StimuliOff_Left"] <- 9999
df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "StimuliOff_Right"] <- 9999

df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "DistractOn_Left"] <- 2
df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "DistractOn_Right"] <- 6

df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "TargetOn_Left"] <- 4
df_bchdisengagement_301_18mo$correctpos[df_bchdisengagement_301_18mo$correctpos == "TargetOn_Right"] <- 4
df_bchdisengagement_301_18mo$correctpos <- as.numeric(df_bchdisengagement_301_18mo$correctpos)
table(df_bchdisengagement_301_18mo$correctpos)

# X border violation check --------------------------------------------------
# Check before and after interpolations the gaze did not cross AOI border 

# STEPS:
# i. find all AOI transitions
# ii. based on X gazepos raw data, remove all NA rows
# iii. if the rows before NA and after NA belong in different aois, the interpolation in between is a border violation
# iv. switches from 0 (exactly the edge of the screen) to 1 or 1 to 0 should not be considered as border violations  

# i. rawbordercheck: find all AOI transitions -----------------------------

# creating a rawbordercheck variable with X gazepos raw data 
# table(df_bchdisengagement_301_18mo$gazepointpositiondisplayX)

df_bchdisengagement_301_18mo$gazepointpositiondisplayX[df_bchdisengagement_301_18mo$gazepointpositiondisplayX == -1] <- NA
df_bchdisengagement_301_18mo$rawbordercheckX <- findInterval(df_bchdisengagement_301_18mo$gazepointpositiondisplayX, c(-0.0000001, 0.2799999, 0.2800001, 0.7199999, 0.7200001, 1.0000001)) 
df_bchdisengagement_301_18mo$gazepointpositiondisplayX[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayX)] <- -1
table(df_bchdisengagement_301_18mo$rawbordercheckX)
# 2 missing, meaning there are no looks on the border between face and left distractor
# but keeping those aois anyways in case there are looks that fall on the border from other files 

df_bchdisengagement_301_18mo$rawbordercheckX[is.na(df_bchdisengagement_301_18mo$rawbordercheckX)] <- -2
df_bchdisengagement_301_18mo$rawbordercheckX[df_bchdisengagement_301_18mo$rawbordercheckX == 6] <- 7
df_bchdisengagement_301_18mo$rawbordercheckX[df_bchdisengagement_301_18mo$rawbordercheckX == 5] <- 6
df_bchdisengagement_301_18mo$rawbordercheckX[df_bchdisengagement_301_18mo$rawbordercheckX == 4] <- 5
df_bchdisengagement_301_18mo$rawbordercheckX[df_bchdisengagement_301_18mo$rawbordercheckX == 3] <- 4
df_bchdisengagement_301_18mo$rawbordercheckX[df_bchdisengagement_301_18mo$rawbordercheckX == 2] <- 3
df_bchdisengagement_301_18mo$rawbordercheckX[df_bchdisengagement_301_18mo$rawbordercheckX == 1] <- 2
df_bchdisengagement_301_18mo$rawbordercheckX[df_bchdisengagement_301_18mo$rawbordercheckX == 0] <- 1
# table(df_bchdisengagement_301_18mo$rawbordercheckX)

# -2: missing data (if else statements don't deal with NAs so had to replace NAs with -2)
# 1: looking beyond the left edge of the screen 
# 2: left distractor aoi
# 3: looking to left border between face and distractor 
# 4: face
# 5: looking to right border between face and distractor 
# 6: right distractor aoi
# 7: looking beyond the right edge of the screen 
# these have to be consecutive integers (except for missing data) for later border violation checks 


# ii. removing all NA -----------------------------------------------------

# keeping all the data 
df_bchdisengagement_301_18mo_NAex_X <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$gazepointpositiondisplayX != -1, ]
# need to create a unique row number based on the NAex dataset so we can pick up the other end of the interpolation
df_bchdisengagement_301_18mo_NAex_X$rownum_naex <- 1:nrow(df_bchdisengagement_301_18mo_NAex_X) 
table(df_bchdisengagement_301_18mo_NAex_X$rawbordercheckX) 
# all the missingness is gone - you don't see any -2

# iii. transition in aoi --------------------------------------------------

# if there's transition in AOI, rawbordercheckX[n] - rawbordercheckX[n-1] != 0 
# this is pulling all the aoi transitions regardless of interpolation or not 
df_bchdisengagement_301_18mo_NAex_X <- df_bchdisengagement_301_18mo_NAex_X %>%
  arrange(RTTime) %>% 
  group_by(TrialID) %>%
  mutate(diff_rawbordercheckX = rawbordercheckX - lag(rawbordercheckX, 1)) %>%
  ungroup()
df_bchdisengagement_301_18mo_NAex_X <- as.data.frame(df_bchdisengagement_301_18mo_NAex_X)

# iv. disconnection in time -----------------------------------------------

# which trials are disconnected according to RTTime? That means there were NAs interspersed in the middle 
df_bchdisengagement_301_18mo_NAex_X <- df_bchdisengagement_301_18mo_NAex_X %>%
  arrange(RTTime) %>% 
  group_by(TrialID) %>%
  mutate(diff_IDgap = ID - lag(ID, 1)) %>%
  ungroup()
df_bchdisengagement_301_18mo_NAex_X <- as.data.frame(df_bchdisengagement_301_18mo_NAex_X)
table(df_bchdisengagement_301_18mo_NAex_X$diff_IDgap) 
# any ID gap > 1 means there's interpolation in between 

# so when rawbordercheckX[n] - rawbordercheckX[n-1] != 0 (there's AOI change)
# and ID gap > 1 (AND there's interpolation between the AOI changes)
# also if ID gaps > 12 (maxgap + 1), interpolation did not happen, and we don't have to worry about those 


# v. find the time stamps and ids that need to be reverted ----------------

## REVISE ID GAP RANGE BASED ON SAMPLING RATE!!!

df_bchdisengagement_301_18mo_rawbordercheckX <- df_bchdisengagement_301_18mo_NAex_X[df_bchdisengagement_301_18mo_NAex_X$diff_rawbordercheckX != 0, ]
df_bchdisengagement_301_18mo_rawbordercheckX <- select(df_bchdisengagement_301_18mo_rawbordercheckX, c("RTTime", "rawbordercheckX", "ID", "rownum_naex", "TrialID"))
df_bchdisengagement_301_18mo_rawbordercheckX$bordercross <- 1

df_bchdisengagement_301_18mo_IDgap_X <- df_bchdisengagement_301_18mo_NAex_X[df_bchdisengagement_301_18mo_NAex_X$diff_IDgap > 1, ]

# the following number should depend on sampling rate
# 100/(1000/300) = 30; put 32 for 300hz to be consistent with NZ
df_bchdisengagement_301_18mo_IDgap_X <- df_bchdisengagement_301_18mo_IDgap_X[df_bchdisengagement_301_18mo_IDgap_X$diff_IDgap < 32, ]
df_bchdisengagement_301_18mo_IDgap_X <- select(df_bchdisengagement_301_18mo_IDgap_X, c("RTTime", "diff_IDgap"))
# "ID", "rownum_naex" columns are no longer needed
# they are in df_bchdisengagement_301_18mo_rawbordercheckX, keeping them would result in duplicates
df_bchdisengagement_301_18mo_IDgap_X$IDgap <- 1

df_bchdisengagement_301_18mo_bordervio_X <- merge(df_bchdisengagement_301_18mo_rawbordercheckX, df_bchdisengagement_301_18mo_IDgap_X, by="RTTime", all = TRUE)

# only keeping rows where both IDgap and bordercross are both 1, meaning complete cases 
df_bchdisengagement_301_18mo_bordervio_X <- df_bchdisengagement_301_18mo_bordervio_X[complete.cases(df_bchdisengagement_301_18mo_bordervio_X), ] 
dim(df_bchdisengagement_301_18mo_bordervio_X) 
dim(table(df_bchdisengagement_301_18mo_bordervio_X$TrialID))

# find the rows and the rownums preceding them (the other end of the interpolation)
vec_bordervio <- as.vector(df_bchdisengagement_301_18mo_bordervio_X$rownum_naex)
df_bchdisengagement_301_18mo_bordervio_X$rownum_naexminus1 <- as.vector(df_bchdisengagement_301_18mo_bordervio_X$rownum_naex - 1)
vec_borderviominus1 <- as.vector(df_bchdisengagement_301_18mo_bordervio_X$rownum_naexminus1)
vec_borderviopull <- sort(c(vec_bordervio, vec_borderviominus1))
df_bchdisengagement_301_18mo_borderlook_X <- df_bchdisengagement_301_18mo_NAex_X[df_bchdisengagement_301_18mo_NAex_X$rownum_naex %in% vec_borderviopull,]


# vi. finding the interpolated trials that need to be reverted --------------------

df_bchdisengagement_301_18mo_borderlook_X <- select(df_bchdisengagement_301_18mo_borderlook_X, c("rawbordercheckX", "RTTime", "rownum_naex", "ID", "TrialID"))
df_bchdisengagement_301_18mo_borderlook_X <- df_bchdisengagement_301_18mo_borderlook_X %>%
  arrange(RTTime) %>% 
  ungroup()
df_bchdisengagement_301_18mo_borderlook_X <- as.data.frame(df_bchdisengagement_301_18mo_borderlook_X)
# easier to see a spreadsheet and color the ok rows to figure out the most efficient exclusion strategy 
write.csv(df_bchdisengagement_301_18mo_borderlook_X, 
          file = "/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/leap_bch_disengagement_processed_data/df_bchdisengagement_301_18mo_borderlook_X.csv", row.names = TRUE )

df_bchdisengagement_301_18mo_fullselected_X <- select(df_bchdisengagement_301_18mo, c("RTTime", "rawbordercheckX", "ID", "CursorX", "gazepointpositiondisplayX_ITP"))

write.csv(df_bchdisengagement_301_18mo_fullselected_X, 
          file = "/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/leap_bch_disengagement_processed_data/df_bchdisengagement_301_18mo_fullselected_X.csv", row.names = TRUE )




############################# STOP HERE ########################################
# check which trial has an odd number of rows to determine if we need to duplicate rows
table(df_bchdisengagement_301_18mo_borderlook_X$TrialID)
# copy and paste first row in the table below
# 23


# open rawborderlook & fullselected spreadsheets and start a coloring party :)
# (1) if you colored some rows orange in the rawbordercheck spreadsheet, run section [1]
# (2) if all rows are green in the rawbordercheck spreadsheet, run section [2]
# (3) if you see < table of extent 0 > from running the command "table(df_...$TrialID)" above, go directly to "section [3]"
# REMEMBER: "comment out" the sections you did not run by adding a # at the beginning of EACH row
# when you comment out codes, ALL LINES should turn green 
# alternatively, if you're turning comments into codes, delete the # and 1 space following it (#[SPACE])


#############################
# SECTION [1]
# need to insert a line before ID = xxx for numbering and replacing purposes
# df_bchdisengagement_301_18mo_borderlook_X_expanded <- df_bchdisengagement_301_18mo_borderlook_X[rep(row.names(df_bchdisengagement_301_18mo_borderlook_X), 
#                                                                                                     ifelse(df_bchdisengagement_301_18mo_borderlook_X$ID %in% c(2566,4580,9409,10680,12590,12846,14426,14440,15241,15269,16720,23252,23380,23787,31535), 2, 1)),]

# check which trial has an odd number of rows - there should be none
# table(df_bchdisengagement_301_18mo_borderlook_X_expanded$TrialID)

# if you see an odd number in the 2nd row of the output
# go back to that trial and check coloring
# if you only see even numbers in the 2nd row, keep going
# if anything strange happens here, poke Ran 
#############################


#############################
# SECTION [2]
# if all rows are green in the rawbordercheck spreadsheet, run the following section  
df_bchdisengagement_301_18mo_borderlook_X_expanded <- df_bchdisengagement_301_18mo_borderlook_X

# check which trial has an odd number of rows - there should be none
table(df_bchdisengagement_301_18mo_borderlook_X_expanded$TrialID)
############################# GO ###############################################


############################# SECTION 1 & 2 ONLY ###############################
# run the following codes for section 1 and 2; skip if running section 3 
# no need to run line by line; just run until you see the next STOP sign

vec_numX <- dim(df_bchdisengagement_301_18mo_borderlook_X_expanded)/2
df_bchdisengagement_301_18mo_borderlook_X_expanded$pair <- rep(1:vec_numX[1], each=2)

# vii. finding the interpolated ids ---------------------------------------

# finding the IDs in between each pair of IDs
# create pairs as a grouping variable: 

numpair <- length(df_bchdisengagement_301_18mo_borderlook_X_expanded$TrialID)/2
df_bchdisengagement_301_18mo_borderlook_X_expanded$pair <- rep(1:numpair, each=2)
vec_pair <- as.vector(df_bchdisengagement_301_18mo_borderlook_X_expanded$pair)
list_pair <- with(df_bchdisengagement_301_18mo_borderlook_X_expanded, split(df_bchdisengagement_301_18mo_borderlook_X_expanded, pair)) 

# find the integers between 2 values
inbetween_integers <- function(a, b) {
  u <- sort(c(a, b))
    res <- setdiff(ceiling(u[1]):floor(u[2]), c(a, b))
    if (!length(res)) {
        NULL
      } else {
        res
      }
  }

library(magicfor)               
magic_for(print, silent = TRUE)
for (i in 1:length(list_pair)) {
  output <- put(inbetween_integers(list_pair[[i]]$ID[1], list_pair[[i]]$ID[2]))
    output
  }
df_empty <- magic_result_as_dataframe()
df_empty <- as.data.frame(df_empty)
output <- unlist(df_empty$output)
output <- as.data.frame(output)
vec_empty <- as.vector(output$output)




############################# STOP HERE ########################################
# check that these rows
dat_checkx <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$ID %in% vec_empty, ] 
summary(dat_checkx$gazepointpositiondisplayX)
# should be -1s


# gazepointpositiondisplayX_ITP 
summary(dat_checkx$gazepointpositiondisplayX_ITP)
# should not be empty because these rows were initially interpolated and should be reverted
# what you see are numbers, not NA 

sum(is.na(dat_checkx$gazepointpositiondisplayX_ITP))
# here you should see 0 
############################# GO ###############################################


# creating a new column for reverted interpolation
df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITP_edited <- ifelse (df_bchdisengagement_301_18mo$ID %in% vec_empty, NA, df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITP)

############################# END OF SECTION 1 & 2 #############################

############################# SECTION 3 ########################################
# df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITP_edited <- df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITP
# REMEMBER: comment out all lines above you didn't run, up until "# SECTION [1]"
############################# GO ###############################################



# 4. SMOOTHING -----------------------------------------------------------
# Leppänen paper:
# "A 37-sample median filter was used to filter the data, equaling 123 ms for data sample at 300 Hz; 
# this median filter was considered sufficient to remove technical artifacts without losing important 
# data such as saccades that typically take 100–130 ms to program"
# needed an odd number so I chose 11 not an even number like 10 or 12
# UPDATED BASED ON SAMPLING RATE!!

# checked this rollapply method against the previous rollmedian method
# the only difference is:
# rollapply can take na.rm (when an even number of rows, median = sum of two middles and divide by 2)
# hence reducing the first 3 NAs and the last 3 NAs
# as well as NAs resulting from missing data in the middle of the trial


df_bchdisengagement_301_18mo <- df_bchdisengagement_301_18mo %>%
  arrange(RTTime) %>% 
  group_by(TrialID) %>%
  mutate(gazepointpositiondisplayX_ITPsmooth_over = zoo::rollapply(gazepointpositiondisplayX_ITP_edited, 
                                                              width = 31, 
                                                              FUN = function(x) median(x, na.rm = TRUE), 
                                                              by = 1, 
                                                              by.column = TRUE, 
                                                              partial = TRUE, 
                                                              fill = NA)) %>% 
  ungroup()
df_bchdisengagement_301_18mo <- as.data.frame(df_bchdisengagement_301_18mo)

# ALL THE ROWS THAT WERE NAs in the ITP_editted column should also be NAs in the smoothed column
# the way we're smoothing the data fills in some of the missing cells

df_bchdisengagement_301_18mo_NArows <- df_bchdisengagement_301_18mo[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITP_edited), ]
vec_smoothrevert <- as.vector(df_bchdisengagement_301_18mo_NArows$ID)  
df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPsmooth <- df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPsmooth_over
df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPsmooth <- ifelse (df_bchdisengagement_301_18mo$ID %in% vec_smoothrevert, -2, df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPsmooth)



# Y AXIS INTERPOLATION ----------------------------------------------------------
# Leppänen paper:
# The threshold for the longest interpolated (nonvalid) segment was set to 200 ms; 
# data recorded at 120 Hz
# To be conservative, I set it to 11 segs: 100 ms

# creating new columns gazepointpositiondisplayY_ITP gazepointpositiondisplayY_ITP
# so that we can replace all -1 with NA 
# and then forward fill all the NAs with the last observation 

df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPprep <- df_bchdisengagement_301_18mo$gazepointpositiondisplayY
df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPprep[df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPprep == "-1"] <- NA
na_DF <- df_bchdisengagement_301_18mo[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPprep), ] 
# sanity check: this na_DF lists all the rows that were previously -1 but are now NA

library("zoo")
library("dplyr")

# with these dplyr package calls, remember to have ARRANGE because datasets are not always
# arranged according RTTime
# which introduces problems when we take the first row of a particular dataframe 
# to get onset time/SRT
## NEED TO CHANGE MAXGAP HERE ##

df_bchdisengagement_301_18mo <- df_bchdisengagement_301_18mo %>% 
  arrange(RTTime) %>%
  group_by(TrialID) %>%
  mutate(gazepointpositiondisplayY_ITP = na.locf(gazepointpositiondisplayY_ITPprep, na.rm = FALSE, maxgap = 30)) %>% 
  ungroup()
df_bchdisengagement_301_18mo <- as.data.frame(df_bchdisengagement_301_18mo)

# Y border violation check --------------------------------------------------
# Check before and after interpolations the gaze did not cross AOI border 

# STEPS:
# i. find all AOI transitions
# ii. based on Cursor Y raw data, remove all NA rows
# iii. if the rows before NA and after NA belong in different aois, the interpolation in between is a border violation
# iv. switches from 0 to 1 or 1 to 0 should not be considered as border violations  

# i. rawbordercheck: find all AOI transitions -----------------------------

# creating a rawbordercheck variable with CursorY raw data 

df_bchdisengagement_301_18mo$gazepointpositiondisplayY[df_bchdisengagement_301_18mo$gazepointpositiondisplayY == -1] <- NA
# contrary to X, we only care if child is looking to the screen or not 
df_bchdisengagement_301_18mo$rawbordercheckY <- findInterval(df_bchdisengagement_301_18mo$gazepointpositiondisplayY, c(-0.0000001, 1.0000001)) 
df_bchdisengagement_301_18mo$gazepointpositiondisplayY[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayY)] <- -1
table(df_bchdisengagement_301_18mo$rawbordercheckY)

df_bchdisengagement_301_18mo$rawbordercheckY[is.na(df_bchdisengagement_301_18mo$rawbordercheckY)] <- -2
df_bchdisengagement_301_18mo$rawbordercheckY[df_bchdisengagement_301_18mo$rawbordercheckY == 2] <- 3
df_bchdisengagement_301_18mo$rawbordercheckY[df_bchdisengagement_301_18mo$rawbordercheckY == 1] <- 2
df_bchdisengagement_301_18mo$rawbordercheckY[df_bchdisengagement_301_18mo$rawbordercheckY == 0] <- 1
table(df_bchdisengagement_301_18mo$rawbordercheckY)

# -2: missing data (if else statements don't deal with NAs so had to replace NAs with -2)
# 1: looking beyond the top edge of the screen 
# 2: on screen
# 3: looking beyond the bottom edge of the screen 
# these have to be consecutive integers (except for missing data) for later border violation checks 


# ii. removing all NA -----------------------------------------------------

# keeping all the data 
df_bchdisengagement_301_18mo_NAex_Y <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$gazepointpositiondisplayY != -1, ]
# need to create a unique row number based on the NAex dataset so we can pick up the other end of the interpolation
df_bchdisengagement_301_18mo_NAex_Y$rownum_naex <- 1:nrow(df_bchdisengagement_301_18mo_NAex_Y) 
table(df_bchdisengagement_301_18mo_NAex_Y$rawbordercheckY) 
# all the missingness is gone - you don't see any -2

# iii. transition in aoi --------------------------------------------------

# if there's transition in AOI, rawbordercheckY[n] - rawbordercheckY[n-1] != 0 
# this is pulling all the aoi transitions regardless of interpolation or not 
df_bchdisengagement_301_18mo_NAex_Y <- df_bchdisengagement_301_18mo_NAex_Y %>%
  arrange(RTTime) %>% 
  group_by(TrialID) %>%
  mutate(diff_rawbordercheckY = rawbordercheckY - lag(rawbordercheckY, 1)) %>%
  ungroup()
df_bchdisengagement_301_18mo_NAex_Y <- as.data.frame(df_bchdisengagement_301_18mo_NAex_Y)

# iv. disconnection in time -----------------------------------------------

# which trials are disconnected according to RTTime? That means there were NAs interspersed in the middle 
df_bchdisengagement_301_18mo_NAex_Y <- df_bchdisengagement_301_18mo_NAex_Y %>%
  arrange(RTTime) %>% 
  group_by(TrialID) %>%
  mutate(diff_IDgap = ID - lag(ID, 1)) %>%
  ungroup()
df_bchdisengagement_301_18mo_NAex_Y <- as.data.frame(df_bchdisengagement_301_18mo_NAex_Y)
table(df_bchdisengagement_301_18mo_NAex_Y$diff_IDgap) 
# any ID gap > 1 means there's interpolation in between 

# so when rawbordercheckY[n] - rawbordercheckY[n-1] != 0 (there's AOI change)
# and ID gap > 1 (AND there's interpolation between the AOI changes)
# also if ID gaps > maxgap + 1, interpolation did not happen, and we don't have to worry about those 
# when 1 < id_gap < maxgap + 2, the interpolation should be reverted to NA

# v. find the time stamps and ids that need to be reverted ----------------
df_bchdisengagement_301_18mo_rawbordercheckY <- df_bchdisengagement_301_18mo_NAex_Y[df_bchdisengagement_301_18mo_NAex_Y$diff_rawbordercheckY != 0, ]
df_bchdisengagement_301_18mo_rawbordercheckY <- select(df_bchdisengagement_301_18mo_rawbordercheckY, c("RTTime", "rawbordercheckY", "ID", "rownum_naex", "TrialID"))
df_bchdisengagement_301_18mo_rawbordercheckY$bordercross <- 1

# need to update based on sampling rate!! 
df_bchdisengagement_301_18mo_IDgap_Y <- df_bchdisengagement_301_18mo_NAex_Y[df_bchdisengagement_301_18mo_NAex_Y$diff_IDgap > 1, ]
df_bchdisengagement_301_18mo_IDgap_Y <- df_bchdisengagement_301_18mo_IDgap_Y[df_bchdisengagement_301_18mo_IDgap_Y$diff_IDgap < 32, ]
df_bchdisengagement_301_18mo_IDgap_Y <- select(df_bchdisengagement_301_18mo_IDgap_Y, c("RTTime", "diff_IDgap"))
# "ID", "rownum_naex" columns are no longer needed
# they are in df_bchdisengagement_301_18mo_rawbordercheckY, keeping them would result in duplicates
df_bchdisengagement_301_18mo_IDgap_Y$IDgap <- 1

df_bchdisengagement_301_18mo_bordervio_Y <- merge(df_bchdisengagement_301_18mo_rawbordercheckY, df_bchdisengagement_301_18mo_IDgap_Y, by="RTTime", all = TRUE)

# only keeping rows where both IDgap and bordercross are both 1, meaning complete cases 
df_bchdisengagement_301_18mo_bordervio_Y <- df_bchdisengagement_301_18mo_bordervio_Y[complete.cases(df_bchdisengagement_301_18mo_bordervio_Y), ] 
dim(df_bchdisengagement_301_18mo_bordervio_Y) 
dim(table(df_bchdisengagement_301_18mo_bordervio_Y$TrialID))


# find the rows and the rownums preceding them (the other end of the interpolation)
vec_bordervio <- as.vector(df_bchdisengagement_301_18mo_bordervio_Y$rownum_naex)
df_bchdisengagement_301_18mo_bordervio_Y$rownum_naexminus1 <- as.vector(df_bchdisengagement_301_18mo_bordervio_Y$rownum_naex - 1)
vec_borderviominus1 <- as.vector(df_bchdisengagement_301_18mo_bordervio_Y$rownum_naexminus1)
vec_borderviopull <- sort(c(vec_bordervio, vec_borderviominus1))
df_bchdisengagement_301_18mo_borderlook_Y <- df_bchdisengagement_301_18mo_NAex_Y[df_bchdisengagement_301_18mo_NAex_Y$rownum_naex %in% vec_borderviopull,]


# vi. finding the interpolated trials that need to be reverted -----------------
df_bchdisengagement_301_18mo_borderlook_Y <- select(df_bchdisengagement_301_18mo_borderlook_Y, c("rawbordercheckY", "TrialID", "RTTime", "rownum_naex", "ID"))
df_bchdisengagement_301_18mo_borderlook_Y <- df_bchdisengagement_301_18mo_borderlook_Y %>%
  arrange(RTTime) %>% 
  ungroup()
df_bchdisengagement_301_18mo_borderlook_Y <- as.data.frame(df_bchdisengagement_301_18mo_borderlook_Y)
# easier to see a spreadsheet and color the ok rows to figure out the most efficient exclusion strategy 
write.csv(df_bchdisengagement_301_18mo_borderlook_Y, 
          file = "/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/leap_bch_disengagement_processed_data/df_bchdisengagement_301_18mo_borderlook_Y.csv", row.names = TRUE )

# export the full dataset updated with Y after interpolation

df_bchdisengagement_301_18mo_fullselected_Y <- select(df_bchdisengagement_301_18mo, c("RTTime", "rawbordercheckY", "ID", "CursorY", "gazepointpositiondisplayY_ITP"))

write.csv(df_bchdisengagement_301_18mo_fullselected_Y, 
          file = "/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/leap_bch_disengagement_processed_data/df_bchdisengagement_301_18mo_fullselected_Y.csv", row.names = TRUE )


############################# STOP HERE ########################################
# check which trial has an odd number of rows to determine if we need to duplicate rows
table(df_bchdisengagement_301_18mo_borderlook_Y$TrialID)
# copy and paste the numbers in the first row of the table below
# 4  5 11 13 16 20 25 29 31 43 44 46 53 54 


# open rawborderlook & fullselected spreadsheets and start a coloring party :)
# (1) if you colored some rows orange in the rawbordercheck spreadsheet, run section [1]
# (2) if all rows are green in the rawbordercheck spreadsheet, run section [2]
# (3) if you see < table of extent 0 > from running the command "table(df_bchnirs...$TrialID)", go directly to "section [3]" 
# REMEMBER: "comment out" the lines you did not run by adding a # at the beginning of EACH row
# when you comment out codes, ALL LINES should turn green 


#############################
# SECTION [1]
# need to insert a line before replicated IDs for numbering and replacing purposes
# df_bchdisengagement_301_18mo_borderlook_Y_expanded <- df_bchdisengagement_301_18mo_borderlook_Y[rep(row.names(df_bchdisengagement_301_18mo_borderlook_Y), 
                                                                                    ifelse(df_bchdisengagement_301_18mo_borderlook_Y$ID %in% c(31439), 2, 1)),]

# check which trial has an odd number of rows 
# table(df_bchdisengagement_301_18mo_borderlook_Y_expanded$TrialID)
# if you see an odd number in the 2nd row of the output
# go back to that trial and check coloring
# if you only see even numbers in the 2nd row, keep going
# if anything strange happens here, poke Ran 
#############################


#############################
# SECTION [2]
# if all rows are green in the rawbordercheck spreadsheet, rename the dataset anyway 
# df_bchdisengagement_301_18mo_borderlook_Y_expanded <- df_bchdisengagement_301_18mo_borderlook_Y
# check which trial has an odd number of rows 
# table(df_bchdisengagement_301_18mo_borderlook_Y_expanded$TrialID)
# all trials should have an even number of rows 
#############################


############################# Section 1 & 2 only ###############################
# run the following codes for section 1 and 2; skip if running section 3 
# no need to run line by line; just run until you see the next STOP sign

# vec_numY <- dim(df_bchdisengagement_301_18mo_borderlook_Y_expanded)/2
# df_bchdisengagement_301_18mo_borderlook_Y_expanded$pair <- rep(1:vec_numY[1], each=2)

# vii. finding the interpolated ids ---------------------------------------

# finding the IDs in between each pair of IDs
# create pairs as a grouping variable: 

# numpair <- length(df_bchdisengagement_301_18mo_borderlook_Y_expanded$TrialID)/2
# df_bchdisengagement_301_18mo_borderlook_Y_expanded$pair <- rep(1:numpair, each=2)
# vec_pair <- as.vector(df_bchdisengagement_301_18mo_borderlook_Y_expanded$pair)
# list_pair <- with(df_bchdisengagement_301_18mo_borderlook_Y_expanded, split(df_bchdisengagement_301_18mo_borderlook_Y_expanded, pair)) 

# find the integers between 2 values
# inbetween_integers <- function(a, b) {
#   u <- sort(c(a, b))
#   res <- setdiff(ceiling(u[1]):floor(u[2]), c(a, b))
#   if (!length(res)) {
#     NULL
#   } else {
#     res
#   }
# }

# library(magicfor)               
# magic_for(print, silent = TRUE)
# for (i in 1:length(list_pair)) {
#   output <- put(inbetween_integers(list_pair[[i]]$ID[1], list_pair[[i]]$ID[2]))
#   output
# }
# df_empty <- magic_result_as_dataframe()
# df_empty <- as.data.frame(df_empty)
# output <- unlist(df_empty$output)
# output <- as.data.frame(output)
# vec_empty <- as.vector(output$output)



############################# STOP HERE ########################################
# check that these rows, gazepointpositiondisplayY should be -1
# dat_checkx <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$ID %in% vec_empty, ] 
# summary(dat_checkx$gazepointpositiondisplayY)
# you should see -1s

# gazepointpositiondisplayY_ITP should not be empty because these rows were initially interpolated and should be reverted
# summary(dat_checkx$gazepointpositiondisplayY_ITP)
# you should see a table with non-0 values 

# sum(is.na(dat_checkx$gazepointpositiondisplayY_ITP))
# you should see 0

############################# GO ########################################


# creating a new column for reverted interpolation
# df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITP_edited <- ifelse (df_bchdisengagement_301_18mo$ID %in% vec_empty, NA, df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITP)

############################# END OF SECTION 1 & 2 #############################


############################# SECTION 3  #######################################
df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITP_edited <- df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITP
# REMEMBER: comment out all lines above that you didn't run, up until "# SECTION [1]"
############################# GO ###############################################


# 4. SMOOTHING -----------------------------------------------------------
# Leppänen paper:
# "A 37-sample median filter was used to filter the data, equaling 123 ms for data sample at 300 Hz; 
# this median filter was considered sufficient to remove technical artifacts without losing important 
# data such as saccades that typically take 100–130 ms to program"


# checked this rollapply method against the previous rollmedian method
# the only difference is:
# rollapply can take na.rm (when an even number of rows, median = sum of two middles and divide by 2)
# hence reducing the first 3 NAs and the last 3 NAs
# as well as NAs resulting from missing data in the middle of the trial


df_bchdisengagement_301_18mo <- df_bchdisengagement_301_18mo %>%
  arrange(RTTime) %>% 
  group_by(TrialID) %>%
  mutate(gazepointpositiondisplayY_ITPsmooth_over = zoo::rollapply(gazepointpositiondisplayY_ITP_edited, 
                                                                   width = 31, 
                                                                   FUN = function(x) median(x, na.rm = TRUE), 
                                                                   by = 1, 
                                                                   by.column = TRUE, 
                                                                   partial = TRUE, 
                                                                   fill = NA)) %>% 
  ungroup()
df_bchdisengagement_301_18mo <- as.data.frame(df_bchdisengagement_301_18mo)

# ALL THE ROWS THAT WERE NAs in the ITP_editted column should also be NAs in the smoothed column
# the way we're smoothing the data fills in some of the missing cells

df_bchdisengagement_301_18mo_NArows <- df_bchdisengagement_301_18mo[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITP_edited), ]
vec_smoothrevert <- as.vector(df_bchdisengagement_301_18mo_NArows$ID)  
df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPsmooth <- df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPsmooth_over
df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPsmooth <- ifelse (df_bchdisengagement_301_18mo$ID %in% vec_smoothrevert, -2, df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPsmooth)


# CALCULATING SRT & DT --------------------------------------------------

# calculating aoi hit at each segment --------
# At each segment, which aoi the child is looking at based on interpolated, smoothed data
# we had a rawbordercheck variable but now we're using interpolated, smoothed data 
# these splitting criteria have to be the same as previously defined 
# need to replace NA with -2

df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPsmooth[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPsmooth)] <- -2
df_bchdisengagement_301_18mo$smoothedbordercheckX <- findInterval(df_bchdisengagement_301_18mo$gazepointpositiondisplayX_ITPsmooth, c(-1.9999999, -0.0000001, 0.2799999, 0.2800001, 0.7199999, 0.7200001, 1.0000001)) 
table(df_bchdisengagement_301_18mo$smoothedbordercheckX)
df_bchdisengagement_301_18mo$smoothedbordercheckX[df_bchdisengagement_301_18mo$smoothedbordercheckX == 0] <- -2
table(df_bchdisengagement_301_18mo$smoothedbordercheckX)

# -2: missing data (if else statements don't deal with NAs so had to replace NAs with -2)
# 1: looking beyond the left edge of the screen 
# 2: left distractor
# 3: looking to the mid line between left distractor and face 
# 4: face
# 5: looking to the mid line between right distractor and face 
# 6: right distractor
# 7: looking beyond the right edge of the screen 

df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPsmooth[is.na(df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPsmooth)] <- -2
df_bchdisengagement_301_18mo$smoothedbordercheckY <- findInterval(df_bchdisengagement_301_18mo$gazepointpositiondisplayY_ITPsmooth, c(-1.999999, -0.0000001, 1.0000001)) 
table(df_bchdisengagement_301_18mo$smoothedbordercheckY)
df_bchdisengagement_301_18mo$smoothedbordercheckY[df_bchdisengagement_301_18mo$smoothedbordercheckY == 0] <- -2
table(df_bchdisengagement_301_18mo$smoothedbordercheckY)

# -2: missing data (if else statements don't deal with NAs so had to replace NAs with -2)
# 1: looking beyond the top edge of the screen 
# 2: on screen
# 3: looking beyond the bottom edge of the screen 

# combining x and y to see where child looks 

df_bchdisengagement_301_18mo$Xlook_pos <- df_bchdisengagement_301_18mo$smoothedbordercheckX
df_bchdisengagement_301_18mo$Xlook_pos[df_bchdisengagement_301_18mo$Xlook_pos == 2] <- 111
df_bchdisengagement_301_18mo$Xlook_pos[df_bchdisengagement_301_18mo$Xlook_pos == 4] <- 333
df_bchdisengagement_301_18mo$Xlook_pos[df_bchdisengagement_301_18mo$Xlook_pos == 6] <- 555
df_bchdisengagement_301_18mo$Ylook_pos <- df_bchdisengagement_301_18mo$smoothedbordercheckY
df_bchdisengagement_301_18mo$Ylook_pos[df_bchdisengagement_301_18mo$Ylook_pos == 2] <- 2222

library("stringr")
df_bchdisengagement_301_18mo$lookpos <- df_bchdisengagement_301_18mo$Ylook_pos + df_bchdisengagement_301_18mo$Xlook_pos
table(df_bchdisengagement_301_18mo$lookpos)

# naming the numbers by quadrant 
# THESE CODES RUN SEQUENTIALLY 
df_bchdisengagement_301_18mo$lookpos[df_bchdisengagement_301_18mo$lookpos < 2333] <- 0
df_bchdisengagement_301_18mo$lookpos[df_bchdisengagement_301_18mo$lookpos == 2333] <- 2 # left, on screen
df_bchdisengagement_301_18mo$lookpos[df_bchdisengagement_301_18mo$lookpos == 2555] <- 4 # face, on screen
df_bchdisengagement_301_18mo$lookpos[df_bchdisengagement_301_18mo$lookpos == 2777] <- 6 # right, on screen
df_bchdisengagement_301_18mo$lookpos[df_bchdisengagement_301_18mo$lookpos > 2777] <- 0
table(df_bchdisengagement_301_18mo$lookpos)
table(df_bchdisengagement_301_18mo$correctpos)

# for the rows where correctpos = 9999 (as long as child is looking on screen, meaning lookpos >= 2)

df_bchdisengagement_301_18mo$correctpos_plus_lookpos <- df_bchdisengagement_301_18mo$correctpos + df_bchdisengagement_301_18mo$lookpos
table(df_bchdisengagement_301_18mo$correctpos_plus_lookpos)
# df_bchdisengagement_301_18mo$aoihit_tardis this is to represent periods where child has to look at a specific aoi, not just the screen 
df_bchdisengagement_301_18mo$aoihit_tardis <- ifelse(df_bchdisengagement_301_18mo$lookpos == df_bchdisengagement_301_18mo$correctpos, 1, 0)
df_bchdisengagement_301_18mo$aoihit <- ifelse (df_bchdisengagement_301_18mo$correctpos_plus_lookpos > 10000, 1, df_bchdisengagement_301_18mo$aoihit_tardis)

# sanity check: look to the left is more likely to happen during left trials than right trials 
table(df_bchdisengagement_301_18mo$correctpos)
df_bchdisengagement_301_18mo_distractorleft <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$correctpos == 2, ]
df_bchdisengagement_301_18mo_distractorright <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$correctpos == 6, ]
table(df_bchdisengagement_301_18mo_distractorleft$lookpos)
table(df_bchdisengagement_301_18mo_distractorright$lookpos)



# % time looking to the screen for each trial --------------------------------------------

# -2: missing data (if else statements don't deal with NAs so had to replace NAs with -2)
# 1: looking beyond the left edge of the screen 
# 2: left distractor aoi
# 3: looking to left border between face and distractor 
# 4: face
# 5: looking to right border between face and distractor 
# 6: right distractor aoi
# 7: looking beyond the right edge of the screen 
# these have to be consecutive integers (except for missing data) for later border violation checks 

df_bchdisengagement_301_18mo$looktoscreenX <- df_bchdisengagement_301_18mo$smoothedbordercheckX
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == -2] <- 0
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == 1] <- 0
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == 7] <- 0
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == 2] <- 1
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == 3] <- 1
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == 4] <- 1
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == 5] <- 1
df_bchdisengagement_301_18mo$looktoscreenX[df_bchdisengagement_301_18mo$looktoscreenX == 6] <- 1
table(df_bchdisengagement_301_18mo$looktoscreenX)

df_bchdisengagement_301_18mo_pctlooktoscreenX <- as.data.frame(aggregate(df_bchdisengagement_301_18mo$looktoscreenX, list(df_bchdisengagement_301_18mo$TrialID), FUN=mean))
colnames(df_bchdisengagement_301_18mo_pctlooktoscreenX) <- c("TrialID", "pctlooktoscreenX")


# -2: missing data (if else statements don't deal with NAs so had to replace NAs with -2)
# 1: looking beyond the top edge of the screen 
# 2: face
# 3: looking beyond the bottom edge of the screen 

df_bchdisengagement_301_18mo$looktoscreenY <- df_bchdisengagement_301_18mo$smoothedbordercheckY
df_bchdisengagement_301_18mo$looktoscreenY[df_bchdisengagement_301_18mo$looktoscreenY == -2] <- 0
df_bchdisengagement_301_18mo$looktoscreenY[df_bchdisengagement_301_18mo$looktoscreenY == 1] <- 0
df_bchdisengagement_301_18mo$looktoscreenY[df_bchdisengagement_301_18mo$looktoscreenY == 3] <- 0
df_bchdisengagement_301_18mo$looktoscreenY[df_bchdisengagement_301_18mo$looktoscreenY == 2] <- 1
table(df_bchdisengagement_301_18mo$looktoscreenY)

df_bchdisengagement_301_18mo_pctlooktoscreenY <- as.data.frame(aggregate(df_bchdisengagement_301_18mo$looktoscreenY, list(df_bchdisengagement_301_18mo$TrialID), FUN=mean))
colnames(df_bchdisengagement_301_18mo_pctlooktoscreenY) <- c("TrialID", "pctlooktoscreenY")

df_bchdisengagement_301_18mo$looktoscreenXY <- df_bchdisengagement_301_18mo$looktoscreenX + df_bchdisengagement_301_18mo$looktoscreenY
table(df_bchdisengagement_301_18mo$looktoscreenXY) # 2 = looking at screen based on both X and Y 
df_bchdisengagement_301_18mo$looktoscreenXY <- ifelse (df_bchdisengagement_301_18mo$looktoscreenXY == 2, 1, 0)
df_bchdisengagement_301_18mo_pctlooktoscreenXY <- as.data.frame(aggregate(df_bchdisengagement_301_18mo$looktoscreenXY, list(df_bchdisengagement_301_18mo$TrialID), FUN=mean))
colnames(df_bchdisengagement_301_18mo_pctlooktoscreenXY) <- c("TrialID", "pctlooktoscreenXY_fulltrial")
# these percentages should be smaller than only looking at X or Y 


write.csv(df_bchdisengagement_301_18mo, 
          file = "/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/df_bchdisengagement_301_18mo_v3_processed12162022.csv", row.names = TRUE )



# Firstlook and SRT ----------------------------------------------------

# SUBSET data during DistractOn and also hit the distractor aoi 
df_bchdisengagement_301_18mo_aoihit <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$aoihit == 1, ]

# see if aoi ratio/nonaoi makes sense
table(df_bchdisengagement_301_18mo$aoihit)
# about half of the time child is looking at the correct aoi - makes sense 
as.numeric(tail(as.data.frame((table(df_bchdisengagement_301_18mo_aoihit$CurrentOnscreenObject))), n = 1)[2])/as.numeric(tail(as.data.frame((table(df_bchdisengagement_301_18mo$CurrentOnscreenObject))), n = 1)[2])
# this is the rate of face on that's aoihit
# this should be high because when the face comes up children intuitively look to the screen



df_aoihitDistractOn <- df_bchdisengagement_301_18mo_aoihit[df_bchdisengagement_301_18mo_aoihit$CurrentOnscreenObject == "DistractOn", ]

df_aoihitDistractOn <-
  df_aoihitDistractOn %>% 
  arrange(TrialID, RTTime) %>%
  group_by(TrialID) %>% 
  filter(row_number()==1) %>% 
  ungroup()

df_aoihitDistractOn <- as.data.frame(df_aoihitDistractOn)

dim(df_aoihitDistractOn) # number of trials where child hit aoi during DistractOn


df_firstlook <- select(df_aoihitDistractOn, c("TrialID", "RTTime"))
colnames(df_firstlook) <- c("TrialID", "firstlook")

# merge this with DistractOn onset time to calculate SRT
df_bchdisengagement_301_18mo_DistractOn <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$CurrentOnscreenObject == "DistractOn", ]
df_bchdisengagement_301_18mo_DistractOn_firstrow <-
  df_bchdisengagement_301_18mo_DistractOn %>% 
  arrange(TrialID, RTTime) %>%
  group_by(TrialID) %>% 
  filter(row_number()==1) %>% 
  ungroup()
df_bchdisengagement_301_18mo_DistractOn_firstrow <- as.data.frame(df_bchdisengagement_301_18mo_DistractOn_firstrow)
# need to keep the ID column here for later trial exclusion
df_DistractOn <- select(df_bchdisengagement_301_18mo_DistractOn_firstrow, c("TrialID", "RTTime"))
colnames(df_DistractOn) <- c("TrialID", "DistractOnOT_real")
# we can't use the df_bchdisengagement_301_18mo_DistractOn$DistractOnOT we previously calculated
# df_bchdisengagement_301_18mo_DistractOn$DistractOnOT
# because that is a theoretical calculation based on paradigm design - sanity checking using event data 
# this RTTime is in fact based on subsetting the dataset 
# hence it's the actual DistractOnOT_real
df_summary_301_18mo <- merge(df_firstlook, df_DistractOn, by="TrialID", all = TRUE)

df_summary_301_18mo$SRT_raw <- df_summary_301_18mo$firstlook - df_summary_301_18mo$DistractOnOT_real
# summary(df_summary_301_18mo$SRT_raw) # M = 1179


# from SRT_raw to SRT -----------------------------------------------------
# RUN SEQUENTIALLY!!
# 1. where firstlook = NA, means the child never shifted to distractor, so their SRT = 2000
df_summary_301_18mo$SRT <- df_summary_301_18mo$SRT_raw
df_summary_301_18mo$SRT[is.na(df_summary_301_18mo$SRT) == TRUE] <- 2600

# 2. if child shifted within 150ms, that's unlikely due to processing 
# replacing all SRT_raw < 150 as NA because these trials will not be included in the SRT analysis
# already looking to the target at the start of the trial
# but they can go into the DT analysis
df_summary_301_18mo$SRT[df_summary_301_18mo$SRT < 150] <- NA


# variable DT_ondis over the entire duration of DistractorOn --------------------

# within this time window how many segments are aoihit versus not?
df_hitcount <- 
  df_bchdisengagement_301_18mo_DistractOn %>% 
  group_by(TrialID) %>% 
  count(aoihit) %>%
  ungroup()
df_hitcount <- as.data.frame(df_hitcount)
df_hitcount_aoi <- df_hitcount[df_hitcount$aoihit == 1, ]
df_hitcount_aoi$aoihit <- NULL
colnames(df_hitcount_aoi) <- c("TrialID", "aoisegs_ondis_distractoron")

df_hitcount_nothit <- df_hitcount[df_hitcount$aoihit == 0, ]
df_hitcount_nothit$aoihit <- NULL
colnames(df_hitcount_nothit) <- c("TrialID", "nothitsegs_ondis_distractoron")

df_hitcount_aoi <- merge(df_hitcount_aoi, df_hitcount_nothit, by="TrialID", all = TRUE)
df_summary_301_18mo <- merge(df_summary_301_18mo, df_hitcount_aoi, by="TrialID", all = TRUE)
# need to update SAMPLING RATE here
df_summary_301_18mo$DT_ondis <- df_summary_301_18mo$aoisegs_ondis_distractoron*(1000/300)
# if child never shifted, DT_ondis = 0 
df_summary_301_18mo$DT_ondis[is.na(df_summary_301_18mo$DT_ondis)] <- 0
# the variable DT_ondis = prop time looking to distractor between distractor onset and end of the 2600ms window 
# (the entire duration of DistractorOn)


# DT_150_1000_ontarget  ------------------------------------------------------------

# Xie et al paper:
# duration of fixation dwell time on the central face before the saccade to the lateral target 
# between 150 ms and 1000 ms following the distractor onset
# and then converted to a normalized dwell time index score. 
# The value of the index varies between 0 (saccade at 150 ms after the onset) and 1 (no saccade by 1000 ms after the onset).
# calculate DT for all trials 

# general idea: segment the data between 150 and 1000ms after target onset
# and see how much time the child spends on the center face before saccade or before the window shuts down, whichever is bigger
# DT has to be calculated based on the time before the gaze shift happened 
# need to find out the number of segments before first look 
# if first look happened before 1000ms after disOT

# first exclude trials where child shifted gaze before 150ms 
# any trial that has NA in the row SRT shifted before 150ms 
# only keeping trials where child shifted after 150ms
df_summary_301_18mo_noshiftbefore150 <- df_summary_301_18mo[!is.na(df_summary_301_18mo$SRT), ]

# dividing trials into 3 datasets:
# shifting before 150
# shifting between 150 and 1000
# shifting after 1000

############################# STOP HERE ########################################
# group 1:
df_summary_301_18mo_shiftbefore150 <- df_summary_301_18mo[is.na(df_summary_301_18mo$SRT), ]
df_summary_301_18mo_shiftbefore150$DT_150_1000_ontarget <- NA
# if you see an error message saying "Error in `$<-.data.frame`(`*tmp*`, DT_150_1000_ontarget, value = NA) : 
# replacement has 1 row, data has 0", that's ok - keep going 
################################# GO ###########################################

# group 2:
# trials where child switched before 1000 mark
df_summary_301_18mo_noshiftbefore150_firstlookbefore1000 <- df_summary_301_18mo_noshiftbefore150[!(df_summary_301_18mo_noshiftbefore150$SRT > 1000), ]
# for these trials, DT_150_1000_ontarget is their SRT 
df_summary_301_18mo_noshiftbefore150_firstlookbefore1000$DT_150_1000_ontarget <- df_summary_301_18mo_noshiftbefore150_firstlookbefore1000$SRT

# group 3: trials without switch before 1000 mark
df_summary_301_18mo_noshiftbefore150_firstlookafter1000 <- df_summary_301_18mo_noshiftbefore150[df_summary_301_18mo_noshiftbefore150$SRT > 1000, ]
# for these trials, DT_150_1000_ontarget is 1000
df_summary_301_18mo_noshiftbefore150_firstlookafter1000$DT_150_1000_ontarget <- 1000

df_summary_301_18mo <- bind_rows(df_summary_301_18mo_noshiftbefore150_firstlookafter1000, df_summary_301_18mo_noshiftbefore150_firstlookbefore1000, df_summary_301_18mo_shiftbefore150)
dat_150_1000 <- select(df_summary_301_18mo, c("TrialID", "DT_150_1000_ontarget"))
# because the time window starts at 150, longest DT should be 850
dat_150_1000$DT_150_1000_ontarget <- dat_150_1000$DT_150_1000_ontarget - 150
df_summary_301_18mo$DT_150_1000_ontarget <- NULL


# DT_150_2000_ontarget  ------------------------------------------------------------

# Xie et al paper:
# duration of fixation dwell time on the central face before the saccade to the lateral target 
# between 150 ms and 2000 ms following the distractor onset
# and then converted to a normalized dwell time index score. 
# The value of the index varies between 0 (saccade at 150 ms after the onset) and 1 (no saccade by 2000 ms after the onset).
# calculate DT for all trials 

# general idea: segment the data between 150 and 2000ms after target onset
# and see how much time the child spends on the center face before saccade or before the window shuts down, whichever is bigger
# DT has to be calculated based on the time before the gaze shift happened 
# need to find out the number of segments before first look 
# if first look happened before 2000ms after disOT

# first exclude trials where child shifted gaze before 150ms 
# any trial that has NA in the row SRT shifted before 150ms 
# only keeping trials where child shifted after 150ms

# dividing trials into 3 datasets (we've already done this when calculating 150-1000):
# shifting before 150
# shifting between 150 and 2000
# shifting after 2000

# group 1:
# done this before: df_summary_301_18mo_shiftbefore150$DT_150_2000_ontarget <- NA

# group 2:
# trials where child switched before 2000 mark
df_summary_301_18mo_noshiftbefore150_firstlookbefore2000 <- df_summary_301_18mo_noshiftbefore150[!(df_summary_301_18mo_noshiftbefore150$SRT > 2000), ]
# for these trials, DT_150_2000_ontarget is their SRT 
df_summary_301_18mo_noshiftbefore150_firstlookbefore2000$DT_150_2000_ontarget <- df_summary_301_18mo_noshiftbefore150_firstlookbefore2000$SRT

# group 3: trials without switch before 2000 mark
df_summary_301_18mo_noshiftbefore150_firstlookafter2000 <- df_summary_301_18mo_noshiftbefore150[df_summary_301_18mo_noshiftbefore150$SRT > 2000, ]
# for these trials, DT_150_2000_ontarget is 2000
df_summary_301_18mo_noshiftbefore150_firstlookafter2000$DT_150_2000_ontarget <- 2000

df_summary_301_18mo <- bind_rows(df_summary_301_18mo_noshiftbefore150_firstlookafter2000, df_summary_301_18mo_noshiftbefore150_firstlookbefore2000, df_summary_301_18mo_shiftbefore150)
df_summary_301_18mo$DT_150_1000_ontarget <- NULL
df_summary_301_18mo <- df_summary_301_18mo %>%
  dplyr::arrange(TrialID) %>% 
  dplyr::ungroup()
df_summary_301_18mo <- as.data.frame(df_summary_301_18mo)
df_summary_301_18mo$DT_150_2000_ontarget <- df_summary_301_18mo$DT_150_2000_ontarget - 150

df_summary_301_18mo <- merge(df_summary_301_18mo, dat_150_1000, by="TrialID", all = TRUE)


# DT_ondis_150_2000 -------------------------------------------------------

# because event files are not used, calculate distractor onset time here 
#bookmark

df_bchdisengagement_301_18mo <- merge(df_bchdisengagement_301_18mo, df_DistractOn, by="TrialID", all = TRUE)


df_bchdisengagement_301_18mo$DistractOn150to2000 <- df_bchdisengagement_301_18mo$RTTime - df_bchdisengagement_301_18mo$DistractOnOT_real
df_bchdisengagement_301_18mo$DistractOn150to2000[df_bchdisengagement_301_18mo$DistractOn150to2000 <= 150] <- 0
df_bchdisengagement_301_18mo$DistractOn150to2000[df_bchdisengagement_301_18mo$DistractOn150to2000 >= 2000] <- 0
df_bchdisengagement_301_18mo$DistractOn150to2000[df_bchdisengagement_301_18mo$DistractOn150to2000 != 0] <- 1


df_bchdisengagement_301_18mo_DistractOn150to2000 <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$DistractOn150to2000 == 1, ]

df_hitcount_150to2000 <- 
  df_bchdisengagement_301_18mo_DistractOn150to2000 %>% 
  group_by(TrialID) %>% 
  count(aoihit) %>%
  ungroup()
df_hitcount_150to2000 <- as.data.frame(df_hitcount_150to2000)
df_hitcount_150to2000_aoi <- df_hitcount_150to2000[df_hitcount_150to2000$aoihit == 1, ]
df_hitcount_150to2000_aoi$aoihit <- NULL
colnames(df_hitcount_150to2000_aoi) <- c("TrialID", "aoisegs_ondis_150to2000")

df_hitcount_150to2000_nothit <- df_hitcount_150to2000[df_hitcount_150to2000$aoihit == 0, ]
df_hitcount_150to2000_nothit$aoihit <- NULL
colnames(df_hitcount_150to2000_nothit) <- c("TrialID", "nothitsegs_ondis_150to2000")

df_hitcount_150to2000_aoi <- merge(df_hitcount_150to2000_aoi, df_hitcount_150to2000_nothit, by="TrialID", all = TRUE)
df_summary_301_18mo <- merge(df_summary_301_18mo, df_hitcount_150to2000_aoi, by="TrialID", all = TRUE)
# UPDATE SAMPLING RATE! 
df_summary_301_18mo$DT_ondis_150to2000 <- df_summary_301_18mo$aoisegs_ondis_150to2000*(1000/300)
# if child never shifted, DT_150to2000 = 0 
df_summary_301_18mo$DT_ondis_150to2000[is.na(df_summary_301_18mo$DT_ondis_150to2000)] <- 0


# trial exclusion ---------------------------------------------------------
# 1. exclude children who shifted but spent fewer than 100ms on the target

# a fixation is set to be at least 100ms 
# according to Papageorgiou paper and wass paper (mostly wass paper) which presents fixation duration histogram (younger infants)
# 100/(1000/300) 
# at least 12 aoisegs_ondis_distractoron
# for trials with aoisegs_ondis_distractoron < 12, treat SRT = 2600
# because there is no concrete evidence that child indeed fixated on the correct box 
# update based on sampling frequency (maxgap)
vec_lackfixation <- as.vector(df_summary_301_18mo$TrialID[df_summary_301_18mo$aoisegs_ondis_distractoron < 30])
vec_lackfixation <- vec_lackfixation[!is.na(vec_lackfixation)]
# manually check if the calculations are correct based on spreadsheets



# Xie et al NeuroImage paper inclusion criteria:
# "valid information about the eye movement from the central to the lateral stimulus 
# (i.e., the eye movement did not occur during a period of missing gaze data)." 

# pull the segments before and after the identified SRT and calculate rate of missing data 
df_srtavailable <- df_summary_301_18mo[!is.na(df_summary_301_18mo$firstlook), ]
# the trials where children did not shift their gaze are not relevant 

idvec_mischeck <- as.vector(df_srtavailable$firstlook)
# need to merge the firstlook dataset with the full data 
df_bchdisengagement_301_18mo <- merge(df_bchdisengagement_301_18mo, df_firstlook, by="TrialID", all = TRUE)

df_bchdisengagement_301_18mo_mischeck <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$RTTime %in% idvec_mischeck,]
idvec_mischeck_firstlookid <- as.vector(df_bchdisengagement_301_18mo_mischeck$ID)

idvec_exclusioncheck <- c(rbind(idvec_mischeck_firstlookid+0, idvec_mischeck_firstlookid+1, idvec_mischeck_firstlookid+2,
                                idvec_mischeck_firstlookid+3, idvec_mischeck_firstlookid+4, idvec_mischeck_firstlookid+5,
                                idvec_mischeck_firstlookid-1, idvec_mischeck_firstlookid-2, idvec_mischeck_firstlookid-3,
                                idvec_mischeck_firstlookid-4, idvec_mischeck_firstlookid-5))

# pull these rows from the full dataset
df_bchdisengagement_301_18mo_mischeck <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$ID %in% idvec_exclusioncheck,]
df_bchdisengagement_301_18mo_mischeckX <- df_bchdisengagement_301_18mo_mischeck[df_bchdisengagement_301_18mo_mischeck$smoothedbordercheckX == -2, ]
df_bchdisengagement_301_18mo_mischeckY <- df_bchdisengagement_301_18mo_mischeck[df_bchdisengagement_301_18mo_mischeck$smoothedbordercheckY == -2, ]
dim(df_bchdisengagement_301_18mo_mischeckX)
dim(df_bchdisengagement_301_18mo_mischeckY)

# if returning 0 rows for both x and y, good - create an empty vector
vec_gazewhilemiss <- c()

# if there are -2s, find the trial and exclude these trials from SRT analysis
vec_gazewhilemiss_X <- as.vector(df_bchdisengagement_301_18mo_mischeckX$TrialID)
vec_gazewhilemiss_X <- vec_gazewhilemiss_X[!is.na(vec_gazewhilemiss_X)]
vec_gazewhilemiss_X <- vec_gazewhilemiss_X[!duplicated(vec_gazewhilemiss_X)]

vec_gazewhilemiss_Y <- as.vector(df_bchdisengagement_301_18mo_mischeckY$TrialID)
vec_gazewhilemiss_Y <- vec_gazewhilemiss_Y[!is.na(vec_gazewhilemiss_Y)]
vec_gazewhilemiss_Y <- vec_gazewhilemiss_Y[!duplicated(vec_gazewhilemiss_Y)]

vec_gazewhilemiss <- c(vec_gazewhilemiss_X, vec_gazewhilemiss_Y)
vec_gazewhilemiss <- vec_gazewhilemiss[!duplicated(vec_gazewhilemiss)]


# look to the screen before fixation > 70% ------------------------------------
# W Xie NeuroImage paper:
# "a sufficient fixation on the central stimulus (> 70% of the time) during the time preceding gaze shift 
# or the end of the analysis period (i.e., 1000 ms after the lateral stimulus onset)"

# look at the period of 2000ms prior to firstlook 
# need to be >= 70% to be included in the analysis
# when no shift, it's 2000ms prior to firstlook extending toward TargetOn
# this is more conservative because children naturally look away during TargetOn
# for no shift, excluding those who look away between DistractOnonset and first look 
# versus excluding those who look away during DistractOnonset only

# for trials with no shift, the window to check is basically the first 1000ms of DistractOn
df_noshift <- df_bchdisengagement_301_18mo[is.na(df_bchdisengagement_301_18mo$firstlook), ]
df_noshift <- df_noshift[df_noshift$CurrentOnscreenObject == "DistractOn", ]
# keeping the first 1000ms (300 rows) for each trial
# update based on maxgap 

library(dplyr)
df_noshift_1000 <-
  df_noshift %>% 
  arrange(TrialID, RTTime) %>%
  group_by(TrialID) %>% 
  filter(row_number() %in% c(1:300)) %>% 
  ungroup()
df_noshift_1000 <- as.data.frame(df_noshift_1000)

# what percentage looking to the face?

df_noshift_1000$lookface <- df_noshift_1000$lookpos
table(df_noshift_1000$lookface)
df_noshift_1000$lookface[df_noshift_1000$lookface != 4] <- 0
df_noshift_1000$lookface[df_noshift_1000$lookface == 4] <- 1
df_noshift_1000_pctlooktofaceXY <- as.data.frame(aggregate(df_noshift_1000$lookface, list(df_noshift_1000$TrialID), FUN=mean))
colnames(df_noshift_1000_pctlooktofaceXY) <- c("TrialID", "pctlooktofaceXY")
df_noshift_1000_ex <- df_noshift_1000_pctlooktofaceXY[df_noshift_1000_pctlooktofaceXY$pctlooktofaceXY < 0.7, ]
vec_noshift_1000_ex <- as.vector(df_noshift_1000_ex$TrialID)

# for trials with shift, the window to check is 1000ms prior to first look (more conservative than Xie paper)
df_shift <- df_bchdisengagement_301_18mo[!is.na(df_bchdisengagement_301_18mo$firstlook), ]
df_shift$RTTimeminusfirstlook <- df_shift$RTTime - df_shift$firstlook

library(dplyr)
df_shift <-
  df_shift %>% 
  arrange(TrialID, RTTime) %>%
  ungroup()

df_shift <- df_shift[df_shift$RTTimeminusfirstlook > -1000, ]
df_shift <- df_shift[df_shift$RTTimeminusfirstlook < 0, ]
hist(df_shift$RTTimeminusfirstlook)

# what percentage looking to face?
df_shift$lookface <- df_shift$lookpos
df_shift$lookface[df_shift$lookface != 4] <- 0
df_shift$lookface[df_shift$lookface == 4] <- 1
df_shift_pctlooktofaceXY <- as.data.frame(aggregate(df_shift$lookface, list(df_shift$TrialID), FUN=mean))
colnames(df_shift_pctlooktofaceXY) <- c("TrialID", "pctlooktofaceXY")
df_shift_ex <- df_shift_pctlooktofaceXY[df_shift_pctlooktofaceXY$pctlooktofaceXY < 0.7, ]
vec_shift_ex <- as.vector(df_shift_ex$TrialID)
vec_ex70 <- c(vec_noshift_1000_ex, vec_shift_ex)


# check for gaps ----------------------------------------------------------
# Xie et al paper:
# 2) sufficient number of valid samples in the gaze data so that there were no gaps longer than 200 ms; 
# are there missing chunks longer than 200ms during DistractOn and TargetOn in either eye - this is to ensure DT is also accurate  
# 200/(1000/300) # missing 60 segs
df_gapcheck <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$CurrentOnscreenObject %in% c("TargetOn", "DistractOn"), ]

df_gapcheck <- df_gapcheck %>%
  dplyr::arrange(RTTime) %>% 
  dplyr::group_by(TrialID) %>%
  dplyr::mutate(X_ITPsmooth_gapcheck = zoo::rollsum(gazepointpositiondisplayX_ITPsmooth, k = 60, fill = NA)) %>% 
  dplyr::ungroup()
df_gapcheck <- as.data.frame(df_gapcheck)

table(df_gapcheck$X_ITPsmooth_gapcheck)
# there are 1571 segments of -120 (60 * -2 representing missing segs)
# where are they?
df_over60segs <- df_gapcheck[df_gapcheck$X_ITPsmooth_gapcheck == -120, ]
vec_over60segs <- as.vector(df_over60segs$TrialID)
vec_over60segs <- vec_over60segs[!is.na(vec_over60segs)]
vec_over60segs <- vec_over60segs[!duplicated(vec_over60segs)]


# dropping trials from the summary data -----------------------------------

vec_droptrial <- c(vec_ex70, vec_over60segs, vec_gazewhilemiss, vec_lackfixation)
vec_droptrial <- vec_droptrial[!duplicated(vec_droptrial)]

vec_TrialID <- as.vector(df_summary_301_18mo$TrialID)
vec_keeptrial <- setdiff(vec_TrialID, vec_droptrial) 
# the order of these two vectors matter: 
# removing whatever that's in vec_droptrial from vec_TrialID

vec_keeptrial <- vec_keeptrial[!is.na(vec_keeptrial)]


############################# STOP HERE ########################################
length(vec_keeptrial) 
# number of kept trials - keeping 13 trial in this case 
############################# GO ###############################################

df_analysis_301_18mo <- df_summary_301_18mo[df_summary_301_18mo$TrialID %in% vec_keeptrial, ]
df_analysis_301_18mo$keep <- 1
df_drop_301_18mo <- df_summary_301_18mo[df_summary_301_18mo$TrialID %in% vec_droptrial, ]
df_drop_301_18mo$keep <- 0
df_summary_301_18mo <- rbind(df_analysis_301_18mo, df_drop_301_18mo)


# % time looking to the screen for each segment/trial --------------------------------------------

table(df_bchdisengagement_301_18mo$CurrentOnscreenObject)
seg_Fixation <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$CurrentOnscreenObject == "Fixation", ]
seg_DistractOn <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$CurrentOnscreenObject == "DistractOn", ]
seg_TargetOn <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$CurrentOnscreenObject == "TargetOn", ]
seg_StimuliOff <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$CurrentOnscreenObject == "StimuliOff", ]


# table(seg_Fixation$TrialID) 
# table(seg_DistractOn$TrialID) 
# table(seg_TargetOn$TrialID) 
# table(seg_StimuliOff$TrialID) 


# % time for each seg --------------------------------------------------

seg_Fixation_pctlooktoscreenXY <- as.data.frame(aggregate(seg_Fixation$looktoscreenXY, list(seg_Fixation$TrialID), FUN=mean))
colnames(seg_Fixation_pctlooktoscreenXY) <- c("TrialID", "pctlooktoscreenXY")

seg_DistractOn_pctlooktoscreenXY <- as.data.frame(aggregate(seg_DistractOn$looktoscreenXY, list(seg_DistractOn$TrialID), FUN=mean))
colnames(seg_DistractOn_pctlooktoscreenXY) <- c("TrialID", "pctlooktoscreenXY_DistractOn")

seg_TargetOn_pctlooktoscreenXY <- as.data.frame(aggregate(seg_TargetOn$looktoscreenXY, list(seg_TargetOn$TrialID), FUN=mean))
colnames(seg_TargetOn_pctlooktoscreenXY) <- c("TrialID", "pctlooktoscreenXY_TargetOn")

seg_StimuliOff_pctlooktoscreenXY <- as.data.frame(aggregate(seg_StimuliOff$looktoscreenXY, list(seg_StimuliOff$TrialID), FUN=mean))
colnames(seg_StimuliOff_pctlooktoscreenXY) <- c("TrialID", "pctlooktoscreenXY_StimuliOff")
# these percentages should be smaller than only looking at X or Y 


# ordering the datasets by Trial ID because cbind does not care about trial ID and we want to make sure they are matched
df_bchdisengagement_301_18mo_pctlooktoscreenXY <- df_bchdisengagement_301_18mo_pctlooktoscreenXY %>% 
  arrange(TrialID) 
df_bchdisengagement_301_18mo_pctlooktoscreenXY <- as.data.frame(df_bchdisengagement_301_18mo_pctlooktoscreenXY)

seg_Fixation_pctlooktoscreenXY <- seg_Fixation_pctlooktoscreenXY %>% 
  arrange(TrialID) 
seg_Fixation_pctlooktoscreenXY <- as.data.frame(seg_Fixation_pctlooktoscreenXY)

seg_TargetOn_pctlooktoscreenXY <- seg_TargetOn_pctlooktoscreenXY %>% 
  arrange(TrialID) 
seg_TargetOn_pctlooktoscreenXY <- as.data.frame(seg_TargetOn_pctlooktoscreenXY)

seg_DistractOn_pctlooktoscreenXY <- seg_DistractOn_pctlooktoscreenXY %>% 
  arrange(TrialID) 
seg_DistractOn_pctlooktoscreenXY <- as.data.frame(seg_DistractOn_pctlooktoscreenXY)

seg_StimuliOff_pctlooktoscreenXY <- seg_StimuliOff_pctlooktoscreenXY %>% 
  arrange(TrialID) 
seg_StimuliOff_pctlooktoscreenXY <- as.data.frame(seg_StimuliOff_pctlooktoscreenXY)


# merging the dataset 
df_pctlooktoscreen <- cbind(df_bchdisengagement_301_18mo_pctlooktoscreenXY, seg_Fixation_pctlooktoscreenXY, seg_TargetOn_pctlooktoscreenXY, 
                            seg_DistractOn_pctlooktoscreenXY, seg_StimuliOff_pctlooktoscreenXY)
# removing duplicated columns
duplicated_names <- duplicated(colnames(df_pctlooktoscreen))
df_pctlooktoscreen <- df_pctlooktoscreen[!duplicated_names]

############################# OPTIONAL IF ONE TRIAL IS TOO LONG ################
## remove the problematic trial 
## df_bchdisengagement_301_18mo <- df_bchdisengagement_301_18mo[df_bchdisengagement_301_18mo$TrialID != 8, ]
## df_summary_301_18mo <- df_summary_301_18mo[df_summary_301_18mo$TrialID != 8, ]
## table(df_bchdisengagement_301_18mo$TrialID)
## table(df_bchdisengagement_301_18mo$TrialID)
# check that the problematic trial has been removed
############################# GO ###############################################


# appending trial condition to df ----------------------------------

library("stringr")
df_bchdisengagement_301_18mo$condition <- str_c(df_bchdisengagement_301_18mo$Emotion, "_", 
                                                  df_bchdisengagement_301_18mo$FaceNum)

df_bchdisengagement_301_18mo_condition <- select(df_bchdisengagement_301_18mo, c("TrialID", "condition", "Emotion", "FaceNum"))


library(dplyr)
df_condition <-
  df_bchdisengagement_301_18mo_condition %>% 
  group_by(TrialID) %>% 
  filter(row_number()==1) %>% 
  ungroup()
df_condition <- as.data.frame(df_condition)

df_bchdisengagement_301_18mo <- merge(df_bchdisengagement_301_18mo, df_condition, by="TrialID", all = TRUE)

df_summary_301_18mo <- merge(df_summary_301_18mo, df_pctlooktoscreen, by="TrialID", all = TRUE)
df_summary_301_18mo <- merge(df_summary_301_18mo, df_condition, by="TrialID", all = TRUE)


write.csv(df_bchdisengagement_301_18mo, 
          file = "/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/leap_bch_disengagement_processed_data_18mo/df_bchdisengagement_301_18mo_v3_processed12162022_analyzed12162022.csv", row.names = TRUE )
write.csv(df_summary_301_18mo, 
          file = "/Users/Ran/Dropbox (Personal)/leap_bch_disengagement/leap_bch_disengagement_data/leap_bch_disengagement_processed_data_18mo/df_summary_301_18mo.csv", row.names = TRUE )


