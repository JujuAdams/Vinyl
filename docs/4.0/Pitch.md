# Pitch

&nbsp;

## `VinylPitchSet`

`VinylPitchSet(id, pitch)`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |
|`pitch`  |        |                                                  |

Sets the pitch of [Vinyl instance](Terminology) or [Vinyl label](Terminology).

If an instance is specified, the instance pitch is set. This pitch is independent of, for example, label pitch and asset pitch.

If a label is specified, the pitch for the label is set. This will immediately impact all current instances assigned to that label, and will impact future instances too.

&nbsp;

## `VinylPitchGet`

`VinylPitchGet(id)`

&nbsp;

*Returns:* Number, the pitch for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylPitchTargetSet`

`VinylPitchTargetSet(id, pitch, [rate=VINYL_DEFAULT_PITCH_RATE])`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |
|`pitch`  |        |                                                  |
|`[rate]` |        |                                                  |

Sets the target pitch of [Vinyl instance](Terminology) or [Vinyl label](Terminology). The pitch for that instance or label will change over time at the given rate until reaching its target.

&nbsp;

## `VinylPitchTargetGet`

`VinylPitchTargetGet(id)`

&nbsp;

*Returns:* Number, the target pitch for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylOutputPitchGet`

`VinylOutputPitchGet(id)`

&nbsp;

*Returns:* Number, the final output pitch of the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |