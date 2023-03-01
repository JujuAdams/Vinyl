# Pitch

&nbsp;

Pitch is a multiplier applied to the frequency of the sound. A higher value makes the sound higher pitched (squeakier) and shorter, whereas a lower value makes the sound deeper and longer. Where Vinyl requires a pitch value to be supplied as a function argument, expects normalised pitch values. A pitch value of `1` indicates no change to pitch, a value of `2` indicates a doubling in pitch, and so on.

Some people may find the use of normalised pitch confusing. By setting [`VINYL_CONFIG_PERCENTAGE_PITCH`](Config-Macros) to `true`, [Vinyl's configuration file](Configuration) will now use percentage values for pitches (functions still use normalised values, however). A value of `100` is equivalent to a normalised value of `1`, and a value of `50` is equivalent to a normalised gain of `0.5` (i.e. half the frequency). This hopefully eases the process of configuration pitches.

Vinyl can adjust the pitch of a sound at multiple stages in the signal path. Here's the fundamental pitch equation:

```
output = asset
         * voice
         * transposition
         * parent
         * (label[0] * label[1] * ...)
```

`output` is the value returned by `VinylOutputPitchGet()`, which is also the actual pitch that is used to fill the audio buffer.

|Term           |Meaning                                                                                                                                                                                                                    |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`output`       |The resultant pitch of the sound after Vinyl finishes messing with it                                                                                                                                                      |
|`asset`        |Set in the [configuration file](Configuration) per asset (or pattern)                                                                                                                                                      |
|`voice`        |Set on creation (by `VinylPlay()` etc.) and additionally altered by [`VinylPitchSet()` and `VinylTargetPitchSet()`](Gain). For sounds that are children of pattern voices, `voice pitch` is inaccessible and is usually `1`|
|`transposition`|The pitch contribution from [transposition](Transposition) (which has its own inheritance behaviour)                                                                                                                       |
|`parent`       |Set implicitly by a pattern that caused a sound to be played e.g. a Multi pattern voice is the parent of each child voice that is concurrently playing for that pattern                                                    |
|`label`        |Set in the [configuration file](Configuration), and additionally altered by `VinylPitchSet()` and `VinylTargetPitchSet()` when targeting a label                                                                           |

&nbsp;

## `VinylPitchSet`

`VinylPitchSet(target, pitch)`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name    |Datatype      |Purpose                                                                 |
|--------|--------------|------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                            |
|`pitch` |number        |Voice pitch, in normalised pitch units. Defaults to `1`, no pitch change|

Sets the pitch of [voice or label](Terminology).

If a voice is specified, the voice pitch is set. This pitch is independent of, for example, label pitch and asset pitch.

If a label is specified, the pitch for the label is set. This will immediately impact all current voices assigned to that label, and will impact future voices too.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPitchGet`

`VinylPitchGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the pitch for the [voice or label](Terminology)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPitchTargetSet`

`VinylPitchTargetSet(target, pitch, [rate=VINYL_DEFAULT_PITCH_RATE])`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name    |Datatype      |Purpose                                                                                              |
|--------|--------------|-----------------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                                         |
|`pitch` |number        |Target pitch, in normalised pitch units                                                              |
|`[rate]`|number        |Speed to approach the target pitch, in pitch units per second. Defaults to `VINYL_DEFAULT_PITCH_RATE`|

Sets the target pitch of [voice or label](Terminology). The pitch for that voice or label will change over time at the given rate until reaching its target.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPitchTargetGet`

`VinylPitchTargetGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the target pitch for the [voice or label](Terminology)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylOutputPitchGet`

`VinylOutputPitchGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the final output pitch of the [voice or label](Terminology)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->