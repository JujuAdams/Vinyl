//How often to scan the Vinyl config file for changes, in milliseconds
//Set this value to zero (or a negative number) to turn off live update
//Live update can further be toggled using VinylLiveUpdateGet()
//Live update only works when running from the IDE on Windows, Mac, or Linux
#macro VINYL_LIVE_UPDATE_PERIOD  250

//Length of moment-to-moment gain adjustments, in milliseconds
//Choose lower values for tigher, quicker gain adjustment
//Choose higher values for smooth, less glitchy gain adjustment
#macro VINYL_STEP_DURATION  50

//Default rate of gain adjument when approaching a gain target
//Measured in decibels/frame
#macro VINYL_DEFAULT_GAIN_RATE  0.5

//Default rate of pitch adjument when approaching a pitch target
//Measured in %/frame
#macro VINYL_DEFAULT_PITCH_RATE  0.05

//Maximum output gain for audio instances. Must be greater than or equal to zero
//Choose lower values to get more resolution in perceived volume levels
//Choose higher values to allow audio to get louder relative to 0 dB
#macro VINYL_SYSTEM_HEADROOM  12



#region Advanced

//How much debug spam to chuck at the debug log
//  0 = minimum, warnings only
//  1 = some, messages created when interacting with most API functions
//  2 = obnoxious amounts, updates for virtually every internal operation
#macro VINYL_DEBUG_LEVEL  0

//Whether to output extra debug information when reading configuration data
#macro VINYL_DEBUG_READ_CONFIG  false

//Decibel level that is functionally silent to the ear
#macro VINYL_SILENCE  -60

//Number of audio instances pre-created in the pool
#macro VINYL_POOL_START_SIZE  30

#endregion