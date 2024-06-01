# Runtime Setup Functions

&nbsp;

!> Vinyl is inteded to be used with the [configuration JSON](https://www.jujuadams.com/Vinyl/#/6.0/Config-JSON) rather than the functions on this page which interact with Vinyl's configuration at runtime. You may wish to use these functions for compatibility with another system, to support audio modding for your game, or simply because you prefer to use functions.

&nbsp;

## `VinylSetupSound`

`VinylSetupSound(sound, [gain=1], [pitch=1], [loop], [mix=VINYL_DEFAULT_MIX], [duckerName], [duckPriority=0], [metadata])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                                  |
|----------------|--------|-------------------------------------------------------------------------|
|`sound`         |sound   |Sound asset to target                                                    |
|`[gain]`        |number  |Optional, defaults to 1. Gain for the sound                              |
|`[pitch]`       |number  |Optional, defaults to 1. Pitch multiplier for the sound                  |
|`[loop]`        |boolean |Optional. Whether the sound loops                                        |
|`[mix]`         |string  |Optional, defaults to `VINYL_DEFAULT_MIX`. Which mix to play the sound on|
|`[duckerName]`  |string  |Optional. Which ducker to play the sound on                              |
|`[duckPriority]`|number  |Optional, defaults to 0. What ducker priority to play the sound with     |
|`[metadata]`    |any     |Optional. Metadata to attach to the sound                                |

Sets up a sound asset for playback with Vinyl. This is an optional function and any sound asset without a Vinyl definition will be played at a gain of 1, without any pitch shifting, and on the default mix.

!> You should typically only call this function once on boot or if you're reloading configuration data due to the presence of mods. Subsequent calls to this function will only affect audio that is already playing if `VINYL_LIVE_EDIT` is set to `true`, and even then calls to this function whilst audio is playing is expensive.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupShuffle`

`VinylSetupShuffle(patternName, soundArray, [gain=1], [pitch=1], [loop], [mix=VINYL_DEFAULT_MIX], [duckerName], [duckPriority=0], [metadata])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype       |Purpose                                                                                                                   |
|----------------|---------------|--------------------------------------------------------------------------------------------------------------------------|
|`patternName`   |string         |Name of the pattern                                                                                                       |
|`soundArray`    |array of sounds|Array of sounds to choose from when playing this pattern                                                                  |
|`[gain]`        |number         |Optional, defaults to 1. Gain for sound. You may also specify a two-element array to randomize playback gain              |
|`[pitch]`       |number         |Optional, defaults to 1. Pitch multiplier for sound. You may also specify a two-element array to randomize playback pitch |
|`[loop]`        |boolean        |Optional. Whether audio played by this pattern loops                                                                      |
|`[mix]`         |string         |Optional, defaults to `VINYL_DEFAULT_MIX`. Which mix to play sounds on                                                    |
|`[duckerName]`  |string         |Optional. Which ducker to play sounds on                                                                                  |
|`[duckPriority]`|number         |Optional, defaults to 0. What ducker priority to play sounds with                                                         |
|`[metadata]`    |any            |Optional. Metadata to attach to the pattern                                                                               |

Sets up a shuffle pattern for playback with Vinyl. When played, a shuffle pattern will randomly choose a sound from an array of sounds when played.

!> You should typically only call this function once on boot or if you're reloading configuration data due to the presence of mods. Subsequent calls to this function will only affect audio that is already playing if `VINYL_LIVE_EDIT` is set to `true`, and even then calls to this function whilst audio is playing is expensive.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupBlend`

`VinylSetupBlend(patternName, soundArray, [loop], [gain=1], [animCurve], [mix=VINYL_DEFAULT_MIX], [duckerName], [duckPriority=0], [metadata])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype       |Purpose                                                                                            |
|----------------|---------------|---------------------------------------------------------------------------------------------------|
|`patternName`   |string         |Name of the pattern                                                                                |
|`soundArray`    |array of sounds|Array of sounds to play together when playing this pattern                                         |
|`[loop]`        |boolean        |Optional. Whether audio played by this pattern loops                                               |
|`[gain]`        |number         |Optional, defaults to 1. Gain for sounds played by this pattern                                    |
|`[animCurve]`   |animation curve|Optional. What animation curve to use to determine relative gains for sounds played by this pattern|
|`[mix]`         |string         |Optional, defaults to `VINYL_DEFAULT_MIX`. Which mix to play sounds on                             |
|`[duckerName]`  |string         |Optional. Which ducker to play sounds on                                                           |
|`[duckPriority]`|number         |Optional, defaults to 0. What ducker priority to play sounds with                                  |
|`[metadata]`    |any            |Optional. Metadata to attach to the pattern                                                        |

Sets up a blend pattern for playback with Vinyl. When played, a blend pattern will play multiple sounds whose balance can be adjusted by setting the blend factor with the `VinylSetBlendFactor()` and `VinylSetBlendAnimCurve()` functions.

!> You should typically only call this function once on boot or if you're reloading configuration data due to the presence of mods. Subsequent calls to this function will only affect audio that is already playing if `VINYL_LIVE_EDIT` is set to `true`, and even then calls to this function whilst audio is playing is expensive.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupHLT`

`VinylSetupHLT(patternName, [soundHead], soundLoop, [soundTail], [gain=1], [mix=VINYL_DEFAULT_MIX], [duckerName], [duckPriority=0], [metadata])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                               |
|----------------|--------|----------------------------------------------------------------------|
|`patternName`   |string  |Name of the pattern                                                   |
|`[soundHead]`   |sound   |Optional. Sound to play first                                         |
|`soundLoop`     |sound   |Sound to loop on                                                      |
|`[soundTail]`   |sound   |Optional. Sound to play last                                          |
|`[mix]`         |string  |Optional, defaults to `VINYL_DEFAULT_MIX`. Which mix to play sounds on|
|`[duckerName]`  |string  |Optional. Which ducker to play sounds on                              |
|`[duckPriority]`|number  |Optional, defaults to 0. What ducker priority to play sounds with     |
|`[metadata]`    |any     |Optional. Metadata to attach to the pattern                           |

Sets up a head-loop-tail pattern for playback with Vinyl. When played, an HLT pattern will first play the "head" sound. Once that sound has finished, the loop sound will be played. If VinylSetLoop() is called on the HLT voice to stop looping then the tail sound will be played after the loop sound has finished.

!> You should typically only call this function once on boot or if you're reloading configuration data due to the presence of mods. Subsequent calls to this function will only affect audio that is already playing if `VINYL_LIVE_EDIT` is set to `true`, and even then calls to this function whilst audio is playing is expensive.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupMix`

`VinylSetupMix(mixName, [baseGain=1], [membersLoop], [membersDuckOn], [metadata])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name             |Datatype|Purpose                                                         |
|-----------------|--------|----------------------------------------------------------------|
|`mixName`        |string  |Name of the mix                                                 |
|`[baseGain]`     |number  |Optional, defaults to 1. Base gain for the mix                  |
|`[membersLoop]`  |boolean |Optional. Whether members played on this mix default to looping |
|`[membersDuckOn]`|string  |Optional. Which ducker to use by default for members of this mix|
|`[metadata]`     |any     |Optional. Metadata to attach to the mix                         |

Sets up a mix that can be used to control multiple sounds, patterns, and voices all at the same time. Mixes should be defined before sounds and patterns.

!> You should typically only call this function once on boot or if you're reloading configuration data due to the presence of mods. Subsequent calls to this function will only affect audio that is already playing if `VINYL_LIVE_EDIT` is set to `true`, and even then calls to this function whilst audio is playing is expensive.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupDucker`

`VinylSetupDucker(duckerName, [duckedGain=0], [rateOfChange=1])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                 |
|----------------|--------|--------------------------------------------------------------------------------------------------------|
|`duckerName`    |string  |Name of the ducker                                                                                      |
|`[duckedGain]`  |number  |Optional, defaults to 0. Gain to set for ducked sounds                                                  |
|`[rateOfChange]`|number  |Optional, defaults to 1. Rate of change in gain when ducking a sound, measured in gains units per second|

Sets up a ducker that can be used to control dynamically control the gain of sounds depending on their priority relative to the currently playing sound:

- Incoming audio with a lower priority will have its gain reduced
- Incoming audio with the same priority will fade out the old audio and replace it
- Incoming audio with a higher priority will reduce the gain of the old audio

When a sound stops playing, sounds with a lower priority (if any exist) will have their gain increased.

!> You should typically only call this function once on boot or if you're reloading configuration data due to the presence of mods. Subsequent calls to this function will only affect audio that is already playing if `VINYL_LIVE_EDIT` is set to `true`, and even then calls to this function whilst audio is playing is expensive.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupGlobalMetadata`

`VinylSetupGlobalMetadata(metadataName, data)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name          |Datatype|Purpose                                        |
|--------------|--------|-----------------------------------------------|
|`metadataName`|string  |Name for the piece of global metadata being set|
|`data`        |any     |Metaata to set, typically JSON                 |

Sets a global metadata value inside Vinyl. This value isn't used by Vinyl but can be helpful to add extra rules or behaviours to audio playback.

?> Global metadata can be retrieved by calling the `VinylGetGlobalMetadata()` function.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetMixForAssets`

`VinylSetMixForAssets(mixName, sound/pattern/array, ...)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name                 |Datatype                     |Purpose                  |
|---------------------|-----------------------------|-------------------------|
|`mixName`            |string                       |                         |
|`sound/pattern/array`|sound, pattern name, or array|                         |
|`...`                |sound, pattern name, or array|                         |

Sets the mix for multiple sounds and patterns. This function can take multiple arguments and/or arguments can specify an array of sounds and patterns to set a mix for.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetMixForAssetTag`

`VinylSetMixForAssetTag(mixName, assetTag)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                  |
|----------|--------|-------------------------|
|`mixName` |string  |                         |
|`assetTag`|string  |                         |

Sets the mix for every sound asset with the given asset tag.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupImportJSON`

`VinylSetupImportJSON(json, [replace=true])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name       |Datatype         |Purpose                                                                                  |
|-----------|-----------------|-----------------------------------------------------------------------------------------|
|`json`     |JSON struct/array|JSON to import                                                                           |
|`[replace]`|boolean          |Optional, defaults to `true`. Whether to replace the existing configuration or augment it|

Imports a JSON that contains definitions for mixes, sounds, and patterns. This is sometimes more convenient than writing lines of code.

?> You can read more about [configuration JSON here](https://www.jujuadams.com/Vinyl/#/6.0/Config-JSON).

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetupExportJSON`

`VinylSetupExportJSON([ignoreEmpty=true])`

<!-- tabs:start -->

#### **Description**

*Returns:* JSON

|Name           |Datatype|Purpose                  |
|---------------|--------|-------------------------|
|`[ignoreEmpty]`|boolean |                         |

Exports the current Vinyl setup as JSON. The root node of this JSON is always an array. JSON can be used to communicate the Vinyl setup to other tools or can be saved to disk for reference later.

?> You can read more about [configuration JSON here](https://www.jujuadams.com/Vinyl/#/6.0/Config-JSON).

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->