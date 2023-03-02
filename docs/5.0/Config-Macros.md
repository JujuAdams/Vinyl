# Config Macros

&nbsp;

In addition to Vinyl's [configuration file](Configuration), there are a number of macros that can be adjusted to customise Vinyl to your liking. You can find all these macros in the `__VinylConfigMacros` script. You should adjust these macros as you see fit.

&nbsp;

## `VINYL_MAX_GAIN`

*Default value: `1`*

Maximum output gain for sound voices. Must be greater than or equal to zero. You can read more about Vinyl's gain structure [here](Gain-Structure).

&nbsp;

## `VINYL_DEFAULT_GAIN_RATE`

*Default value: `0.3`*

Default rate of gain adjument when approaching a gain target. Measured in normalised gain units per second.

&nbsp;

## `VINYL_DEFAULT_PITCH_RATE`

*Default value: `0.3`*

Default rate of pitch adjument when approaching a pitch target. Measured in normalised pitch units per second.

&nbsp;

## `VINYL_DEFAULT_FALLOFF_MIN`

*Default value: `50`*

Default falloff reference distance for Vinyl's custom emitters.

&nbsp;

## `VINYL_DEFAULT_FALLOFF_MAX`

*Default value: `200`*

Default falloff maximum distance for Vinyl's custom emitters.

&nbsp;

## `VINYL_DEFAULT_FALLOFF_FACTOR`

*Default value: `1`*

Default falloff factor for Vinyl's custom emitters.

&nbsp;

## `VINYL_DEFAULT_QUEUE_BEHAVIOR`

*Default value: `0`*

Value to set for queue patterns when the `behavior` property is unset. See [`VinylQueueBehaviorSet()`](Queue-Patterns) for more information.

&nbsp;

## `VINYL_DEFAULT_MULTI_BLEND`

*Default value: `undefined`*

Value to set for queue patterns when the `blend` property is unset. See [`VinylMultiBlendSet()`](Multi-Patterns) for more information.

&nbsp;

## `VINYL_DEFAULT_MULTI_SYNC`

*Default value: `false`*

Value to set for queue patterns when the `sync` property is unset. See [`VinylMultiSyncSet()`](Multi-Patterns) for more information.

&nbsp;

&nbsp;

# Advanced

The following config macros relate to more technical, less generally applicable, behaviours within Vinyl.

&nbsp;

## `VINYL_CONFIG_VALIDATE_PROPERTIES`

*Default value: `true`*

Whether to strictly filter config file properties to detect any incorrect or invalid names. This carries a performance penalty when loading.

&nbsp;

## `VINYL_CONFIG_DECIBEL_GAIN`

*Default value: `false`*

Controls how the [configuration file](Configuration) is read regarding gain values. Setting this macro to `true` will cause Vinyl to treat gain values as decibels (dbFS). A decibel value of `0` will be translated to an unchanged gain i.e. a GM amplitude value of 1. Negative decibel values will be translated to an attenuation of audio amplitude.

&nbsp;

## `VINYL_CONFIG_PERCENTAGE_PITCH`

*Default value: `false`*

Controls how the [configuration file](Configuration) is read regarding pitches. Setting this macro to `true` will cause Vinyl to treat pitch values as percentages. This means a value of `50` will be translated into 50%, or a halving of a sound's pitch.

&nbsp;

## `VINYL_LIVE_UPDATE_PERIOD`

*Default value: `250`*

How often to scan Vinyl configuration file for changes, in milliseconds. Set this value to zero (or a negative number) to turn off live update. Live update can further be toggled using `VinylLiveUpdateSet()`. Live update only works when running from the IDE on Windows, Mac, or Linux.

&nbsp;

## `VINYL_STEP_DURATION`

*Default value: `50`*

Length of moment-to-moment gain adjustments, in milliseconds. Choose lower values for tigher, quicker gain adjustment. Choose higher values for smooth, less glitchy gain adjustment.

&nbsp;

## `VINYL_POOL_START_SIZE`

*Default value: `20`*

Number of voices and emitters pre-created per pool.

&nbsp;

## `VINYL_LISTENER_INDEX`

*Default value: `0`*

Listener index to use for Vinyl functions.