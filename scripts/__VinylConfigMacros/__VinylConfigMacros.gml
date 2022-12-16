//How often to scan the Vinyl config file for changes, in milliseconds
//Set this value to zero (or a negative number) to turn off live update
//Live update can further be toggled using VinylLiveUpdateGet()
//Live update only works when running from the IDE on Windows, Mac, or Linux
#macro VINYL_LIVE_UPDATE_PERIOD  500

#macro VINYL_STEP_DURATION       50   //milliseconds
#macro VINYL_DEFAULT_GAIN_RATE   0.1
#macro VINYL_DEFAULT_PITCH_RATE  0.1
#macro VINYL_DEBUG               true //Set to <true> to spit out a TON of information about what Vinyl is doing. Very useful to track down audio bugs

#macro VINYL_SYSTEM_HEADROOM  20

#macro VINYL_GAIN_SILENT  -60

#macro VINYL_YAML_TAB_SIZE  4