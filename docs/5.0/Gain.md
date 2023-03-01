# Gain

&nbsp;

"Gain" is, effectively, the "volume" of a sound. Where Vinyl requires a gain value to be supplied as a function argument, the gain value should from `0` to, typically, `1`.

Some professional audio designers prefer to work with decibel gain values rather than normalised gain values. By setting [`VINYL_CONFIG_DECIBEL_GAIN`](Config-Macros) to `true`, [Vinyl's configuration file](Configuration) will now use decibel values. A value of `0` db is equivalent to a normalised value of `1`, and a decibel value of `-60` db is equivalent to a normalised gain of `0` (i.e. silence).

Vinyl offers in-depth volume control through gain variables attached to multiple layers. Here's the fundamental gain equation:

```
outputGain = assetGain * (labelGain[0] * labelGain[1] * ...) * instanceGain * emitterGain

heardGain = clamp(outputGain / VINYL_MAX_GAIN, 0, 1) * systemGain
```

?> If you're a professional audio person used to working in decibels rather than normalised gain units then read multiplication `*` as addition `+`.

`outputGain` is the value returned by [`VinylOutputGainGet()`](Gain) whereas `heardGain` is the actual amplitude that is used to fill the audio buffer. Vinyl separates these two concepts so that the `outputGain` can be any value you like and is only constrained at the very last point in the signal chain.

&nbsp;

### Asset Gain

Set in the [configuration file](Configuration) per asset (or pattern).

### Label Gain

Set in the [configuration file](Configuration), and additionally altered by `VinylGainSet()` and `VinylTargetGainSet()` (when targeting a label).

### Instance Gain

Set on creation (by `VinylPlay()` etc.) and additionally altered by [`VinylGainSet()` and `VinylTargetGainSet()`](Gain). This gain is further altered by [`VinylFadeOut()`](Basics).

### Emitter Gain

Implicitly set by calculating the distance from the listener to the emitter that a Vinyl instance is playing on. Only Vinyl instances created by [`VinylPlayOnEmitter()`](Positional) will factor in emitter gain, otherwise this gain is ignored.

### `VINYL_MAX_GAIN`

A [configuration macro](Config-Macros) found in `__VinylConfigMacros`. This value can be from zero to any number.

### System Gain

Set by `VinylSystemGainSet()`. This gain should be above zero but can otherwise be any number, including greater than `1`.

&nbsp;

# Functions

## `VinylGainSet`

`VinylGainSet(id, gain)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name  |Datatype      |Purpose                                                                                                                                                                                  |
|------|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`id`  |Vinyl instance|Instance to target                                                                                                                                                                       |
|`gain`|number        |Instance gain to set, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|

Sets the gain of [Vinyl instance](Terminology) or [Vinyl label](Terminology).

If an instance is specified, the instance gain is set. This gain is independent of, for example, label gain, asset gain, and system gain.

If a label is specified, the gain for the label is set. This will immediately impact all current instances assigned to that label, and will impact future instances too.

&nbsp;

## `VinylGainGet`

`VinylGainGet(id)`

&nbsp;

*Returns:* Number, the gain for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylGainTargetSet`

`VinylGainTargetSet(id, gain, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name    |Datatype        |Purpose                                                                                           |
|--------|----------------|--------------------------------------------------------------------------------------------------|
|`sound` |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                    |
|`[gain]`|number          |Target gain, in normalised gain units                                                             |
|`[rate]`|number          |Speed to approach the target gain, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Sets the target gain of [Vinyl instance](Terminology) or [Vinyl label](Terminology). The gain for that instance or label will change over time at the given rate until reaching its target.

!> Setting a target gain of `0` for an instance will not stop the instance when reaching silence. Please use `VinylFadeOut()` to fade out and stop an instance.

&nbsp;

## `VinylGainTargetGet`

`VinylGainTargetGet(id)`

&nbsp;

*Returns:* Number, the target gain for the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylOutputGainGet`

`VinylOutputGainGet(id)`

&nbsp;

*Returns:* Number, the final output gain of the [Vinyl instance](Terminology) or [Vinyl label](Terminology)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

You can read more about how the output gain of an instance is calculated [here](Gain-Structure).