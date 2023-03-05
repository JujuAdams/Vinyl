# Queue Patterns

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

*Returns:* Number, the behaviour for the Queue pattern voice

|Name    |Datatype|Purpose                          |
|--------|--------|---------------------------------|
|`target`|voice   |The Queue pattern voice to target|

See above for a description of potential values for Queue behaviours.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->