# Playing Audio

&nbsp;

## `VinylPlay`

`VinylPlay(sound/pattern, [loop], [gain=1], [pitch=1], [duckerName], [duckPriority=0])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype              |Purpose                     |
|----------------|----------------------|----------------------------|
|`sound/pattern` |sound, or pattern name|                            |
|`[loop]`        |boolean               |                            |
|`[gain]`        |number                |                            |
|`[pitch]`       |number                |                            |
|`[duckerName]`  |string                |                            |
|`[duckPriority]`|number                |                            |

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

*Returns:* N/A (`undefined`)

|Name            |Datatype              |Purpose                     |
|----------------|----------------------|----------------------------|
|`sound/pattern` |sound, or pattern name|                            |
|`[loop]`        |boolean               |                            |
|`[targetGain]`  |number                |                            |
|`[rateOfChange]`|number                |                            |
|`[pitch]`       |number                |                            |
|`[duckerName]`  |string                |                            |
|`[duckPriority]`|number                |                            |

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