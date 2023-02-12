# Semitones

&nbsp;

Functions on this page relate to transpositioning of Vinyl instances.

&nbsp;

## `VinylGlobalTransposeSet`

`VinylGlobalTransposeSet(semitone)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`semitone`|number  |Number of semitones to transpose the entire system|

The pitch shift set by this function follows the Western diatonic scale with the pitch shift being calculated as `pitch = power(2, semitones/12)`.

?> Setting the global transposition will only affect [Vinyl instances](Terminology) that have had their transposition state set.

&nbsp;

## `VinylGlobalTransposeGet`

`VinylGlobalTransposeGet()`

&nbsp;

*Returns:* Number, the current transposition state

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `VinylTransposeSet`

`VinylTransposeSet(id, semitone)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name      |Datatype      |Purpose                                           |
|----------|--------------|--------------------------------------------------|
|`id`      |Vinyl instance|Instance to target                                |
|`semitone`|number        |Number of semitones to transpose the entire system|

Sets the number of semitones to transpose a particular [Vinyl instance](Terminology) or [Vinyl label](Terminology). A value of `0` will turn on transposition for the instance and make it sensitive to the global transposition state. The pitch shift set by this function follows the Western diatonic scale with the pitch shift being calculated as `pitch = power(2, semitones/12)`.

If a label is specified, each currently playing instance assigned to that label will have its transposition state set. The label itself has no "transposition" state and any new instances will be played without transposition.

&nbsp;

## `VinylTransposeReset`

`VinylTransposeReset(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

Disables transposition for a [Vinyl instance](Terminology) or [Vinyl label](Terminology).

If a label is specified, each currently playing instance assigned to that label will have its transposition state reset.

&nbsp;

## `VinylTransposeGet`

`VinylGlobalTransposeGet(id)`

&nbsp;

*Returns:* Number, the current transposition state for the [Vinyl instance](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

?> You cannot get a transposition state from a label as they have none.