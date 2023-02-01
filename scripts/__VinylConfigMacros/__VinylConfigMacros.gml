//Maximum output gain for audio instances. Must be greater than or equal to zero
//Choose lower values to get more resolution in perceived volume levels
#macro VINYL_SYSTEM_MAX_GAIN  1

//Default rate of gain adjument when approaching a gain target
//Measured in units/second
#macro VINYL_DEFAULT_GAIN_RATE  0.3

//Default rate of pitch adjument when approaching a pitch target
//Measured in units/second
#macro VINYL_DEFAULT_PITCH_RATE  0.3



#region Advanced

//Controls how the config file (__VinylConfig) is read regarding gain values
//Setting this macro to <true> will cause Vinyl to treat gain values as decibels (dbFS)
//A decibel value of 0 will be translated to an unchanged gain i.e. a GM amplitude value of 1
//Negative decibel values will be translated to an attenuation of audio amplitude
#macro VINYL_CONFIG_DECIBEL_GAIN  false

//Controls how the config file (__VinylConfig) is read regarding pitches
//Setting this macro to <true> will cause Vinyl to treat pitch values as percentages
//This means a value of 50 will be translated into 50%, or a halving of a sound's pitch
#macro VINYL_CONFIG_PERCENTAGE_PITCH  false

//How often to scan the Vinyl config file for changes, in milliseconds
//Set this value to zero (or a negative number) to turn off live update
//Live update can further be toggled using VinylLiveUpdateGet()
//Live update only works when running from the IDE on Windows, Mac, or Linux
#macro VINYL_LIVE_UPDATE_PERIOD  250

//Length of moment-to-moment gain adjustments, in milliseconds
//Choose lower values for tigher, quicker gain adjustment
//Choose higher values for smooth, less glitchy gain adjustment
#macro VINYL_STEP_DURATION  50

//How much debug spam to chuck at the debug log
//  0 = minimum, warnings only
//  1 = some, messages created when interacting with most API functions
//  2 = obnoxious amounts, updates for virtually every internal operation
#macro VINYL_DEBUG_LEVEL  0

//Whether to output extra debug information when reading configuration data
#macro VINYL_DEBUG_READ_CONFIG  false

//Number of audio instances pre-created in the pool
#macro VINYL_POOL_START_SIZE  30

#endregion