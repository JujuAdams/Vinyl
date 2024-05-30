# Runtime Setup Functions

&nbsp;

## `VinylSetupSound`

`VinylSetupSound(voice, [gain=1], [pitch=1], [loop], [mix=VINYL_DEFAULT_MIX], [duckerName], [duckPriority=0], [metadata])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype|Purpose                  |
|----------------|--------|-------------------------|
|`voice`         |voice   |                         |
|`[gain]`        |number  |                         |
|`[pitch]`       |number  |                         |
|`[loop]`        |boolean |                         |
|`[mix]`         |string  |                         |
|`[duckerName]`  |string  |                         |
|`[duckPriority]`|number  |                         |
|`[metadata]`    |any     |                         |

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

|Name            |Datatype       |Purpose                  |
|----------------|---------------|-------------------------|
|`patternName`   |string         |                         |
|`soundArray`    |array of sounds|                         |
|`[gain]`        |number         |                         |
|`[pitch]`       |number         |                         |
|`[loop]`        |boolean        |                         |
|`[mix]`         |string         |                         |
|`[duckerName]`  |string         |                         |
|`[duckPriority]`|number         |                         |
|`[metadata]`    |any            |                         |

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

|Name            |Datatype       |Purpose                  |
|----------------|---------------|-------------------------|
|`patternName`   |string         |                         |
|`soundArray`    |array of sounds|                         |
|`[loop]`        |boolean        |                         |
|`[gain]`        |number         |                         |
|`[animCurve]`   |animation curve|                         |
|`[mix]`         |string         |                         |
|`[duckerName]`  |string         |                         |
|`[duckPriority]`|number         |                         |
|`[metadata]`    |any            |                         |

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

|Name            |Datatype|Purpose                  |
|----------------|--------|-------------------------|
|`patternName`   |string  |                         |
|`[soundHead]`   |sound   |                         |
|`soundLoop`     |sound   |                         |
|`[soundTail]`   |sound   |                         |
|`[mix]`         |string  |                         |
|`[duckerName]`  |string  |                         |
|`[duckPriority]`|number  |                         |
|`[metadata]`    |any     |                         |

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

|Name             |Datatype|Purpose                  |
|-----------------|--------|-------------------------|
|`patternName`    |string  |                         |
|`[baseGain]`     |number  |                         |
|`[membersLoop]`  |boolean |                         |
|`[membersDuckOn]`|string  |                         |
|`[metadata]`     |any     |                         |

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

|Name            |Datatype|Purpose                  |
|----------------|--------|-------------------------|
|`duckerName`    |string  |                         |
|`[duckedGain]`  |number  |                         |
|`[rateOfChange]`|number  |                         |

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

|Name          |Datatype|Purpose                  |
|--------------|--------|-------------------------|
|`metadataName`|string  |                         |
|`data`        |any     |                         |

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

|Name       |Datatype         |Purpose                  |
|-----------|-----------------|-------------------------|
|`json`     |JSON struct/array|                         |
|`[replace]`|boolean          |                         |

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

*Returns:* N/A (`undefined`)

|Name           |Datatype|Purpose                  |
|---------------|--------|-------------------------|
|`[ignoreEmpty]`|boolean |                         |

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->