# Gain Functions

&nbsp;

## `VinylGainSet`

`VinylGainSet(target, gain)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                                                                                                             |
|--------|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                                                                                                        |
|`gain`  |number        |Voice gain to set, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other sources of gain|

Sets the gain of a [voice](Voice) or [label](Label).

If a voice is specified, the voice gain is set. This gain is independent of, for example, label gain, asset gain, and system gain.

If a label is specified, the gain for the label is set. This will immediately impact all current voices assigned to that label, and will impact future voices too.

#### **Example**

```gml
//Get our music volume from the settings
var _musicGain = global.settings.musicGain;

//Make sure we're not setting a silly value
_musicGain = clamp(_musicGain, 0, 1);

//Apply the new gain to the "music" label
VinylGainSet("music", _musicGain);
```

<!-- tabs:end -->