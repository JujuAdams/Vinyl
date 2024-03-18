// Feather disable all

#macro VINYL_LIVE_EDIT  true

#macro VINYL_REPORT_FAILURE_TO_PLAY  true

//Maximum output gain for audio voices. Must be greater than or equal to zero
//Choose lower values to get more resolution in perceived volume levels
#macro VINYL_MAX_GAIN  1

//Length of moment-to-moment gain adjustments, in milliseconds
//Choose lower values for tigher, quicker gain adjustment
//Choose higher values for smooth, less glitchy gain adjustment
#macro VINYL_STEP_DURATION  50

//How far from the end of an audio asset to determine the audio as finishing. This is used for
//audio scheduling for queue voices
#macro VINYL_WILL_STOP_TOLERANCE  20