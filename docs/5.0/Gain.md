# Gain

&nbsp;

"Gain" is a value that controls the volume of a sound. A higher gain value will make a sound louder, a lower gain value will make a sound quieter. GameMaker's treats gain as a value from `0` to `1` relative to the original volume of the asset you imported. This is called "normalised gain". A gain value of `0` in GameMaker will make a sound silent; a gain value of `1` will leave a sound's volume untouched and it will play as loud as the original source file, more or less. Vinyl's audio functions copy this basic behaviour.

GameMaker's gain values don't map accurately to the perceived loudness. When using GameMaker's audio functions, you might expect a gain value of `0.5` to be half the loudness of a gain value of `1`. Sadly, this is not the case. GameMaker doesn't use a decibel loudness curve as it should and instead GameMaker's audio functions naively adjust the *amplitude* of the output audio. Gains are also clamped to a maximum value of `1` meaning that audio cannot be made louder than the source.

?> Interestingly, GameMaker allows the entire audio system gain to exceed `1` and this does indeed increase the loudness of audio playback, albeit across every sound without fine control over what's louder and what's not. Vinyl leverages this behaviour to allow for maximum gain values per sound to exceed `1`.

Vinyl improves upon GameMaker's native gain implementation. Setting a gain using Vinyl to `0.5` will result in a sound half as loud as a gain of `1` by applying a curve to the amplitude of audio playback. All audio fades operate on this curve meaning that fades will sound more natural throughout. Additionally, Vinyl allows for audio to have a gain larger than `1`, up the to value set by [`VINYL_MAX_GAIN`](Config-Macros). Try not to set this value too high otherwise you may start to notice subtle distortion of your audio.

Some professional audio designers prefer to work with decibel gain values rather than normalised gain values. By setting [`VINYL_CONFIG_DECIBEL_GAIN`](Config-Macros) to `true`, [Vinyl's configuration file](Config-File) will now use decibel values. A value of `0` db is equivalent to a normalised value of `1`, and a decibel value of `-60` db is equivalent to a normalised gain of `0` (i.e. silence). At any rate, Vinyl's **GML functions** expect a normalised gain value (`0` -> `1`) regardless of what value `VINYL_CONFIG_DECIBEL_GAIN` is set to.

Vinyl offers in-depth volume control through gain variables at multiple stages in the signal path. Here's the fundamental gain equation for sounds:

```
output = config
         * local
         * parent
         * ducking
         * (label[0] * label[1] * ...)
         * emitter

heardAmplitude = Clamp(ApplyDecibelCurve(output) / VINYL_MAX_GAIN, 0, 1)
               * VINYL_MAX_GAIN
               * system
```

`output` is the value returned by `VinylOutputGainGet()` whereas `heardAmplitude` is the actual amplitude that is used to fill the audio buffer. Vinyl separates these two concepts so that the `output` can be free-floating and is only constrained at the very last point in the signal chain.

|Term            |Meaning                                                                                                                                                                                                                                                                                         |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`output`        |The un-limited resultant gain of the sound after Vinyl finishes messing with it                                                                                                                                                                                                                 |
|`config`        |Set in the [configuration file](Config-File) per asset or pattern                                                                                                                                                                                                                               |
|`local`         |Set on creation (by `VinylPlay()` etc.) and additionally altered by [`VinylGainSet()` and `VinylTargetGainSet()`](Gain). This gain is further altered by [`VinylFadeOut()`](Stopping-Audio). For sounds that are children of pattern voices, the `local` gain is inaccessible and is usually `1`|
|`parent`        |Set implicitly by a pattern that caused a sound to be played e.g. an voice of a Multi pattern is the parent of each child sound that is concurrently playing for that pattern                                                                                                                   |
|`ducking`       |Set by a [stack](Stacks) to control the gain of deprioritised voices                                                                                                                                                                                                                            |
|`label`         |Set in the [configuration file](Config-File), and additionally altered by `VinylGainSet()` and `VinylTargetGainSet()` when targeting a label                                                                                                                                                    |
|`emitter`       |Implicitly set by calculating the distance from the listener to the emitter that a Vinyl voice is playing on. Only Vinyl voices created by [`VinylPlayOnEmitter()`](Emitters) will factor in emitter gain, otherwise this gain is ignored                                                       |
|`VINYL_MAX_GAIN`|A [configuration macro](Config-Macros) found in `__VinylConfigMacros`. This value can be from zero to any number                                                                                                                                                                                |
|`system`        |Set by `VinylSystemGainSet()`. This gain should be above zero but can otherwise be any number, including greater than `1`                                                                                                                                                                       |
|`heardAmplitude`|The final final *final* amplitude that reaches your ears after the end of this long and exhausting process                                                                                                                                                                                      |

The gain for labels is calculated simply as `output = config * local`.