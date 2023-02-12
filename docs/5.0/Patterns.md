# Patterns

&nbsp;

Functions on this page relate to specific behaviours for [Vinyl pattern](Terminology) instances.

&nbsp;

## `VinylShuffle`

`VinylShuffle(assetArray, [label])`

&nbsp;

*Returns:* A Vinyl pattern

|Name        |Datatype       |Purpose                                           |
|------------|---------------|--------------------------------------------------|
|`assetArray`|               |                                                  |
|`[label]`   |string or array|                                                  |

Creates a new [Shuffle pattern](Terminology). This function creates an "anonymous" pattern and is one way of creating a Shuffle pattern - the other is to use Vinyl's [configuration file](Configuration).

This function returns a Vinyl pattern which can then be used with the standard playback functions such as [`VinylPlay()`](Basics). The pattern itself plays no audio itself and only exists as a template for use with other functions.

&nbsp;

## `VinylQueue`

`VinylQueue(assetArray, [label])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name        |Datatype       |Purpose                                           |
|------------|---------------|--------------------------------------------------|
|`assetArray`|               |                                                  |
|`[label]`   |string or array|                                                  |

Creates a new [Queue pattern](Terminology). This function creates an "anonymous" pattern and is one way of creating a Queue pattern - the other is to use Vinyl's [configuration file](Configuration).

This function returns a Vinyl pattern which can then be used with the standard playback functions such as [`VinylPlay()`](Basics). The pattern itself plays no audio itself and only exists as a template for use with other functions.

&nbsp;

## `VinylBlend`

`VinylBlend(assetArray, [label])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name        |Datatype       |Purpose                                           |
|------------|---------------|--------------------------------------------------|
|`assetArray`|               |                                                  |
|`[label]`   |string or array|                                                  |

Creates a new [Blend pattern](Terminology). This function creates an "anonymous" pattern and is one way of creating a Blend pattern - the other is to use Vinyl's [configuration file](Configuration).

This function returns a Vinyl pattern which can then be used with the standard playback functions such as [`VinylPlay()`](Basics). The pattern itself plays no audio itself and only exists as a template for use with other functions.

!> Individual assets within a Blend pattern may fall out of sync. Do not rely on this pattern for audio synchronisation.

&nbsp;

## `VinylQueueNext`

`VinylQueueNext(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose                                           |
|----|--------|--------------------------------------------------|
|`id`|        |                                                  |

Causes a Queue instance to move to the next asset in the array.

&nbsp;

## `VinylQueuePush`

`VinylQueueNext(id, asset, [dontRepeatLast=false])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name              |Datatype|Purpose                                           |
|------------------|--------|--------------------------------------------------|
|`id`              |        |                                                  |
|`asset`           |        |                                                  |
|`[dontRepeatLast]`|        |                                                  |

Pushes an asset onto a Queue instance for playback. If `dontRepeatLast` is set to `false` then you may push the same asset to the end of the queue multiple times. If `dontRepeatLast` is set to `true`, only one copy of a particular asset can be at the end of the queue.

&nbsp;

## `VinylQueueBehaviorSet`

`VinylQueueBehaviorSet(id, behavior)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`id`      |        |                                                  |
|`behavior`|        |                                                  |

The `behavior` argument can be set to one of the following values:

|Value|Behaviour                                                                                                                                              |
|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------|
|`0`  |**Don't** remove assets from the queue's array after they've finished playing. This is helpful for queues that are set to loop                         |
|`1`  |Remove assets from the queue's array after they've finished playing. This is useful for stacking up sound effects to be played sequentially            |
|`2`  |Remove assets after they've finished playing, apart from the very last asset. This assists with queues that want to loop on the last asset in the queue|

?> The default value for Queue instance behaviour is `1` - to remove all assets from the queue after they've finished playing.

&nbsp;

## `VinylQueueBehaviorGet`

`VinylQueueBehaviorGet(id)`

&nbsp;

*Returns:* Number, the behaviour for the [Queue pattern](Terminology) instance

|Name|Datatype|Purpose                                           |
|----|--------|--------------------------------------------------|
|`id`|        |                                                  |

See above for a description of potential values for Queue instance behaviours.

&nbsp;

## `VinylBlendSet`

`VinylBlendSet(id, blendFactor)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name         |Datatype|Purpose                                           |
|-------------|--------|--------------------------------------------------|
|`id`         |        |                                                  |
|`blendFactor`|        |                                                  |

Sets the blending factor, mixing between different assets playing on a [Blend pattern](Terminology) instance. The blending factor is a normalised value between `0` and `1`.

&nbsp;

## `VinylBlendGet`

`VinylBlendGet(id)`

&nbsp;

*Returns:* Number, the blend factor for the [Blend pattern](Terminology) instance

|Name|Datatype|Purpose                                           |
|----|--------|--------------------------------------------------|
|`id`|        |                                                  |