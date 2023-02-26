# Configuration

&nbsp;

Vinyl is centred around a single configuration file that controls the underlying volumes, pitches, and behaviours of audio played with Vinyl. You can find this configuration file in the Vinyl folder in your asset browser; its name is `__VinylConfig`. When you import Vinyl for the first time, this config file will be filled with some example configuration and some comments (you can see an online copy of this file [here](https://github.com/JujuAdams/Vinyl/blob/master/notes/__VinylConfig/__VinylConfig.txt)).

`__VinylConfig` can be edited whilst the game is running from the IDE on Windows, Mac, or Linux. If Vinyl detects that a change has been made, Vinyl will live update audio playback without you having to close and recompile the entire game. This means you can finesse your audio mix without having to stop playing the game - a substantial workflow improvement over what GameMaker offers natively.

?> If you're changing values inside the configuration file and nothing seems to be happening, check your debug log for any errors, and then check your [config macros](Config-Macros).

The gain and pitch values `__VinylConfig` default to GameMaker's standard normalised values: a gain of `0` is silent and a gain of `1` is unaffected, a pitch of `0.5` is half the frequency and a pitch of `1` is unaffected. These can be changed to decibel and percentage values respectively by toggling a couple of [config macros](Config-Macros).

&nbsp;

## "Loose JSON" Syntax

Vinyl's configuration file is, basically, written as [JSON](https://en.wikipedia.org/wiki/JSON), a popular data interchange format. However, JSON is a pain in the bum to write by hand so Vinyl uses its own custom JSON-like syntax (which I'm going to call "Loose JSON" in lieu of a snappier name). If you've written JSON before then you'll grasp it very quickly, and I think that Loose JSON is faster and easier to write.

In brief:

1. Valid standard JSON is also valid Loose JSON
2. Loose JSON supports strings, numbers, boolean, and null as basic value types
3. Loose JSON can express objects and arrays like normal JSON
4. You can use either commas or newlines to separate elements in an object or array
5. Trailing commas are fine too
6. Strings can be delimited with double quote marks `"` but don't have to be. If a string is _not_ delimited then any potential trailing or leading whitespace is automatically clipped off. If you'd like to use special symbols inside a string (e.g. `"` `:` `,` etc.), and you don't want to escape those characters, then you'll need to delimit strings with double quote marks
7. The keywords `true` `false` `null` are translated to their GameMaker equivalents (`null` is GameMaker's `undefined`)
8. If a value looks like a number then the Loose JSON parser will try to turn it into a number
9. Loose JSON supports escaped characters, including [Unicode escapes](https://dencode.com/en/string/unicode-escape)
10. Keys must be strings, but can have spaces in them

Here's a standard JSON example:

```
{
    "menu": {
        "id": 4578,
        "value": "File",
        "popup": {
            "menuitem": ["New", "Open", "Close"]
        }
    }
}
```

And here's an equivalent Loose JSON example:

```
{
    menu: {
        id: 4578,
        value: File
        popup: {
            menuitem: [New, Open, Close]
        }
    }
}
```

&nbsp;

## High-level Structure

Vinyl expects - and requires - that the top-level object contains three child objects, called `labels`, `assets`, `patterns`, and `effect buses`. Each of these child objects represent different parts of Vinyl's operation. You can read more about the precise meaning of ["Label", "Asset", "Pattern" and "Effect Bus" here](Terminology). Each category has its own rules and expectations for setup; scroll down for info.

```
{
    labels: {
        ...
    }
    
    assets: {
        ...
    }
    
    patterns: {
        ...
    }

    effect chains: {
        ...
    }

    knobs: {
        ...
    }
}
```

&nbsp;

## Labels

Labels are the way that Vinyl categorises assets and patterns, and the primary way to control the behaviour of audio in groups. You can read more about the capabilities of labels [here](Terminology).

Labels can have the following properties:

### `gain`

*Default value: `1.0` (or `0` db in decibel mode)*

The [gain](Terminology) multiplication factor for all assets/patterns assigned to this label. If multiple labels are specified for an asset/pattern then the gain values for all labels are multiplied together. The gain factor is further multiplied with other gains, including asset/pattern gain, [instance gain](Basics), and [system gain](Advanced).

You may use a knob to control label gain e.g. `gain: @musicPresence` will set up the `musicPresence` knob to control the gain of a label.

### `pitch`

*Default value: `1.0` (or `100` in percentage mode)*

The [pitch](Terminology) multiplication factor for all assets/patterns assigned to this label. If multiple labels are specified for an asset/pattern then the pitch values for all labels are multiplied together. The pitch factor is further multiplied with other pitch multipliers, including asset/pattern pitch and [instance pitch](Basics).

A pitch value can be specified as either a number, a two-element array containing two numbers, or a knob. If a two-element array is provided then the pitch value is randomised between the two values. Configuring a label to include the property definiton `pitch: @musicSpeed` will set up the `musicSpeed` knob to control the pitch of a label.

### `transpose`

*Default value: `null`*

[Transposing](Terminology) audio can give an extra musical flair to your sound design. The transposition value is measured in semitones of the standard Western diatonic scale. Any transposition value set on labels is further modified by transposition values on assets, patterns, or instances themselves.

The transposition value must be as a number, or a knob. Configuring a label to include the property definiton `transpose: @semitones` will set up the `semitones` knob to control the transposition of a label.

?> Transposition is also affected by the [global transposition value](Semitones).

### `limit`

*Default value: `infinity`*

The total number of instances (assigned to this label) that can simultaneously play. This is very useful for automatically managing music tracks: set `limit` to `1` and only one music track can play at a time, allowing for automatic management of background music. It is only useful for frequent audio effects, such as a coin pickup sound, where audio stacking up can sound unpleasant.

### `limit fade out rate`

*Default value: `null`*

This property controls how quickly audio fades out when the instance count limit is exceeded. This value is measured in units/second: a value of `0.4` means that an instance with a starting gain of `0.8` will take 2 seconds to fully fade out.

If this property is set to `null` then the fade out speed defaults to `VINYL_DEFAULT_GAIN_RATE`.

### `loop`

*Default value: `false`*

Whether to loop assets (but not patterns) assigned to this label, by default. You can override this looping behaviour by setting the `loop` argument when [playing audio](Basic).

### `effect chain`

*Default value: `null`*

The effect chain to use for assets assigned to this label. This property can be overrided by the `effect chain` property on an asset (see below).

!> A sound can only be played on one effect chain at a time. As a result, this label property can potentially conflict with effect chain definitions in other labels if an asset is assigned to multiple labels. This is not considered a critical error by Vinyl but can lead to unexpected behaviour.

### `tag`

*Default value: `null`*

Links this label to a GameMaker asset tag. This value will usually be given a single GameMaker asset tag, but it can also be given an array of tags. Any sound asset with any of the tags will be assigned to the respective Vinyl label.

### `children`

*Default value: `{}`*

Each element in the child object specifies a child label. An asset assigned to a child label also inherits behaviour from the parent label (recursively), including any values changed at runtime.

&nbsp;

```
{
    ...
    
    labels: {
        music: {
            loop: true
            limit: 1
        }
        ambience: {
            loop: true
            limit: 1
        }
        menu: {}
        gameplay: {}
        sfx: {
            children: {
                speech: {
                    pitch: [0.9, 1.1]
                }
                footsteps: {
                    pitch: [0.8, 1.2]
                }
                ui: {
                    gain: 0.8
                }
            }
        }
    }
    
    ...
}
```

&nbsp;

## Assets

These are the basic sound organisation units in Vinyl (and, indeed, GameMaker). A Vinyl asset is the same as a GameMaker asset - a specific, finite audio clip. The names of assets as defined in Vinyl's configuration file must be **identical** to the names of assets in GameMaker's asset browser.

?> The special asset name `fallback` can be used to define properties for sound assets that have not otherwise been specified. This is helpful to protect against audio configuration problems, or to simplify certain configuration tasks (such as defaulting audio to the `sfx` label if not otherwise defined).

Assets can have the following properties:

### `gain`

*Default value: `1.0` (or `0` db in decibel mode)*

The [gain](Terminology) multiplication factor for this asset. The gain factor is further multiplied with other gains, including label gain, [instance gain](Basics), and [system gain](Advanced).

You may use a knob to control asset gain e.g. `gain: @stingPresence` will set up the `stingPresence` knob to control the gain of an asset.

### `pitch`

*Default value: `1.0` (or `100` in percentage mode)*

The [pitch](Terminology) multiplication factor for this assets. The pitch factor is further multiplied with other pitch multipliers, including label pitch and [instance pitch](Basics).

A pitch value can be specified as either a number, a two-element array containing two numbers, or a knob. If a two-element array is provided then the pitch value is randomised between the two values. Configuring an asset to include the property definiton `pitch: @voicePitch` will set up the `voicePitch` knob to control the pitch of an asset.

### `transpose`

*Default value: `null`*

[Transposing](Terminology) audio can give an extra musical flair to your sound design. The transposition value is measured in semitones of the standard Western diatonic scale. Any transposition value set on assets is further modified by transposition values on labels, patterns, or instances themselves.

The transposition value must be as a number, or a knob. Configuring a label to include the property definiton `transpose: @semitones` will set up the `semitones` knob to control the transposition of an asset.

?> Transposition is also affected by the [global transposition value](Semitones).

### `label`

*Default value: `null`*

Which label this asset is assigned to. If an array is specified, the asset will be assigned to all labels. If no label is specified (the default, `null`) then the asset will not be assigned to any label at all.

### `loop`

*Default value: `false`*

Whether to loop assets (but not patterns) assigned to this label, by default. You can override this looping behaviour by setting the `loop` argument when [playing audio](Basic).

### `loop points`

*Default value: `undefined`*

Defines the start and end loop points for the asset. These loop points should be declared as a two-element array containing two times, the first value being the start of the loop point and the second value being the end of the loop point. The times should be in seconds. For example, `loop points: [1.24, 10.8]` defines a loop between 1.24 seconds and 10.8 seconds for a sound asset.

### `effect chain`

*Default value: `null`*

The effect chain to use when playing this asset. This property overrides the `effect chain` property for any label this asset is assigned to.

&nbsp;

```
{
    ...
    
    assets: {
        fallback: {}
        sndChickenNuggets: {
            label: music
            copyTo: sndTestTone
        }
    }
    
    ...
}
```

&nbsp;

## Patterns

Patterns are a convenient way to execute common audio playback behaviours. A pattern can be specified in lieu of a sound asset when executing any [Vinyl playback function](Basics).

Patterns can have the following properties:

### `gain`

*Default value: `1.0` (or `0` db in decibel mode)*

The [gain](Terminology) multiplication factor for all assets/patterns assigned to this label. The gain factor is further multiplied with other gains, including label gain, asset gain, and [system gain](Advanced).

### `pitch`

*Default value: `1.0` (or `100` in percentage mode)*

The [pitch](Terminology) multiplication factor for all assets/patterns assigned to this label. The pitch factor is further multiplied with other pitch multipliers, including label pitch, asset pitch and [instance pitch](Basics).

A pitch value can be specified as either a number, or as a two-element array containing two numbers. If a two-element array is provided then the pitch value is randomised between the two values.

### `transpose`

*Default value: `null`*

[Transposing](Terminology) audio can give an extra musical flair to your sound design. The transposition value is measured in semitones of the standard Western diatonic scale. Any transposition value set on assets is further modified by transposition values on labels, assets, or instances themselves.

The transposition value must be as a number, or a knob. Configuring a label to include the property definiton `transpose: @semitones` will set up the `semitones` knob to control the transposition of a pattern.

?> Transposition is also affected by the [global transposition value](Semitones).

### `label`

*Default value: `null`*

Which label this pattern is assigned to. If an array is specified, the pattern will be assigned to all labels. If no label is specified (the default, `null`) then the pattern will not be assigned to any label at all.

&nbsp;

Patterns **must** further have one of the following types. These determine the behaviour of the pattern when played.

### `basic` type

Plays the specified audio asset in the `asset` property.

### `shuffle` type

Plays a random audio asset from an array in the `assets` property.

### `queue` type

Plays audio assets sequentially from an array in the `assets` property.

Queue patterns can additionally have the `behavior` property which determines the default behavior when playing the pattern. This is the same values as set by [`VinylQueueBehaviorSet()`](Queue-Patterns). The behaviour property defaults to `0` which plays the queue once (and assets will be removed from the queue once they finish playing).

?> Setting the behavior for an instance of a Queue pattern will override the behavior set on the pattern. This means any change to a pattern's `behavior` property by live updating will be ignored if `VinylQueueBehaviorSet()` has ever been called for an instance.

### `multi` type

Plays audio assets simultaneously from an array in the `assets` property.

Multi patterns may further have the `blend` and `sync` properties. These are the same values as set by [`VinylMultiBlendSet()` or `VinylMultiSyncSet()`](Multi-Patterns). You can control the blend value of a Multi pattern using a knob (but not the sync state). The blend factor defaults to `undefined` (no blending, all tracks are played at a gain of `1`), and the sync state defaults to `false` (no synchronisation).

?> Setting the blend factor or sync state for an instance of a Multi pattern will override the values set on the pattern. This means any change to a pattern's `blend` or `sync` property by live updating (or using a knob will be ignored if `VinylMultiBlendSet()` or `VinylMultiSyncSet()` have ever been called for an instance.

Out of the box and without other alteration, the `blend` property (and `VinylMultiBlendSet()`) expects non-normalized values. This means that for a Multi pattern with 3 children, the `blend` property can range from `0` (100% gain for the child with index 0) to `2` (100% fain for the child with index 2). If you set the `blend normalize` property to `true` then a Multi pattern with instead use a normalized value for both `blend` and `VinylMultiBlendSet()` for the pattern in question, ranging from `0` to `1`. You can also change [`VINYL_DEFAULT_MULTI_BLEND_NORMALIZE`](Config-Macros) to change the default behaviour when `blend normalize` is not set.

&nbsp;

```
{
    ...
    
    patterns: {
        random pitch test: {
            type: basic
            asset: sndTestTone
            pitch: [0.8, 1.2]
        }
        
        shuffle test: {
            type: shuffle
            assets: [
                sndTestTone
                sndChickenNuggets
            ]
        }
    }

    ...
}
```

&nbsp;

## Effect Chains

Vinyl allows you to define effect chains from the configuration file. You can read more about the details of GameMaker's native effects system in [the GameMaker documentation](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Effects/AudioEffect.htm).

?> The effect chain name `main` is a special case that refers to the main audio bus. Any audio that is played _without_ explicitly being played through a named effect chain will instead play on the `main` effect chain. Effectively the `main` effect chain is the "fallback" or "default" effect chain to use.

You should define an effect bus as an array of individual effects. An effect chain may have up to 8 effects i.e. the array for an effect bus should have no more than 8 elements. You can see an example of an effect bus definition at the end of this section.

Any effect that has the "number" datatype can also be set to a knob. For example, the property definition `mix: @effectWetness` will set up the `effectWetness` knob to control the mix property of an effect.

Effects added to an effect chain can be one of the following types:

### `reverb` type

Equivalent to `AudioEffectType.Reverb1`.

|Property|Datatype|Description                                                        |
|--------|--------|-------------------------------------------------------------------|
|`bypass`|boolean |Whether the effect should be bypassed (ignored)                    |
|`size`  |number  |From `0` to `1`. Larger values lead to a longer reverb             |
|`damp`  |number  |From `0` to `1`. Larger values reduce high frequencies more        |
|`mix`   |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

### `delay` type

Equivalent to `AudioEffectType.Delay`.

|Property  |Datatype|Description                                                           |
|----------|--------|----------------------------------------------------------------------|
|`bypass`  |boolean |Whether the effect should be bypassed (ignored)                       |
|`time`    |number  |Length of the delay (in seconds)                                      |
|`feedback`|number  |From `0` to `1`. Proportion of the signal to pass back into the effect|
|`mix`     |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)   |

### `bitcrusher` type

Equivalent to `AudioEffectType.Bitcrusher`.

|Property    |Datatype|Description                                                        |
|------------|--------|-------------------------------------------------------------------|
|`bypass`    |boolean |Whether the effect should be bypassed (ignored)                    |
|`gain`      |number  |Input gain going into the clipping stage                           |
|`factor`    |number  |From `0` to `100`. Downsampling factor                             |
|`resolution`|number  |From `1` to `16`. Bit depth                                        |
|`mix`       |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

### `lpf` type

A low-pass filter that reduces high frequencies. Equivalent to `AudioEffectType.LPF2`.

|Property|Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

### `hpf` type

A high-pass filter that thins out sounds by reducing low frequencies. Equivalent to `AudioEffectType.HPF2`.

|Property|Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

### `tremolo` type

Equivalent to `AudioEffectType.Tremolo`.

|Property    |Datatype|Description                                                     |
|------------|--------|----------------------------------------------------------------|
|`bypass`    |boolean |Whether the effect should be bypassed (ignored)                 |
|`rate`      |number  |From `0` to `20` Hertz. Frequency of the LFO modulating the gain|
|`intensity` |number  |From `0` to `1`. The depth of the effect. `1` is 100% affected  |
|`offset`    |number  |From `0` to `1`. Left/right offset                              |
|`shape`     |string  |See below                                                       |

`shape` can be one of the following strings:
- `sine`
- `square`
- `triangle`
- `sawtooth`
- `inverse sawtooth`

### `gain` type

Basic volume control. Equivalent to `AudioEffectType.Gain`.

|Property|Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`gain`  |number  |From `0` to `1`. Attenuates the signal         |

&nbsp;

```
{
    ...
    
    effect chains: {
        main: [
            {
                type: delay
                time: 0.25
                mix: 0.4
            }
            {
                type: reverb
                size: 0.6
                mix: 0.3
            }
        ]
    }

    ...
}
```

&nbsp;

## Knobs

Vinyl allows you to modify properties across labels, assets, patterns, and effect chains using "knobs". You can read more about knobs [here](Terminology).

Knobs can be defined in two ways (see below for two examples). Either a knob can be an object with three properties (`default`, `input range`, `output range`), or a knob can be a number. If you set a knob to be a number then the number specified is presumed to be the default output value for the knob, and the knob will have no limit on the input or output range (the value set for the knob will be passed through to the output).

Knobs can be attached to properties where indicated. A connection to a knob should be specified in the configuration file by using the `@` symbol followed by the name of the knob, for example `@spookiness` will create a refernce to the `spookiness` knob.

### `default`

*Default value: N/A*

The default output value from the knob. This will be clamped within the defined output range (which, if not specified, is `0` to `1`).

?> The `default` property must be defined.

### `input range`

*Default value: `[0, 1]`*

The range of input values that this knob will accept. The input value is remapped onto the output range before setting values for labels, assets, and patterns.

&nbsp;

### `output range`

*Default value: `[0, 1]`*

The range of output values that this knob will emit.

&nbsp;

```
{
    ...
    
    knobs: {
        sizefulness: 0.3 //If we use a number then that's the default value, and the range is 0 -> 1

        delayTime: {
            default: 0.4
            output range: [0.3, 0.8]
        }
    }
    
    ...
}
```
