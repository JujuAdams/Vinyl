# Multi Patterns

&nbsp;

Functions on this page relate to specific behaviours for [Multi pattern](Terminology) voices.

&nbsp;

## Configuration Properties

|Property        |Datatype        |Default                                     |Notes                                                                                                                        |
|----------------|----------------|--------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |*passthrough*                               |**Required.** Must be one of the following: `basic` `shuffle` `queue` `multi`                                                |
|`asset`         |string or struct|*passthrough*                               |**Required.** Can be asset name, a pattern name, or a pattern struct. Must be an array for shuffle, queue, and multi patterns|
|`gain`          |number          |`1`                                         |Defaults to `0` db in [decibel mode](Config-Macros)                                                                          |
|`pitch`         |number or array |`1`                                         |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)                  |
|`transpose`     |number          |*passthrough*                               |                                                                                                                             |
|`loop`          |boolean         |*passthrough*                               |                                                                                                                             |
|`loop points`   |array of numbers|*passthrough*                               |Must be a two-element array defining the start and end point of a loop, measured in seconds                                  |
|`stack`         |string          |*passthrough*                               |                                                                                                                             |
|`stack priority`|number          |`0`                                         |                                                                                                                             |
|`effect chain`  |string          |*passthrough*                               |                                                                                                                             |
|`label`         |string or array |*passthrough*                               |Label to assign this pattern to. Can be a string for for label, or an array of label names                                   |
|`persistent`    |boolean         |*passthrough*                               |                                                                                                                             |
|`sync`          |boolean         |[`VINYL_DEFAULT_MULTI_SYNC`](Config-Macros) |                                                                                                                             |
|`blend`         |number          |[`VINYL_DEFAULT_MULTI_BLEND`](Config-Macros)|This is a normalised value from `0` to `1` (inclusive)                                                                       |
|`blend curve`   |string          |`undefined`                                 |If not defined, linear crossfades are used                                                                                   |

&nbsp;

## `VinylMultiVoiceCountGet`

`VinylMultiVoiceCountGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the number of voices created as children for the specified [Multi pattern voice](Terminology)

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