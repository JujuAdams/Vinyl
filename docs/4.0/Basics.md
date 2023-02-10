# Basics

&nbsp;

Functions on this page relate to using Vinyl at a basic level - playing audio, stopping audio, and pausing/resuming audio.

&nbsp;

## `VinylPlaySimple`

`VinylPlaySimple(sound, [gain=1], [pitch=1])`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`sound`  |        |                                                  |
|`[gain]` |        |                                                  |
|`[pitch]`|        |                                                  |

&nbsp;

## `VinylPlay`

`VinylPlay(sound, [loop], [gain=1], [pitch=1], [pan])`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`sound`  |        |                                                  |
|`[loop]` |        |                                                  |
|`[gain]` |        |                                                  |
|`[pitch]`|        |                                                  |
|`[pan]`  |        |                                                  |

&nbsp;

## `VinylPlayFadeIn`

`VinylPlayFadeIn(sound, [loop], [targetGain=1], [rate=VINYL_DEFAULT_GAIN_RATE], [pitch=1])`

&nbsp;

*Returns:*

|Name          |Datatype|Purpose                                           |
|--------------|--------|--------------------------------------------------|
|`sound`       |        |                                                  |
|`[loop]`      |        |                                                  |
|`[targetGain]`|        |                                                  |
|`[rate]`      |        |                                                  |
|`[pitch]`     |        |                                                  |

&nbsp;

## `VinylFadeOut`

`VinylFadeOut(id, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:*

|Name    |Datatype|Purpose                                           |
|--------|--------|--------------------------------------------------|
|`id`    |        |                                                  |
|`[rate]`|        |                                                  |

&nbsp;

## `VinylStop`

`VinylStop(id)`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylStopAll`

`VinylStopAll()`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `VinylExists`

`VinylExists(id)`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylPause`

`VinylPause(id)`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylPausedGet`

`VinylPausedGet(id)`

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

&nbsp;

## `VinylResume`

`VinylResume(id)`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |