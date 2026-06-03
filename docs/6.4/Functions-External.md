# External Audio

&nbsp;

## `VinylSetupExternal`

`VinylSetupExternal(path, [patternName=path], [gain=1], [pitch=1], [loop], [mix=VINYL_DEFAULT_MIX], [duckerName], [duckPriority=0], [emitterAlias], [metadata], [forceType])`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, a handle that can be used to reference the container

|Name            |Datatype|Purpose                                                                                        |
|----------------|--------|-----------------------------------------------------------------------------------------------|
|`path`          |string  |Path to load the audio from. This should be a WAV file or an OGG file                          |
|`[patternName]` |string  |Optional, defaults to the path. This is the name to use to refer to the pattern e.g. to play it|
|`[gain]`        |number  |Optional, defaults to 1. Gain for the sound                                                    |
|`[pitch]`       |number  |Optional, defaults to 1. Pitch multiplier for the sound                                        |
|`[loop]`        |boolean |Optional. Whether the sound loops                                                              |
|`[mix]`         |string  |Optional, defaults to `VINYL_DEFAULT_MIX`. Which mix to play the sound on                      |
|`[duckerName]`  |string  |Optional. Which ducker to play the sound on                                                    |
|`[duckPriority]`|number  |Optional, defaults to 0. What ducker priority to play the sound with                           |
|`[emitterAlias]`|string  |Optional, defaults to `undefined`. Name of a registered emitter to play the sound on by default|
|`[metadata]`    |any     |Optional. Metadata to attach to the sound                                                      |
|`[forceType]`   |any     |Optional. Filetype to force, `1` = WAV, `2` = OGG                                              |

Sets up an external sound for playback with Vinyl. External sounds may be either WAV files or OGG files. Vinyl uses its own WAV loader for the former and VInyl uses GameMaker's native OGG streaming playback for the latter (`audio_create_stream`).

> This function will reserve memory for loaded audio. Once you are done with the audio in question, you should call `VinylUnloadExternal()` to free up that memory.

It is strongly recommended that you ensure each externally loaded asset has a unique pattern name to avoid conflicts and confusion. You may, however, choose to leave the pattern name `undefined` in which case the path you gave for the sound will be used as the pattern name instead.

If the `emitterAlias` parameter is defined, Vinyl will attempt to play the sound on the specified emitter if the sound is played directly (i.e. not played via another pattern). You can register an emitter with `VinylRegisterEmitter()`.

You should typically only call this function once on boot or if you're reloading configuration data due to the presence of mods. Subsequent calls to this function will only affect audio that is already playing if VINYL_LIVE_EDIT is set to <true>, and even then calls to this function whilst audio is playing is expensive.

Vinyl may fail to detect the type of file being loaded. If you are sure the file you are trying to load is of a particular type then you may force a type to ensure Vinyl loads the file. Use a value of `1` to load a file as a WAV file or use a value of `2` to load a file as an OGG file.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylUnloadExternal`

`VinylUnloadExternal(patternName)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name         |Datatype|Purpose                                                                  |
|-------------|--------|-------------------------------------------------------------------------|
|`patternName`|string  |Name of the pattern to unload, as set when calling `VinylSetupExternal()`|

Unloads a pattern that has been added using `VinylSetupExternal()`. This frees memory associated with the audio.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->