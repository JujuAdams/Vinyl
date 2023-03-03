# Shuffle Patterns

&nbsp;

Shuffle patterns play a random asset from an array. Shuffle patterns also try to ensure that the same sound is not played twice in a row (in fact, shuffle patterns try to space out sounds as much as possible).

&nbsp;

## Configuration Properties

|Property        |Datatype        |Default      |Notes                                                                                                      |
|----------------|----------------|-------------|-----------------------------------------------------------------------------------------------------------|
|`type`          |string          |             |**Required. Must be `shuffle`**                                                                            |
|`assets`        |array           |             |**Required.** An array of asset names as strings                                                           |
|`gain`          |number          |`1`          |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`          |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*|                                                                                                           |
|`loop`          |boolean         |*passthrough*|                                                                                                           |
|`stack`         |string          |*passthrough*|                                                                                                           |
|`stack priority`|number          |`0`          |                                                                                                           |
|`effect chain`  |string          |*passthrough*|                                                                                                           |
|`label`         |string or array |*passthrough*|Label to assign this pattern to. Can be a string for a single label, or an array of label names            |
|`persistent`    |boolean         |*passthrough*|                                                                                                           |