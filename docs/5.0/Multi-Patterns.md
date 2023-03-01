# Multi Patterns

&nbsp;

Functions on this page relate to specific behaviours for [Multi pattern](Terminology) instances.

&nbsp;

## `VinylMultiChannelCountGet`

`VinylMultiChannelCountGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the number of channels for the [Multi pattern voice](Terminology)

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

|Name    |Datatype      |Purpose                                                                                                                                                                               |
|--------|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                                                                                                                          |
|`index` |number        |Channel to target                                                                                                                                                                     |
|`gain`  |number        |Voice gain to set, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|

Sets the gain of an individual channel of a [Multi pattern voice](Terminology). Gain set by this function will be overwritten by `VinylMultiBlendSet()`.

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

*Returns:* Number, the gain for the channel of a [Multi pattern voice](Terminology)

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

Sets the blending factor, mixing between different assets playing on a [Multi pattern voice](Terminology). The blending factor is a normalised value between `0` and `1`.

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

*Returns:* Number, the blend factor for the [Multi pattern voice](Terminology)

|Name    |Datatype|Purpose                         |
|--------|--------|--------------------------------|
|`target`|voice   |The Multi pattern voic to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylMultiSyncSet`

`VinylMultiSyncSet(target, state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                        |
|--------|--------------|-------------------------------|
|`target`|voice or label|The voice or label to target   |
|`state` |boolean       |Whether to synchronise playback|

?> [Multi pattern](Terminology) synchronisation is not absolutely precise and may wander a little.

!> Make sure that all sound assets played on a synchronised Multi pattern are the same length or you may encounter unexpected behaviour.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylMultiSyncGet`

`VinylMultiSyncGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether the [Multi pattern voice](Terminology) is set to synchronise playback

|Name    |Datatype|Purpose                          |
|--------|--------|---------------------------------|
|`target`|voice   |The Multi pattern voice to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->