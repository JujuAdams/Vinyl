# Multi Patterns

&nbsp;

## `VinylMultiVoiceCountGet`

`VinylMultiVoiceCountGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the number of voices created as children for the specified Multi pattern voice

|Name    |Datatype|Purpose                          |
|--------|--------|---------------------------------|
|`target`|voice   |The Multi pattern voice to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylMultiGainSet`

`VinylMultiGainSet(target, index, gain)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                                                                                                                     |
|--------|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                                                                                                                |
|`index` |number        |Channel to target                                                                                                                                                           |
|`gain`  |number        |Voice gain to set, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain)|

Sets the gain of an individual channel of a Multi pattern voice. Gain set by this function will be overwritten by `VinylMultiBlendSet()`.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylMultiGainGet`

`VinylMultiGainGet(target, index)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the gain for the channel of a Multi pattern voice

|Name    |Datatype|Purpose                          |
|--------|--------|---------------------------------|
|`target`|voice   |The Multi pattern voice to target|
|`index` |number  |Channel to target                |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylMultiBlendSet`

`VinylMultiBlendSet(target, blendFactor)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name         |Datatype      |Purpose                       |
|-------------|--------------|------------------------------|
|`target`     |voice or label|The voice or label to target  |
|`blendFactor`|number        |Blend factor to set, see below|

Sets the blending factor, mixing between different assets playing on a Multi pattern voice. The blending factor is a normalised value between `0` and `1`.

Gain set by this function will be overwritten by `VinylMultiGainSet()`.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylMultiBlendGet`

`VinylMultiBlendGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the blend factor for the Multi pattern voice

|Name    |Datatype|Purpose                         |
|--------|--------|--------------------------------|
|`target`|voice   |The Multi pattern voic to target|

#### **Example**

```gml
//TODO lol
```

&nbsp;

## `VinylMultiSyncGet`

`VinylMultiSyncGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether the Multi pattern voice is set to synchronise playback

|Name    |Datatype|Purpose                          |
|--------|--------|---------------------------------|
|`target`|voice   |The Multi pattern voice to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->