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
|`behavior`      |number          |[`VINYL_DEFAULT_QUEUE_BEHAVIOR`](Config-Macros)|Must be one of the following: `0` `1` `2`             |

&nbsp;

## `VinylQueuePush`

`VinylQueuePush(target, asset, [dontRepeatLast=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name              |Datatype|Purpose                                                           |
|------------------|--------|------------------------------------------------------------------|
|`target`          |voice   |The Queue pattern voice to target                                 |
|`asset`           |sound   |The sound to push to the end of the queue                         |
|`[dontRepeatLast]`|boolean |Whether to allow sequential, identical assets. Defaults to `false`|

Pushes an asset onto a Queue pattern voice for playback. If `dontRepeatLast` is set to `false` then you may push the same asset to the end of the queue multiple times. If `dontRepeatLast` is set to `true`, only one copy of a particular asset can be at the end of the queue.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueBehaviorSet`

`VinylQueueBehaviorSet(target, behavior)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                          |
|----------|--------|---------------------------------|
|`target`  |voice   |The Queue pattern voice to target|
|`behavior`|number  |Behaviour to set, see below      |

The `behavior` argument can be set to one of the following values:

|Value|Behaviour                                                                                                                     |
|-----|------------------------------------------------------------------------------------------------------------------------------|
|`0`  |Play the queue once. Assets will be removed from the queue once they finish playing                                           |
|`1`  |Repeat the queue once it's finished. No assets are removed from the queue, and the queue will replay from the start           |
|`2`  |Repeat the last asset in the queue. Assets will be removed from the queue once they finish playing (apart from the last asset)|

?> The default value for Queue pattern behaviour is defined by [`VINYL_DEFAULT_QUEUE_BEHAVIOR`](Config-Macros).

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueBehaviorGet`

`VinylQueueBehaviorGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the behaviour for the [Queue pattern voice](Terminology)

|Name    |Datatype|Purpose                          |
|--------|--------|---------------------------------|
|`target`|voice   |The Queue pattern voice to target|

See above for a description of potential values for Queue behaviours.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->