# Basic Patterns

&nbsp;

Basic patterns are effectively a copy of asset definitions but with the option to change properties independently of the source asset. This is useful for repurposing a single sound asset for multiple purposes, such as a coin pick-up sound effect pitch shifted to different values depending on whether a low value or high value coin has been collected.

&nbsp;

## Configuration Properties

|Property        |Datatype        |Default      |Notes                                                                                                                        |
|----------------|----------------|-------------|-----------------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |*passthrough*|**Required.** Must be one of the following: `basic` `shuffle` `queue` `multi`                                                |
|`asset`         |string or struct|*passthrough*|**Required.** Can be asset name, a pattern name, or a pattern struct. Must be an array for shuffle, queue, and multi patterns|
|`gain`          |number          |`1`          |Defaults to `0` db in [decibel mode](Config-Macros)                                                                          |
|`pitch`         |number or array |`1`          |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)                  |
|`transpose`     |number          |*passthrough*|                                                                                                                             |
|`loop`          |boolean         |*passthrough*|                                                                                                                             |
|`loop points`   |array of numbers|*passthrough*|Must be a two-element array defining the start and end point of a loop, measured in seconds                                  |
|`stack`         |string          |*passthrough*|                                                                                                                             |
|`stack priority`|number          |`0`          |                                                                                                                             |
|`effect chain`  |string          |*passthrough*|                                                                                                                             |
|`label`         |string or array |*passthrough*|Label to assign this pattern to. Can be a string for a single label, or an array of label names                              |
|`persistent`    |boolean         |*passthrough*|                                                                                                                             |