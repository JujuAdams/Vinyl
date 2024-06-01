# Stopping Audio

&nbsp;

## `VinylStop`

`VinylStop(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Immediately stops playback of a voice.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylStopAll`

`VinylStopAll()`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|N/A    |        |                            |

Convenience function to stop all audio currently playing.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylFadeOut`

`VinylFadeOut(voice, [rateOfChange])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                   |
|----------------|--------|------------------------------------------------------------------------------------------|
|`voice`         |voice   |Voice to target                                                                           |
|`[rateOfChange]`|number  |Optional, defaults to 1. How fast to fade out the voice, measured in gain units per second|

Fades out out a voice. Once a voice is set to fade out, it cannot be stopped.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylCallbackOnStop`

`VinylCallbackOnStop(voice, callback, [metadata])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name        |Datatype|Purpose                                                              |
|------------|--------|---------------------------------------------------------------------|
|`voice`     |voice   |Voice to target                                                      |
|`callback`  |method  |Method to call when the target voice is stopped                      |
|`[metadata]`|any     |Optional. Data to pass into the first argument of the callback method|

Adds a callback to a voice such that when the voice is stopped (or faded out) then the callback is executed. You can optionally provide some metadata - this is passed into the method as the first argument. If no metadata is provided then `undefined` is passed to the function. Calling this function twice will replace the old callback with the new one. You can detach a callback from a voice by using `undefined` as the method.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylWillStop`

`VinylWillStop(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns whether the target voice will stop playing imminently. The tolerance for this test is set by the `VINYL_WILL_STOP_TOLERANCE` macro (see `__VinylConfigMacros()`).

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->