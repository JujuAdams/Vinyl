# Queue Patterns

&nbsp;

Functions on this page relate to specific behaviours for [Queue pattern](Terminology) instances.

&nbsp;

## `VinylQueuePush`

`VinylQueuePush(id, asset, [dontRepeatLast=false])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name              |Datatype      |Purpose                                                           |
|------------------|--------------|------------------------------------------------------------------|
|`id`              |Vinyl instance|Queue instance to target                                          |
|`asset`           |sound         |The sound to push to the end of the queue                         |
|`[dontRepeatLast]`|boolean       |Whether to allow sequential, identical assets. Defaults to `false`|

Pushes an asset onto a Queue instance for playback. If `dontRepeatLast` is set to `false` then you may push the same asset to the end of the queue multiple times. If `dontRepeatLast` is set to `true`, only one copy of a particular asset can be at the end of the queue.

&nbsp;

## `VinylQueueBehaviorSet`

`VinylQueueBehaviorSet(id, behavior)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name      |Datatype      |Purpose                    |
|----------|--------------|---------------------------|
|`id`      |Vinyl instance|Queue instance to target   |
|`behavior`|number        |Behaviour to set, see below|

The `behavior` argument can be set to one of the following values:

|Value|Behaviour                                                                                                                     |
|-----|------------------------------------------------------------------------------------------------------------------------------|
|`0`  |Play the queue once. Assets will be removed from the queue once they finish playing                                           |
|`1`  |Repeat the queue once it's finished. No assets are removed from the queue, and the queue will replay from the start           |
|`2`  |Repeat the last asset in the queue. Assets will be removed from the queue once they finish playing (apart from the last asset)|

?> The default value for Queue instance behaviour is `1` - to remove all assets from the queue after they've finished playing.

&nbsp;

## `VinylQueueBehaviorGet`

`VinylQueueBehaviorGet(id)`

&nbsp;

*Returns:* Number, the behaviour for the [Queue pattern](Terminology) instance

|Name|Datatype      |Purpose                 |
|----|--------------|------------------------|
|`id`|Vinyl instance|Queue instance to target|

See above for a description of potential values for Queue instance behaviours.