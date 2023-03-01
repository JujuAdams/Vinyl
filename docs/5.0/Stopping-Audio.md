# Stopping Audio

&nbsp;

Stopping audio is a surprisingly involved process.

&nbsp;

## `VinylFadeOut`

`VinylFadeOut(id, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                                   |
|--------|--------------|------------------------------------------------------------------------------------------|
|`id`    |Vinyl instance|Instance to target                                                                        |
|`[rate]`|number        |Speed to approach silence, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Begins a fade out for a [Vinyl instance](Terminology) or [Vinyl label](Terminology). This puts the instance into "shutdown mode" which can be detected later by [`VinylShutdownGet()`](Advanced).

If an instance is specified, the instance's gain will decrease at the given rate (in normalised gain units per second) until the gain reaches zero, at which point the sound is stopped and the instance is marked as destroyed.

If a label is specified, each currently playing instance assigned to that label will fade out. The label itself has no "fade out" state and any new instances will be played at their normal gain.

&nbsp;

## `VinylStop`

`VinylStop(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

Immediately stops playback of a Vinyl instance and marks it as destroyed.

If a label is specified, each currently playing instance assigned to that label will be immediately stopped. The label itself has no "stopped" state and any new instances will be played as normal.

&nbsp;

## `VinylStopAll`

`VinylStopAll()`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Immediately stops playback of all currently Vinyl instance and marks them as destroyed.