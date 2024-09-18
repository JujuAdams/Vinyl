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