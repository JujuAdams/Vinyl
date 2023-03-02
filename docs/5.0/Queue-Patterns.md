# Queue Patterns

&nbsp;

Queue patterns play assets from an array one after another. If a sound asset is set to loop then the queue will hold on that looping asset until the voice is told to stop looping by using `VinylLoopSet()`.

The queue itself can be set to loop, restarting the entire sequence from the start once playback reaches the end of the queue.

&nbsp;

## Configuration Properties

|Property        |Datatype        |Default                                        |Notes                                                                                                                        |
|----------------|----------------|-----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |*passthrough*                                  |**Required.** Must be one of the following: `basic` `shuffle` `queue` `multi`                                                |
|`asset`         |string or struct|*passthrough*                                  |**Required.** Can be asset name, a pattern name, or a pattern struct. Must be an array for shuffle, queue, and multi patterns|
|`gain`          |number          |`1`                                            |Defaults to `0` db in [decibel mode](Config-Macros)                                                                          |
|`pitch`         |number or array |`1`                                            |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)                  |
|`transpose`     |number          |*passthrough*                                  |                                                                                                                             |
|`loop`          |boolean         |*passthrough*                                  |                                                                                                                             |
|`loop points`   |array of numbers|*passthrough*                                  |Must be a two-element array defining the start and end point of a loop, measured in seconds                                  |
|`stack`         |string          |*passthrough*                                  |                                                                                                                             |
|`stack priority`|number          |`0`                                            |                                                                                                                             |
|`effect chain`  |string          |*passthrough*                                  |                                                                                                                             |
|`label`         |string or array |*passthrough*                                  |Label to assign this pattern to. Can be a string for a single label, or an array of label names                              |
|`persistent`    |boolean         |*passthrough*                                  |                                                                                                                             |
|`behavior`      |number          |[`VINYL_DEFAULT_QUEUE_BEHAVIOR`](Config-Macros)|Must be one of the following: `0` `1` `2`                                                                                    |