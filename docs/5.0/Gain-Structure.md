# Gain Structure

Vinyl offers in-depth volume control through gain variables attached to multiple layers. Understanding exactly how this all fits together can be daunting and this page seeks to explain how it works.

Here's the fundamental gain equation:

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