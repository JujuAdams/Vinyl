# Playing Audio

&nbsp;

## `VinylPlay`

`VinylPlay(sound/pattern, [loop], [gain=1], [pitch=1], [duckerName], [duckPriority=0])`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, a handle that can be used to control this particular instance of sound playback

|Name            |Datatype              |Purpose                                                                                                        |
|----------------|----------------------|---------------------------------------------------------------------------------------------------------------|
|`sound/pattern` |sound, or pattern name|GameMaker sound asset or Vinyl pattern to play                                                                 |
|`[loop]`        |boolean               |Whether the voice should loop. This **overrides** the loop value defined when setting up the sound/pattern     |
|`[gain=1]`      |number                |Starting gain for the voice. This is **multiplied** with the gain defined when setting up the sound/pattern    |
|`[pitch=1]`     |number                |Starting pitch for the voice. This is **multiplied** with the pitch defined when setting up the sound/pattern  |
|`[duckerName]`  |string                |Ducker to use for the voice. This **overrides** the ducker name defined when setting up the sound/pattern      |
|`[duckPriority]`|number                |Ducker priority to use for the voice. This **overrides** the priority defined when setting up the sound/pattern|

Plays a sound or pattern on an emitter. This will override any emitter set for the pattern itself. Sound playback works the same as native GameMaker functions. If you are playing a pattern, the exact playback behaviour will change depending on the type of pattern:

- Shuffle chooses a random sound from an array of sounds
- Blend plays multiple sounds whose balance can be adjusted by setting the blend factor
- Head-Loop-Tail plays a head, then a loop (until the end loop function is called), then a tail

This function returns a voice index which can be used with other Vinyl functions to adjust playback and trigger pattern behaviours where relevant.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylPlayFadeIn`

`VinylPlayFadeIn(sound/pattern, [loop], [targetGain=1], [rateOfChange], [pitch=1], [duckerName], [duckPriority=0])`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, a handle that can be used to control this particular instance of sound playback

|Name            |Datatype              |Purpose                                                                                                                  |
|----------------|----------------------|-------------------------------------------------------------------------------------------------------------------------|
|`sound/pattern` |sound, or pattern name|GameMaker sound asset or Vinyl pattern to play                                                                           |
|`[loop]`        |boolean               |Whether the voice should loop. This **overrides** the loop value defined when setting up the sound/pattern               |
|`[targetGain=1]`|number                |Target gain for the voice after fading in. This is **multiplied** with the gain defined when setting up the sound/pattern|
|`[rateOfChange]`|number                |Rate of change for the gain during the fade in. Defaults to `VINYL_DEFAULT_FADE_IN_RATE`                                 |
|`[pitch=1]`     |number                |Starting pitch for the voice. This is **multiplied** with the pitch defined when setting up the sound/pattern            |
|`[duckerName]`  |string                |Ducker to use for the voice. This **overrides** the ducker name defined when setting up the sound/pattern                |
|`[duckPriority]`|number                |Ducker priority to use for the voice. This **overrides** the priority defined when setting up the sound/pattern          |

Convenience function to play a new sound or pattern and fade it in. Please see `VinylPlay()` for more information. The rate of change for this function is measured in "gain units per second".

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylPlayOn`

`VinylPlayOn(emitter, sound/pattern, [loop], [gain=1], [pitch=1], [duckerName], [duckPriority=0])`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, a handle that can be used to control this particular instance of sound playback

|Name            |Datatype              |Purpose                                                                                                        |
|----------------|----------------------|---------------------------------------------------------------------------------------------------------------|
|`emitter`       |GameMaker emitter     |GameMaker emitter to play the sound on                                                                         |
|`sound/pattern` |sound, or pattern name|GameMaker sound asset or Vinyl pattern to play                                                                 |
|`[loop]`        |boolean               |Whether the voice should loop. This **overrides** the loop value defined when setting up the sound/pattern     |
|`[gain=1]`      |number                |Starting gain for the voice. This is **multiplied** with the gain defined when setting up the sound/pattern    |
|`[pitch=1]`     |number                |Starting pitch for the voice. This is **multiplied** with the pitch defined when setting up the sound/pattern  |
|`[duckerName]`  |string                |Ducker to use for the voice. This **overrides** the ducker name defined when setting up the sound/pattern      |
|`[duckPriority]`|number                |Ducker priority to use for the voice. This **overrides** the priority defined when setting up the sound/pattern|

Plays a sound or pattern. Sound playback works the same as native GameMaker functions. If you are playing a pattern, the exact playback behaviour will change depending on the type of pattern:

- Shuffle chooses a random sound from an array of sounds
- Blend plays multiple sounds whose balance can be adjusted by setting the blend factor
- Head-Loop-Tail plays a head, then a loop (until the end loop function is called), then a tail

This function returns a voice index which can be used with other Vinyl functions to adjust playback and trigger pattern behaviours where relevant.

?> You **don't** need to register the emitter with `VinylRegisterEmitter()`. You can use any native GameMaker emitter.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

## `VinylPlayAt`

`VinylPlayAt(sound/pattern, x, y, z, [falloffDist], [falloffMaxDist], [falloffFactor], [loop], [gain=1], [pitch=1], [duckerName], [duckPriority=0])`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, a handle that can be used to control this particular instance of sound playback

|Name              |Datatype              |Purpose                                                                                                                 |
|------------------|----------------------|------------------------------------------------------------------------------------------------------------------------|
|`sound/pattern`   |sound, or pattern name|GameMaker sound asset or Vinyl pattern to play                                                                          |
|`x`               |number                |x-coordinate to play the sound at                                                                                       |
|`y`               |number                |y-coordinate to play the sound at                                                                                       |
|`z`               |number                |z-coordinate to play the sound at                                                                                       |
|`[falloffDist]`   |number                |Falloff reference relative to the listener. If not specified, defaults to `VINYL_DEFAULT_FALLOFF_DIST`                  |
|`[falloffMaxDist]`|number                |Maximum falloff distance relative to the listener. If not specified, defaults to `VINYL_DEFAULT_FALLOFF_MAX_DIST`       |
|`[falloffFactor]` |number                |Degree to which audio gain decreases as distance increases. If not specified, defaults to `VINYL_DEFAULT_FALLOFF_FACTOR`|
|`[loop]`          |boolean               |Whether the voice should loop. This **overrides** the loop value defined when setting up the sound/pattern              |
|`[gain=1]`        |number                |Starting gain for the voice. This is **multiplied** with the gain defined when setting up the sound/pattern             |
|`[pitch=1]`       |number                |Starting pitch for the voice. This is **multiplied** with the pitch defined when setting up the sound/pattern           |
|`[duckerName]`    |string                |Ducker to use for the voice. This **overrides** the ducker name defined when setting up the sound/pattern               |
|`[duckPriority]`  |number                |Ducker priority to use for the voice. This **overrides** the priority defined when setting up the sound/pattern         |
|`[effectBus]`     |effect bus            |Effect bus to use for the temporary emitter. Use `undefined` to indicate no emitter should be set                       |

Plays a sound or pattern at a specific coordinate. This function creates a temporary emitter that is cleaned up for you once the sound finishes playing. This emitter will override any emitter set for the pattern itself. You can return this emitter using `VinylGetEmitter()` and you can also set an effect bus for the temporary emitter via this function by setting the optional `effectBus` parameter. Otherwise, sound playback works the same as native GameMaker functions. If you are playing a pattern, the exact playback behaviour will change depending on the type of pattern:

- Shuffle chooses a random sound from an array of sounds
- Blend plays multiple sounds whose balance can be adjusted by setting the blend factor
- Head-Loop-Tail plays a head, then a loop (until the end loop function is called), then a tail

You may also choose to give specific falloff values. These work the same as GameMaker's native `audio_play_sound_at()`. Default values are defined by setting the `VINYL_DEFAULT_FALLOFF*` macros.

This function returns a voice index which can be used with other Vinyl functions to adjust playback and trigger pattern behaviours where relevant.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylIsPlaying`

`VinylIsPlaying(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns if the target voice is currently playing.

?> This function only works with voices and will not work with patterns or sound assets.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->