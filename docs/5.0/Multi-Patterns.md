# Multi Patterns

&nbsp;

Multi patterns play assets from an array simultaneously. The blend parameter stored within the pattern can be set with `VinylMultiBlendSet()` and crossfades between assets.

&nbsp;

## Configuration Properties

|Property        |Datatype        |Default                                     |Notes                                                                                                      |
|----------------|----------------|--------------------------------------------|-----------------------------------------------------------------------------------------------------------|
|`type`          |string          |                                            |**Required. Must be `multi`**                                                                              |
|`assets`        |array           |                                            |**Required.** An array of asset names as strings                                                           |
|`gain`          |number          |`1`                                         |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`                                         |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*                               |                                                                                                           |
|`loop`          |boolean         |*passthrough*                               |                                                                                                           |
|`stack`         |string          |*passthrough*                               |                                                                                                           |
|`stack priority`|number          |`0`                                         |                                                                                                           |
|`effect chain`  |string          |*passthrough*                               |                                                                                                           |
|`label`         |string or array |*passthrough*                               |Label to assign this pattern to. Can be a string for a single label, or an array of label names            |
|`persistent`    |boolean         |*passthrough*                               |                                                                                                           |
|`sync`          |boolean         |[`VINYL_DEFAULT_MULTI_SYNC`](Config-Macros) |                                                                                                           |
|`blend`         |number          |[`VINYL_DEFAULT_MULTI_BLEND`](Config-Macros)|This is a normalised value from `0` to `1` (inclusive)                                                     |
|`blend curve`   |string          |`undefined`                                 |If not defined, linear crossfades are used                                                                 |