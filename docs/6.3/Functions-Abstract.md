# Abstract Functions

&nbsp;

## `VinylAbstract`

`VinylAbstract([gain=1], [pitch=1], [duckerName], [duckPriority=0])`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, a handle that can be used to reference the container

|Name            |Datatype|Purpose                             |
|----------------|--------|------------------------------------|
|`[gain=1]`      |number  |Starting gain for the voice         |
|`[pitch=1]`     |number  |Starting pitch for the voice        |
|`[duckerName]`  |string  |Ducker to use for the voice         |
|`[duckPriority]`|number  |Ducker priority to use for the voice|
|`[mixName]`     |number  |Mix to play the voice on            |

Creates an abstract Vinyl voice and returns its index. Abstract voices do not inherently play any audio but can be controlled as though they were standard voices. Abstract voices are helpful for creating custom audio behaviors that Vinyl doesn't natively support whilst also allowing Vinyl to control their gain and pitch.

Abstract voices are always considered looping and `VinylSetLoop()` will not set state on an abstract voice. `VinylGetLoop()` will always return `true`. You may use `VinylGetFinalGain()` and `VinylGetFinalPitch()` to get final output values for the voice.

Whilst `VinylAbstract()` is good for one-off abstract voices, you may find that you'd like to create abstract voices with similar properties. Please see `VinylSetupAbstract()` for more information.

!> Abstract voices have no "duration" and won't stop playing by themselves. You must call `VinylStop()` on the voice when you're done with the abstract voice or else you will create a memory leak. You may also use `VinylAbstractStopAll()` to stop all current abstract voices.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylAbstractStopAll`

`VinylAbstractStopAll()`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|N/A    |        |                            |

Stops all abstract voices, freeing up memory associated with them.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->