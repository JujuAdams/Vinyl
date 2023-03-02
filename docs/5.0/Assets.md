# Assets

&nbsp;

## Configuration Properties

|Property        |Datatype        |Default                             |Notes                                                                                                      |
|----------------|----------------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`                                 |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`                                 |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*                       |                                                                                                           |
|`bpm`           |number          |[`VINYL_DEFAULT_BPM`](Config-Macros)|                                                                                                           |
|`loop`          |boolean         |*passthrough*                       |                                                                                                           |
|`loop points`   |array of numbers|*passthrough*                       |Array must have two-elements defining the start and end point of a loop, measured in seconds               |
|`stack`         |string          |*passthrough*                       |                                                                                                           |
|`stack priority`|number          |`0`                                 |                                                                                                           |
|`effect chain`  |string          |*passthrough*                       |                                                                                                           |
|`label`         |string or array |`[]`                                |Label to assign this asset to. Can be a string for for label, or an array of label names                   |
|`persistent`    |boolean         |*passthrough*                       |                                                                                                           |