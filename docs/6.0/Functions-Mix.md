# Mix Functions

&nbsp;

## `VinylMixVoicesStop`

`VinylMixVoicesStop(mixName)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                     |
|---------|--------|----------------------------|
|`mixName`|string  |Name of the mix to target   |

Immediately stops all voices currently playing in a given mix.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMixVoicesSetPause`

`VinylMixVoicesPause(mixName, state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                           |
|---------|--------|----------------------------------|
|`mixName`|string  |Name of the mix to target         |
|`state`  |boolean |Whether to pause or unpause voices|

Pauses or unpauses all voices currently playing in a given mix. These voices can be individually resumed using `VinylSetPause()` or can be resumed all together by calling `VinylMixVoicesSetPause()` again.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMixVoicesFadeOut`

`VinylMixVoicesFadeOut(mixName, [rateOfChange])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                            |
|----------------|--------|-------------------------------------------------------------------------------------------------------------------|
|`mixName`       |string  |Name of the mix to target                                                                                          |
|`[rateOfChange]`|number  |Optional, defaults to `VINYL_DEFAULT_FADE_OUT_RATE`. How fast to reach zero gain, measured in gain units per second|

Fades out all voices currently playing in a given mix. Once a voice is set to fade out, it cannot be stopped. The rate of change for this function is measured in "gain units per second".

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMixSetGain`

`VinylMixSetGain(mixName, gain, [rateOfChange])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)
           
|Name            |Datatype|Purpose                                                                                            |
|----------------|--------|---------------------------------------------------------------------------------------------------|
|`mixName`       |string  |Name of the mix to target                                                                          |
|`gain`          |number  |Target gain                                                                                        |
|`[rateOfChange]`|number  |Optional, defaults to instant. How fast to reach the target gain, measured in gain units per second|

Sets the local gain for the mix. This is multipled with the base gain (see `VinylSetupMix()`) to give a gain factor applied to all audio played on this mix. Setting the local gain for a mix will affect all current and future audio played on the mix. The rate of change for this function is measured in "gain units per second".

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMixGetGain`

`VinylMixGetGain(mixName)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name     |Datatype|Purpose                     |
|---------|--------|----------------------------|
|`mixName`|string  |Name of the mix to target   |

Returns the local gain for the mix.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMixGetMetadata`

`VinylMixGetMetadata(mixName, [default])`

<!-- tabs:start -->

#### **Description**

*Returns:* Any

|Name       |Datatype|Purpose                                                                                |
|-----------|--------|---------------------------------------------------------------------------------------|
|`mixName`  |string  |Name of the mix to target                                                              |
|`[default]`|any     |Optional, defaults to `undefined`. Fallback value to return if no metadata can be found|

Returns the metadata associated with a mix, as set up by Vinyl's config JSON or a call to `VinylSetupMix()`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMixGetVoiceCount`

`VinylMixGetVoiceCount(mixName, [moreAccurate=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name            |Datatype|Purpose                                                                                           |
|----------------|--------|--------------------------------------------------------------------------------------------------|
|`mixName`       |string  |Name of the mix to target                                                                         |
|`[moreAccurate]`|boolean |Optional, defaults to `false`. Whether to obtain the accurate voice count at a performance penalty|

Returns the number of voices currently playing on a mix. This function relies on the internal voice counter for the mix. This counter updates slowly and can sometimes be inaccurate. If you need very accurate voice counts then set the "moreAccurate" argument to `true`, though this does carry a performance penalty.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->