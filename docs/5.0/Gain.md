# Gain

&nbsp;

Functions on this page relate to setting and manipulating gain for [Vinyl instances](Terminology) and [Vinyl labels](Terminology).

&nbsp;

## `VinylGainSet`

`VinylGainSet(id, gain)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name  |Datatype      |Purpose                                                                                                                                                                                  |
|------|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`id`  |Vinyl instance|Instance to target                                                                                                                                                                       |
|`gain`|number        |Instance gain to set, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|

Sets the gain of [Vinyl instance](Terminology) or [Vinyl label](Terminology).

If an instance is specified, the instance gain is set. This gain is independent of, for example, label gain, asset gain, and system gain.

If a label is specified, the gain for the label is set. This will immediately impact all current instances assigned to that label, and will impact future instances too.

&nbsp;

## `VinylGainGet`

`VinylGainGet(id)`

&nbsp;

*Returns:* Number, the gain for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylGainTargetSet`

`VinylGainTargetSet(id, gain, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name    |Datatype        |Purpose                                                                                                                                                 |
|--------|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound` |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                          |
|`[gain]`|number          |Target gain, in normalised gain units                                                                                                                   |
|`[rate]`|number          |Speed to approach the target gain, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`                                                      |

Sets the target gain of [Vinyl instance](Terminology) or [Vinyl label](Terminology). The gain for that instance or label will change over time at the given rate until reaching its target.

!> Setting a target gain of `0` for an instance will not stop the instance when reaching silence. Please use `VinylFadeOut()` to fade out and stop an instance.

&nbsp;

## `VinylGainTargetGet`

`VinylGainTargetGet(id)`

&nbsp;

*Returns:* Number, the target gain for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylOutputGainGet`

`VinylOutputGainGet(id)`

&nbsp;

*Returns:* Number, the final output gain of the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

You can read more about how the output gain of an instance is calculated [here](Gain-Structure).