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
|`semitone`|        |                                                  |

Sets the number of semitones to transpose.

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

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`id`      |        |                                                  |
|`semitone`|        |                                                  |

Sets the number of semitones to transpose a particular [Vinyl instance](Terminology) or [Vinyl label](Terminology). A value of `0` will turn on transposition for the instance.

If a label is specified, each currently playing instance assigned to that label will have its transposition state set. The label itself has no "transposition" state and any new instances will be played without transposition.

&nbsp;

## `VinylTransposeReset`

`VinylTransposeReset(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`id`      |        |                                                  |

Disables transposition for a [Vinyl instance](Terminology) or [Vinyl label](Terminology).

If a label is specified, each currently playing instance assigned to that label will have its transposition state reset.

&nbsp;

## `VinylTransposeGet`

`VinylGlobalTransposeGet(id)`

&nbsp;

*Returns:* Number, the current transposition state for the [Vinyl instance](Terminology)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`id`      |        |                                                  |

?> You cannot get a transposition state from a label as they have none.