# Multi Patterns

&nbsp;

Functions on this page relate to specific behaviours for [Multi pattern](Terminology) instances.

&nbsp;

## `VinylMultiChannelCountGet`

`VinylMultiChannelCountGet(id)`

&nbsp;

*Returns:* Number, the number of channels for the [Multi instance](Terminology)

|Name   |Datatype      |Purpose                 |
|-------|--------------|------------------------|
|`id`   |Vinyl instance|Multi instance to target|

&nbsp;

## `VinylMultiGainSet`

`VinylMultiGainSet(id, index, gain)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name   |Datatype      |Purpose                       |
|-------|--------------|------------------------------|
|`id`   |Vinyl instance|Multi instance to target      |
|`index`|number        |Channel to target             |
|`gain` |number        |Instance gain to set, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|

Sets the gain of an individual channel of a [Multi instance](Terminology). Gain set by this function will be overwritten by `VinylMultiBlendSet()`.

&nbsp;

## `VinylMultiGainSet`

`VinylMultiGainGet(id, index)`

&nbsp;

*Returns:* Number, the gain for the channel of a [Multi instance](Terminology)

|Name   |Datatype      |Purpose                 |
|-------|--------------|------------------------|
|`id`   |Vinyl instance|Multi instance to target|
|`index`|number        |Channel to target       |

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

Gain set by this function will be overwritten by `VinylMultiGainSet()`.

&nbsp;

## `VinylMultiBlendGet`

`VinylMultiBlendGet(id)`

&nbsp;

*Returns:* Number, the blend factor for the [Multi pattern](Terminology) instance

|Name|Datatype      |Purpose                 |
|----|--------------|------------------------|
|`id`|Vinyl instance|Multi instance to target|

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

`VinylMultiSyncSet(id)`

&nbsp;

*Returns:* Boolean, whether the [Multi pattern](Terminology) is set to synchronise playback

|Name|Datatype      |Purpose                 |
|----|--------------|------------------------|
|`id`|Vinyl instance|Multi instance to target|