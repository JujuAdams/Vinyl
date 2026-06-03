# BPM Functions

&nbsp;

## `…AttachBeatTracker`

`VinylAttachBeatTracker(voice, [beginOnBeat=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name           |Datatype|Purpose                                                                                                                 |
|---------------|--------|------------------------------------------------------------------------------------------------------------------------|
|`voice`        |voice   |Vinyl voice to target                                                                                                   |
|`[beginOnBeat]`|boolean |WHETHER `VinylGetBeatThisStep()` should return `true` on the same Step that this function is called. Defaults to `false`|

Attaches a BPM tracker to a Vinyl voice. This is not strictly necessary because beat tracker functions will attach a tracker to a voice if one hasn't already been attached, but calling `VinylAttachBeatTracker()` can help with some edge cases. This function should be called immediately after playing some audio. If you set the optional `beginOnBeat` parameter to `true` then `VinylGetBeatThisStep()` will return `true` on the same Step that this function is called.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `…GetBPM`

`VinylGetBPM(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name   |Datatype|Purpose              |
|-------|--------|---------------------|
|`voice`|voice   |Vinyl voice to target|

Returns the BPM for a voice.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `…GetBeatThisStep`

`VinylGetBeatThisStep(voice, [realtime=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean

|Name   |Datatype|Purpose              |
|-------|--------|---------------------|
|`voice`|voice   |Vinyl voice to target|

Returns whether a beat happened this Step for a playing voice.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `…GetBeatCount`

`VinylGetBeatCount(voice, \[beginOnBeat=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name   |Datatype|Purpose              |
|-------|--------|---------------------|
|`voice`|voice   |Vinyl voice to target|

Returns what number beat you're on in the track.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `…GetBeatDistance`

`VinylGetBeatDistance(voice, [realtime=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name        |Datatype|Purpose                                                                                                    |
|------------|--------|-----------------------------------------------------------------------------------------------------------|
|`voice`     |voice   |Vinyl voice to target                                                                                      |
|`[realtime]`|boolean |Whether the returned value should be in seconds (`true`) or as a proportion of the length of a beat `false`|

Returns how far from the nearest beat the track position is (in seconds). This value will be positive if the next beat is in the future and negative if the nearest beat is in the past. If you set the optional `runtime` parameter to `false` then the value returned will be from `-0.5` to `0.5`. This function will return a value close to `0` when the current Step is "on the beat" but this behaviour is not exact and you should use `VinylGetBeatThisStep()` for this purpose.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->