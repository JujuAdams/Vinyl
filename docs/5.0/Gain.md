# Gain

&nbsp;

"Gain" is a value that controls the volume of a sound. A higher gain value will make a sound louder, a lower gain value will make a sound quieter. GameMaker's treats gain as a value from `0` to `1` relative to the original volume of the asset you imported. This is called "normalised gain". A gain value of `0` in GameMaker will make a sound silent; a gain value of `1` will leave a sound's volume untouched and it will play as loud as the original source file, more or less. Vinyl's audio functions copy this basic behaviour.

GameMaker's gain values don't map accurately to the perceived loudness. When using GameMaker's audio functions, you might expect a gain value of `0.5` to be half the loudness of a gain value of `1`. Sadly, this is not the case. GameMaker doesn't use a decibel loudness curve as it should and instead GameMaker's audio functions naively adjust the *amplitude* of the output audio. Gains are also clamped to a maximum value of `1` meaning that audio cannot be made louder than the source.

?> Interestingly, GameMaker allows the entire audio system gain to exceed `1` and this does indeed increase the loudness of audio playback, albeit across every sound. Vinyl leverages this behaviour to allow for maximum gain values per sound to exceed `1`.

Vinyl improves upon GameMaker's native gain implementation. Setting a gain using Vinyl to `0.5` will result in a sound half as loud as a gain of `1` by applying a curve to the amplitude of audio playback. All audio fades operate on this curve meaning that fades will sound more natural throughout. Additionally, Vinyl allows for audio to have a gain larger than `1`, up the to value set by [`VINYL_MAX_GAIN`](Config-Macros). Try not to set this value too high otherwise you may start to notice subtle distortion of your audio.

Some professional audio designers prefer to work with decibel gain values rather than normalised gain values. By setting [`VINYL_CONFIG_DECIBEL_GAIN`](Config-Macros) to `true`, [Vinyl's configuration file](Configuration) will now use decibel values. A value of `0` db is equivalent to a normalised value of `1`, and a decibel value of `-60` db is equivalent to a normalised gain of `0` (i.e. silence). At any rate, Vinyl's **GML functions** expect a normalised gain value (`0` -> `1`) regardless of what value `VINYL_CONFIG_DECIBEL_GAIN` is set to.

Vinyl offers in-depth volume control through gain variables attached to multiple layers. Here's the fundamental gain equation:

```
outputGain = assetGain * (labelGain[0] * labelGain[1] * ...) * instanceGain * emitterGain

heardGain = Clamp(ApplyDecibelCurve(outputGain) / VINYL_MAX_GAIN, 0, 1) * VINYL_MAX_GAIN * systemGain
```

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