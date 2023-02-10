# Gain

&nbsp;

## `VinylGainSet`

`VinylGainSet(id, gain)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |
|`gain`   |        |                                                  |

Sets the gain of [Vinyl instance](Terminology) or [Vinyl label](Terminology).

If an instance is specified, the instance gain is set. This gain is independent of, for example, label gain, asset gain, and system gain.

If a label is specified, the gain for the label is set. This will immediately impact all current instances assigned to that label, and will impact future instances too.

&nbsp;

## `VinylGainGet`

`VinylGainGet(id)`

&nbsp;

*Returns:* Number, the gain for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylGainTargetSet`

`VinylGainTargetSet(id, gain, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |
|`gain`   |        |                                                  |
|`[rate]` |        |                                                  |

Sets the target gain of [Vinyl instance](Terminology) or [Vinyl label](Terminology). The gain for that instance or label will change over time at the given rate until reaching its target.

!> Setting a target gain of `0` for an instance will not stop the instance when reaching silence. Please use `VinylFadeOut()` to fade out and stop an instance.

&nbsp;

## `VinylGainTargetGet`

`VinylGainTargetGet(id)`

&nbsp;

*Returns:* Number, the target gain for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylOutputGainGet`

`VinylOutputGainGet(id)`

&nbsp;

*Returns:* Number, the final output gain of the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |