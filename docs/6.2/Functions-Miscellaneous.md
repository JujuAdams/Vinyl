# Miscellaneous Functions

&nbsp;

## `VinylGetAsset`

`VinylGetAsset(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Sound asset, the sound asset being played by the voice

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns the sound asset that is currently being played by the target voice. If a blend voice is targeted then this function will return an array of sound assets; otherwise, this function will return a sound asset. If the voice is invalid then this function will return `undefined`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetGMVoice`

`VinylGetGMVoice(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice index, the native GameMaker voice that the Vinyl voice is currently playing

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns the native GameMaker voice index that is currently being played by the target Vinyl voice. If a blend voice is targeted then this function will return an array of GameMaker voice indexes; otherwise, this function will return a GameMaker voice index. If the voice is invalid then this function will return `undefined`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetLength`

`VinylGetLength(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the length of the sound being played by the voice in seconds

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns the length of a sound asset that is currently being played by the target voice. If a blend voice is targeted then this function will return the length of the first (0th index) sound. If the voice is invalid then this function will return `0`. Setting the optional `adjustForPitch` parameter to `true` will correct the returned value for the current pitch of the voice (a higher pitch will reduce the playback time).

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

## `VinylGetFinalPitch`

`VinylGetFinalPitch(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns the final output pitch for a voice. If the voice doesn't exist then this function will return `1`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylPatternExists`

`VinylPatternExists(sound/pattern, [explicit=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether the sound asset or pattern exists

|Name           |Datatype     |Purpose                                                                                 |
|---------------|-------------|----------------------------------------------------------------------------------------|
|`sound/pattern`|sound/pattern|Sound asset or pattern to target                                                        |
|`[explicit]`   |boolean      |Whether sound assets require an explicit pattern definition to be considering "existing"|

Returns whether a pattern exists i.e. has been defined by a `VinylSetup*()` function (including JSON variants). If the `explicit` parameter is set to `false` (the default) then this function will always return `true` if a sound asset is passed as the parameter for this function regardless of whether a pattern has explicitly been created for the sound asset or not.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylPatternIsPlaying`

`VinylPatternIsPlaying(sound/pattern)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether the sound asset or pattern exists

|Name           |Datatype     |Purpose                         |
|---------------|-------------|--------------------------------|
|`sound/pattern`|sound/pattern|Sound asset or pattern to target|

Returns whether any voice exists that is playing the given sound, or playing any sound from a pattern. If a pattern contains multiple sounds then this function will return `true` if a voice exists that is playing any of those sounds.

!> This function will always return `false` if an abstract pattern is targeted.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

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