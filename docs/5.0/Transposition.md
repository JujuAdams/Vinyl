# Transposition

&nbsp;

Tuning sound effects to harmonise nicely with background music is a technique that designers regularly employ to tie a game's audio together. Vinyl allows for audio to track changes in pitch per label, asset, pattern, and instance. The entire system can also have a transposition applied to it - though the global transposition state only applies to sounds that are already being transposed (even if the local resultant transposition value is `0`).

To this end, transposition can be enabled in multiple ways. A Vinyl instance will inherit transposition value additively from any labels for the instance, from assets and patterns, and the per-instance transposition value can be set by calling `VinylTransposeSet()`.

Generally speaking, you'll want to set your system-wide transposition based on the background music you're playing. Any instance that has inherited a non-`undefined` transposition (even if it's `0`) will then track along with the global transposition state, hopefully tracking along with the tonality of your background music.

&nbsp;

# Functions

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

## `VinylTransposeGet`

`VinylGlobalTransposeGet(id)`

&nbsp;

*Returns:* Number, the current transposition state for the [Vinyl instance](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

?> You cannot get a transposition state from a label as they have none.