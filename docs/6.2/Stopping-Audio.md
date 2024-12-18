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

`VinylFadeOut(voice, [rateOfChange], [pause=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                     |
|----------------|--------|--------------------------------------------------------------------------------------------|
|`voice`         |voice   |Voice to target                                                                             |
|`[rateOfChange]`|number  |Optional, defaults to `1`. How fast to fade out the voice, measured in gain units per second|
|`[pause]`       |boolean |Optional, defaults to `false`. Whether the voice should pause when faded out                |

Fades out out a voice. Once a voice is set to fade out, it cannot be stopped. The rate of change for this function is measured in "gain units per second". If the optional `pause` parameter is set to `false` (the default) then the voice will stop once faded out. If the `pause` parameter is set to `true` then the voice will be paused instead and can be unpaused using the `VinylSetPause()` function. When resuming playback of the voice, it will *not* fade in.

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

*Returns:* Boolean, whether the target voice will stop playing imminently

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns whether the target voice will stop playing imminently. The tolerance for this test is set by the `VINYL_WILL_STOP_TOLERANCE` macro (see `__VinylConfigMacros()`). If a voice is paused then this function will return `false`. If a voice has already been stopped, this function will return `true`. A looping voice will return `false` (this includes queues that are set to loop).

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->