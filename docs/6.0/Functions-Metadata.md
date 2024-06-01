# Metadata Functions

&nbsp;

## `VinylGetMetadata`

`VinylGetMetadata(sound/pattern, [default])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name           |Datatype              |Purpose                                                                                |
|---------------|----------------------|---------------------------------------------------------------------------------------|
|`sound/pattern`|sound, or pattern name|Sound or pattern to target                                                             |
|`[default]`    |any                   |Optional, defaults to `undefined`. Fallback value to return if no metadata can be found|

Returns the metadata associated with the sound or pattern, as set up by Vinyl's config JSON or a call to `VinylSetup*()`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetGlobalMetadata`

`VinylGetGlobalMetadata(metadataName, [default])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name          |Datatype|Purpose                                                                                |
|--------------|--------|---------------------------------------------------------------------------------------|
|`metadataName`|string  |Name of the global metadata to retrieve                                                |
|`[default]`   |any     |Optional, defaults to `undefined`. Fallback value to return if no metadata can be found|

Returns the metadata with the given name, as set by `VinylSetupGlobalMetadata()`. If that metadata is missing then the default value is returned.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->