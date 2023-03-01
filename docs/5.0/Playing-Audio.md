# Playing Audio

&nbsp;

Functions on this page relate to using Vinyl at a basic level - playing audio, stopping audio, and pausing/resuming audio.

&nbsp;

## `VinylPlaySimple`

`VinylPlaySimple(sound, [gain=1], [pitch=1])`

&nbsp;

*Returns:* GameMaker [sound instance](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm)

|Name     |Datatype        |Purpose                                                                                                                                                                           |
|---------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`  |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                                                    |
|`[gain]` |number          |Instance gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|
|`[pitch]`|number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                                       |

Plays an asset, taking advantage of Vinyl's live updating configuration (including labels). However, this function does **not** create a full fat [Vinyl instance](Terminology) and is, in effect, only a wrapper around GameMaker's native [`audio_play_sound()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm) with the gain and pitch calculated through Vinyl.

!> `VinylPlaySimple()` returns a GameMaker sound instance and **not** a Vinyl instance. As such, the sound instance is not compatible with other Vinyl functions and is provided for your convenience only.

&nbsp;

## `VinylPlay`

`VinylPlay(sound, [loop], [gain=1], [pitch=1], [pan])`

&nbsp;

*Returns:* Vinyl instance

|Name     |Datatype        |Purpose                                                                                                                                                                           |
|---------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`  |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                                                    |
|`[loop]` |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop                          |
|`[gain]` |number          |Instance gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|
|`[pitch]`|number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                                       |
|`[pan]`  |number          |Panning value, from `-1` (left) to `0` (centre) to `+1` (right). Defaults to no panning                                                                                           |

Plays an asset or pattern with the desired settings and returns a [Vinyl instance](Terminology). This instance can then be used with many other Vinyl functions to manipulate and adjust the sound.

!> In the interests of managing performance, if no panning value is specified then the returned instance cannot be panned later with `VinylPanSet()`.

&nbsp;

## `VinylPlayFadeIn`

`VinylPlayFadeIn(sound, [loop], [targetGain=1], [rate=VINYL_DEFAULT_GAIN_RATE], [pitch=1])`

&nbsp;

*Returns:* Vinyl instance

|Name          |Datatype        |Purpose                                                                                                                                                 |
|--------------|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`       |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                          |
|`[loop]`      |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop|
|`[targetGain]`|number          |Target gain, in normalised gain units                                                                                                                   |
|`[rate]`      |number          |Speed to approach the target gain, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`                                                      |
|`[pitch]`     |number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                             |

A convenience function that starts playing an asset or pattern at silence and then gradually increases its gain to reach the given target. This function is effectively the same as:

```gml
var instance = VinylPlay(sound, loop, 0, pitch);
VinylGainTargetSet(instance, targetGain, rate);
return instance;
```

## `VinylExists`

`VinylExists(id)`

&nbsp;

*Returns:* Boolean, whether the given [Vinyl instance](Terminology) or [Vinyl label](Terminology) exists

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|