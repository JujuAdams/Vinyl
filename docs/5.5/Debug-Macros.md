# Debug Macros

&nbsp;

Macros on this page relate to debug behaviour and can be found in the `__VinylConfigDebug` script.

!> You should turn off these values before creating production builds to avoid unnecessary performance penalties for your players.

&nbsp;

## `VINYL_DEBUG_LEVEL`

*Default value: `0`*

How much debug spam to chuck at the debug log. This macro can have one of three values:

|Value|Output                                                            |
|-----|------------------------------------------------------------------|
|`0`  |Minimum, warnings only                                            |
|`1`  |Some, messages created when interacting with most API functions   |
|`2`  |Obnoxious amounts, updates for virtually every internal operation|

&nbsp;

## `VINYL_DEBUG_SHOW_FRAMES`

*Default value: `false`*

Whether to show the frame number in debug messages.

&nbsp;

## `VINYL_DEBUG_READ_CONFIG`

*Default value: `false`*

Whether to output extra debug information when reading configuration data.