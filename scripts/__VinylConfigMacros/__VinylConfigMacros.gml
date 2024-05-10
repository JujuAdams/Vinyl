// Feather disable all

#macro VINYL_LIVE_EDIT  true

#macro VINYL_NO_MIX       "no mix"
#macro VINYL_DEFAULT_MIX  VINYL_NO_MIX

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

#macro VINYL_SAFE_JSON_IMPORT  true

#macro VINYL_PATTERN_MACRO_PREFIX  "vin"
#macro VINYL_MIX_MACRO_PREFIX      "vinMix"