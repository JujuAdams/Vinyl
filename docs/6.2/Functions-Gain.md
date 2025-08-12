# Gain Functions

&nbsp;

## `VinylSetGain`

`VinylSetGain(voice, gain, [rateOfChange])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                               |
|----------------|--------|----------------------------------------------------------------------|
|`voice`         |voice   |Voice to target                                                       |
|`gain`          |number  |Gain target to set                                                    |
|`[rateOfChange]`|number  |Optional, defaults to instant. Rate of change to reach the gain target|

Sets the local gain for a voice. This is multipled with the sound/pattern gain set by the corresponding setup function, the mix gain (if a mix is set for the voice), and the fade-out gain to give the final playback gain for the voice. The rate of change for this function is measured in "gain units per second".

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetGain`

`VinylGetGain(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns the local gain for a voice.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetFinalGain`

`VinylGetGain(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns the final output gain for a voice. This value will include the correction made for `VINYL_MAX_VOICE_GAIN`. For example, if you set the maximum voice gain to `2` then the final gain for voices will be halved to accommodate the greater gain range. If the voice doesn't exist, this function will return `0`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMasterSetGain`

`VinylMasterSetGain(gain)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name  |Datatype|Purpose                     |
|------|--------|----------------------------|
|`gain`|number  |Gain to set                 |

Sets the master (global) gain for all audio, including audio not played with Vinyl.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylMasterGetGain`

`VinylMasterGetGain()`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|N/A    |        |                            |

Returns the master (global) gain for Vinyl.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->