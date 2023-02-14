# Patterns

&nbsp;

Functions on this page relate to specific behaviours for [Vinyl pattern](Terminology) instances.

&nbsp;

## `VinylQueueNext`

`VinylQueueNext(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype      |Purpose                 |
|----|--------------|------------------------|
|`id`|Vinyl instance|Queue instance to target|

Causes a Queue instance to immediately move to the next asset in the array.

&nbsp;

## `VinylQueuePush`

`VinylQueueNext(id, asset, [dontRepeatLast=false])`

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
|`1`  |Repeat the queue once it's finished. No assets are removed from the queue                                                     |
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

&nbsp;

## `VinylMultiSyncSet`

`VinylMultiSyncSet(id, state)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name   |Datatype      |Purpose                        |
|-------|--------------|-------------------------------|
|`id`   |Vinyl instance|Multi instance to target       |
|`state`|boolean       |Whether to synchronise playback|

?> [Multi pattern](Terminology) synchronisation is not absolutely precise and may wander a little.

!> Make sure that all sound assets played on a synchronised Multi pattern are the same length or you may encounter unexpected behaviour.

&nbsp;

## `VinylMultiSyncGet`

`VinylMultiSyncSet(id, state)`

&nbsp;

*Returns:* Boolean, whether the [Multi pattern](Terminology) is set to synchronise playback

|Name|Datatype      |Purpose                 |
|----|--------------|------------------------|
|`id`|Vinyl instance|Multi instance to target|

&nbsp;

## `VinylMultiBlendSet`

`VinylMultiBlendSet(id, blendFactor)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name         |Datatype      |Purpose                       |
|-------------|--------------|------------------------------|
|`id`         |Vinyl instance|Multi instance to target      |
|`blendFactor`|number        |Blend factor to set, see below|

Sets the blending factor, mixing between different assets playing on a [Multi pattern](Terminology) instance. The blending factor is a normalised value between `0` and `1`.

&nbsp;

## `VinylMultiBlendGet`

`VinylMultiBlendGet(id)`

&nbsp;

*Returns:* Number, the blend factor for the [Multi pattern](Terminology) instance

|Name|Datatype      |Purpose                 |
|----|--------------|------------------------|
|`id`|Vinyl instance|Multi instance to target|

&nbsp;

# Creators

&nbsp;

## `VinylShuffle`

`VinylShuffle(assetArray, [label])`

&nbsp;

*Returns:* A Vinyl pattern

|Name        |Datatype       |Purpose                                     |
|------------|---------------|--------------------------------------------|
|`assetArray`|array of assets|Array of assets to use to create the pattern|
|`[label]`   |string or array|Label (or labels) to assign this pattern to |

Creates a new [Shuffle pattern](Terminology). This function creates an "anonymous" pattern and is one way of creating a Shuffle pattern - the other is to use Vinyl's [configuration file](Configuration).

This function returns a Vinyl pattern which can then be used with the standard playback functions such as [`VinylPlay()`](Basics). The pattern itself plays no audio itself and only exists as a template for use with other functions.

&nbsp;

## `VinylQueue`

`VinylQueue(assetArray, [label])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name        |Datatype       |Purpose                                     |
|------------|---------------|--------------------------------------------|
|`assetArray`|array of assets|Array of assets to use to create the pattern|
|`[label]`   |string or array|Label (or labels) to assign this pattern to |

Creates a new [Queue pattern](Terminology). This function creates an "anonymous" pattern and is one way of creating a Queue pattern - the other is to use Vinyl's [configuration file](Configuration).

This function returns a Vinyl pattern which can then be used with the standard playback functions such as [`VinylPlay()`](Basics). The pattern itself plays no audio itself and only exists as a template for use with other functions.

&nbsp;

## `VinylBlend`

`VinylBlend(assetArray, [label])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name        |Datatype       |Purpose                                     |
|------------|---------------|--------------------------------------------|
|`assetArray`|array of assets|Array of assets to use to create the pattern|
|`[label]`   |string or array|Label (or labels) to assign this pattern to |

Creates a new [Blend pattern](Terminology). This function creates an "anonymous" pattern and is one way of creating a Blend pattern - the other is to use Vinyl's [configuration file](Configuration).

This function returns a Vinyl pattern which can then be used with the standard playback functions such as [`VinylPlay()`](Basics). The pattern itself plays no audio itself and only exists as a template for use with other functions.

!> Individual assets within a Blend pattern may fall out of sync. Do not rely on this pattern for audio synchronisation.
