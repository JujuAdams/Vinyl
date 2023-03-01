# Pitch

&nbsp;

Pitch is a multiplier applied to the frequency of the sound. A higher value makes the sound higher pitched (squeakier) and shorter, whereas a lower value makes the sound deeper and longer. Where Vinyl requires a pitch value to be supplied as a function argument, expects normalised pitch values. A pitch value of `1` indicates no change to pitch, a value of `2` indicates a doubling in pitch, and so on.

I've always found the use of normalised values for pitch confusing. By setting [`VINYL_CONFIG_PERCENTAGE_PITCH`](Config-Macros) to `true`, [Vinyl's configuration file](Configuration) will now use percentage values for pitches (functions still use normalised values, however). A value of `100` is equivalent to a normalised value of `1`, and a value of `50` db is equivalent to a normalised gain of `0.5` (i.e. half the frequency).

# Functions

## `VinylPitchSet`

`VinylPitchSet(id, pitch)`

&nbsp;

*Returns:*

|Name   |Datatype      |Purpose                                                                    |
|-------|--------------|---------------------------------------------------------------------------|
|`id`   |Vinyl instance|Instance to target                                                         |
|`pitch`|number        |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change|

Sets the pitch of [Vinyl instance](Terminology) or [Vinyl label](Terminology).

If an instance is specified, the instance pitch is set. This pitch is independent of, for example, label pitch and asset pitch.

If a label is specified, the pitch for the label is set. This will immediately impact all current instances assigned to that label, and will impact future instances too.

&nbsp;

## `VinylPitchGet`

`VinylPitchGet(id)`

&nbsp;

*Returns:* Number, the pitch for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylPitchTargetSet`

`VinylPitchTargetSet(id, pitch, [rate=VINYL_DEFAULT_PITCH_RATE])`

&nbsp;

*Returns:*

|Name    |Datatype        |Purpose                                                                                              |
|--------|----------------|-----------------------------------------------------------------------------------------------------|
|`sound` |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                       |
|`pitch` |number          |Target pitch, in normalised pitch units                                                              |
|`[rate]`|number          |Speed to approach the target pitch, in pitch units per second. Defaults to `VINYL_DEFAULT_PITCH_RATE`|

Sets the target pitch of [Vinyl instance](Terminology) or [Vinyl label](Terminology). The pitch for that instance or label will change over time at the given rate until reaching its target.

&nbsp;

## `VinylPitchTargetGet`

`VinylPitchTargetGet(id)`

&nbsp;

*Returns:* Number, the target pitch for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylOutputPitchGet`

`VinylOutputPitchGet(id)`

&nbsp;

*Returns:* Number, the final output pitch of the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|