# Pitch Functions

&nbsp;

## `VinylSetPitch`

`VinylSetPitch(voice, pitch, [rateOfChange])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                                |
|----------------|--------|-----------------------------------------------------------------------|
|`voice`         |voice   |Voice to target                                                        |
|`pitch`         |number  |Pitch target to set                                                    |
|`[rateOfChange]`|number  |Optional, defaults to instant. Rate of change to reach the pitch target|

Sets the local pitch for a voice. This is multipled with the sound/pattern pitch set by the corresponding setup function and the mix pitch (if a mix is set for the voice) to give the final playback pitch for the voice. The rate of change for this function is measured in "pitch units per second".

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetPitch`

`VinylGetPitch(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns the local pitch for a voice.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->