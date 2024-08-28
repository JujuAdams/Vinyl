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

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->