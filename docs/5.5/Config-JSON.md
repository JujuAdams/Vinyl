# Configuration File

&nbsp;

## Introduction and Simple Examples

Vinyl can import and export JSON which represents the audio setup for your game. You can define JSON that Vinyl should import on boot by editing `__VinylConfigJSON()`. You can also manually import JSON with `VinylSetupImportJSON()` and `VinylSetupExportJSON()` exports a JSON representation of the current configuration if you want to connect Vinyl to external tooling.

JSON import and export is not essential to using Vinyl and is offered as a way to more easily set up live editing. If you don't want to use JSON, you can use the `VinylSetup*()` functions without any loss in functionality (internally, Vinyl JSON executes `VinylSetup*()` functions anyway).

Vinyl JSON can define mixes, sound properties, and patterns. The root of a Vinyl JSON should be an array. This array should contain structs with each struct being a definition for a mix, a sound, or a pattern. Sound and pattern definitions are "leaf nodes" insofar that they contain no deeper definitions. However, mix definition structs can further contain definitions for sounds and patterns.

Here is an example of a simple Vinyl JSON:

```
[
    {
        "sound": "sndCat",
        "gain": 2
    },
    {
        "sound": "sndBleep1",
        "pitch": 0.6,
    },
    {
        "shuffle": "Footsteps",
        "pitch": [0.9, 1.1],
        "sounds": ["sndFootstep0", "sndFootstep1", "sndFootstep2", "sndFootstep3"]
    }
}
```

In this JSON we see three Vinyl definitions. Two of these resources are sound assets that have been imported to the project's IDE, they are called `sndBleep1` and `sndCat`. `sndCat` is defined to play with a gain of 2 (200% of the original amplitude). sndBleep is defined to play with a pitch of 0.6 (60% of the original pitch). There is additionally a definition for a shuffle pattern called `"Footsteps"`. When played, this pattern will vary the pitch of playback between 90% and 110% and will choose a sound to play from a selection (`sndFootstep0`, `sndFootstep1`, `sndFootstep2`, and `sndFootstep3`).

Sound and patterns definitions can be assigned to a mix by creating a mix definition and placing the sound/pattern definition inside the mix struct. Any sound or pattern not placed inside a mix struct will be assigned to the value of the config macro `VINYL_DEFAULT_MIX` (out of the box, this macro is set to `VINYL_NO_MIX`).

Here is an example of a mix JSON definition:

```
[
    {
        "mix": "music",
        "baseGain": 1.1,
        "members": [
            {
                "sound": "sndOverworld"
            },
            {
                "sound": "sndBossFight"
            }
        ]
    },
    {
        "sound": "sndWarning",
        "pitch": [0.8, 1.2]
    }
]
```

In this JSON we see four Vinyl definitions: three sounds and one mix. Two of these sounds, `"sndOverworld"` and `"sndBossFight"` are assigned to the `"music"` mix. The `"music"` mix has a slight gain boost of 1.1 so that sounds assigned to this mix are played slightly louder. The third sound is not placed inside a mix definition therefore it is assigned to the default mix.

&nbsp;

## Definition Types

<!--
Sounds:
    {
        "sound": <sound asset>, required
        "gain": <number> or <2-element array>, defaults to 1
        "pitch": <number> or <2-element array>, defaults to 1
        "loop": <boolean>, defaults to false
        "duckOn": <ducker name>
        "duckPrio", <number>, default to 0
        "metadata": <any>
    }

Shuffle Patterns:
    {
        "shuffle": <pattern name>, required
        "sounds": <array of sound assets, or wildcard pattern to match against>, required
        "gain": <number> or <2-element array>, defaults to 1
        "pitch": <number> or <2-element array>, defaults to 1
        "duckOn": <ducker name>
        "duckPrio", <number>, default to 0
        "metadata": <any>
    }

Head-Loop-Tail Patterns:
    {
        "hlt": <pattern name>, required
        "head": <sound asset>, optional, defaults to no asset
        "loop": <sound asset>, required
        "tail": <sound asset>, optional, defaults to no asset
        "gain": <number>, defaults to 1
        "duckOn": <ducker name>
        "duckPrio", <number>, default to 0
        "metadata": <any>
    }

Blend Patterns:
    {
        "blend": <pattern name>, required
        "sounds": <array of sound assets>, required
        "loop": <boolean>, defaults to true
        "gain": <number>, defaults to 1
        "duckOn": <ducker name>
        "duckPrio", <number>, default to 0
        "metadata": <any>
    }

Mixes:
    {
        "mix": <mix name>, required
        "baseGain": <number>, defaults to 1
        "membersLoop": <boolean>, defaults to <undefined>
        "members": <array of definitions>, defaults to no assets
        "metadata": <any>
    }

Duckers:
    {
        "ducker": <ducker name>, required
        "duckedGain": <number>, defaults to 1
        "rateOfChange": <number>, defaults to 1
    }

Global Metadata:
    {
        "metadata": <mix name>, required
        "data": <any>, required
    }
-->

&nbsp;

## High-level Structure

The config file must contain a single struct, and each member variable in that struct defines a different component of Vinyl (assets, labels, patterns, and so on). You can read more about the precise meaning of each term [here](Glossary). Not every member variable needs to be present for Vinyl to accept the config file. Each component has its own syntax requirements and behaviours so be sure to read the documentation below closely.

```
{
    assets: {
        ...
    }

    labels: {
        ...
    }

    stacks: {
        ...
    }
    
    patterns: {
        ...
    }

    knobs: {
        ...
    }

    effect chains: {
        ...
    }
}
```

&nbsp;

&nbsp;

# Properties Overview

The following is a cheat sheet of properties that each Vinyl component can have. Following the links underneath each heading to see more detailed information on how each component behaves.

&nbsp;

## Assets

You can read more about assets [here](Assets).

|Property        |Datatype        |Default                             |Notes                                                                                                      |
|----------------|----------------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`                                 |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`                                 |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*                       |                                                                                                           |
|`bpm`           |number          |[`VINYL_DEFAULT_BPM`](Config-Macros)|                                                                                                           |
|`loop`          |boolean         |*passthrough*                       |                                                                                                           |
|`loop points`   |array of numbers|*passthrough*                       |Array must have two-elements defining the start and end point of a loop, measured in seconds               |
|`stack`         |string          |*passthrough*                       |[Stack](Stacks) to push voices to                                                                          |
|`stack priority`|number          |`0`                                 |Priority for voices when pushed to the stack above                                                         |
|`effect chain`  |string          |*passthrough*                       |                                                                                                           |
|`label`         |string or array |`[]`                                |Label to assign this asset to. Can be a string for a single label, or an array of label names              |
|`persistent`    |boolean         |*passthrough*                       |                                                                                                           |

&nbsp;

## Labels

You can read more about labels [here](Labels).

|Property        |Datatype        |Default      |Notes                                                                                                      |
|----------------|----------------|-------------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`          |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`          |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*|                                                                                                           |
|`loop`          |boolean         |*passthrough*|                                                                                                           |
|`stack`         |string          |*passthrough*|[Stack](Stacks) to push voices assigned to this label to                                                   |
|`stack priority`|number          |`0`          |Priority for voices when pushed to the stack above                                                         |
|`effect chain`  |string          |*passthrough*|                                                                                                           |
|`tag`           |string or array |*passthrough*|Links this label to a native GameMaker asset tag. Can be a string for one tag, or an array of tags         |
|`children`      |array of structs|`[]`         |Must be an array of label structs                                                                          |
           
&nbsp;

## Stacks

You can read more about stacks [here](Stacks).

|Property     |Datatype|Default                                        |Notes                                                                                           |
|-------------|--------|-----------------------------------------------|------------------------------------------------------------------------------------------------|
|`ducked gain`|number  |`0`                                            |Defaults to `-60` db in [decibel mode](Config-Macros) (silence)                                 |
|`rate`       |number  |[`VINYL_DEFAULT_DUCK_GAIN_RATE`](Config-Macros)|Measured in gain units per second                                                               |
|`pause`      |boolean |`true`                                         |Whether to pause a voice when fully ducked. Must be `false` if `ducked gain` is greater than `0`|

&nbsp;

## Patterns

You can read more about patterns by following these links
- [Basic](Basic-Patterns)
- [Shuffle](Shuffle-Patterns)
- [Queue](Queue-Patterns)
- [Multi](Multi-Patterns)

|Property        |Datatype        |Default      |Notes                                                                                                                        |
|----------------|----------------|-------------|-----------------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |*passthrough*|**Required.** Must be one of the following: `basic` `shuffle` `queue` `multi`                                                |
|`asset`         |string or struct|*passthrough*|**Required.** Can be asset name, a pattern name, or a pattern struct. Must be an array for shuffle, queue, and multi patterns|
|`gain`          |number          |`1`          |Defaults to `0` db in [decibel mode](Config-Macros)                                                                          |
|`pitch`         |number or array |`1`          |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)                  |
|`transpose`     |number          |*passthrough*|                                                                                                                             |
|`loop`          |boolean         |*passthrough*|                                                                                                                             |
|`loop points`   |array of numbers|*passthrough*|Must be a two-element array defining the start and end point of a loop, measured in seconds                                  |
|`stack`         |string          |*passthrough*|[Stack](Stacks) to push voices to                                                                                            |
|`stack priority`|number          |`0`          |Priority for voices when pushed to the stack above                                                                           |
|`effect chain`  |string          |*passthrough*|                                                                                                                             |
|`label`         |string or array |`[]`         |Label to assign this asset to. Can be a string for a single label, or an array of label names                                |
|`persistent`    |boolean         |*passthrough*|                                                                                                                             |

The following properties are only relevant for particular pattern types:

|Property     |Datatype|Default                                        |Notes                                                                          |
|-------------|--------|-----------------------------------------------|-------------------------------------------------------------------------------|
|`behavior`   |number  |[`VINYL_DEFAULT_QUEUE_BEHAVIOR`](Config-Macros)|**Queue patterns only.** Must be one of the following: `0` `1` `2`             |
|`sync`       |boolean |[`VINYL_DEFAULT_MULTI_SYNC`](Config-Macros)    |**Multi patterns only**                                                        |
|`blend`      |number  |[`VINYL_DEFAULT_MULTI_BLEND`](Config-Macros)   |**Multi patterns only.** This is a normalised value from `0` to `1` (inclusive)|
|`blend curve`|string  |`undefined`                                    |**Multi patterns only.** If not defined, linear crossfades are used            |

?> Animation curves used for Multi patterns are live updated by Vinyl and any changes made to animation curves in the IDE will be reflected at runtime.

&nbsp;

## Knobs

You can read more about knobs [here](Knobs).

|Property      |Datatype        |Default |Notes                                                                                                                           |
|--------------|----------------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`default`     |number          |        |**Required.** Will be clamped between inside of the output range if either the input range or output range is explicitly defined|
|`input range` |array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |
|`output range`|array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |

&nbsp;

## Effect Chains

You can read more about effect chains [here](Effect-Chains).

An effect chain should be defined as an array with, at most, 8 elements. Each element in the array defines an effect in the chain and must be a struct whose properties depend on what type the effect is.

The effect chain name `main` is special and is used for any voices without a defined effect chain.

<!-- tabs:start -->

#### **Reverb**

Equivalent to `AudioEffectType.Reverb1`.

|Property|Datatype|Description                                                        |
|--------|--------|-------------------------------------------------------------------|
|`type`  |string  |**Must be `reverb`**                                               |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)                    |
|`size`  |number  |From `0` to `1`. Larger values lead to a longer reverb             |
|`damp`  |number  |From `0` to `1`. Larger values reduce high frequencies more        |
|`mix`   |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

#### **Delay**

Equivalent to `AudioEffectType.Delay`.

|Property  |Datatype|Description                                                           |
|----------|--------|----------------------------------------------------------------------|
|`type`    |string  |**Must be `delay`**                                                   |
|`bypass`  |boolean |Whether the effect should be bypassed (ignored)                       |
|`time`    |number  |Length of the delay (in seconds)                                      |
|`feedback`|number  |From `0` to `1`. Proportion of the signal to pass back into the effect|
|`mix`     |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)   |

#### **Bitcrusher**

Equivalent to `AudioEffectType.Bitcrusher`.

|Property    |Datatype|Description                                                        |
|------------|--------|-------------------------------------------------------------------|
|`type`      |string  |**Must be `bitcrusher`**                                           |
|`bypass`    |boolean |Whether the effect should be bypassed (ignored)                    |
|`gain`      |number  |Input gain going into the clipping stage                           |
|`factor`    |number  |From `0` to `100`. Downsampling factor                             |
|`resolution`|number  |From `1` to `16`. Bit depth                                        |
|`mix`       |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

#### **Low-pass**

A low-pass filter that reduces high frequencies. Equivalent to `AudioEffectType.LPF2`.

|Property|Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `lpf`**                              |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

#### **Low Shelf**

Increases the gain of frequencies below the filter frequency. Equivalent to `AudioEffectType.LoShelf`.

|Property|Datatype|Description                                                                                                 |
|--------|--------|------------------------------------------------------------------------------------------------------------|
|`type`  |string  |**Must be `loshelf`**                                                                                       |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)                                                             |
|`freq`  |number  |Filter frequency, in Hertz                                                                                  |
|`q`     |number  |From `1` to `100`. How sharp the "knee" of the filter is                                                    |
|`gain`  |number  |Multiplicative gain below the filter frequency. Must be larger than or equal to `0` with `1` being no change|

#### **High-pass**

A high-pass filter that thins out sounds by reducing low frequencies. Equivalent to `AudioEffectType.HPF2`.

|Property|Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `hpf`**                              |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

#### **High Shelf**

Increases the gain of frequencies above the filter frequency. Equivalent to `AudioEffectType.HiShelf`.

|Property|Datatype|Description                                                                                                 |
|--------|--------|------------------------------------------------------------------------------------------------------------|
|`type`  |string  |**Must be `hishelf`**                                                                                       |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)                                                             |
|`freq`  |number  |Filter frequency, in Hertz                                                                                  |
|`q`     |number  |From `1` to `100`. How sharp the "knee" of the filter is                                                    |
|`gain`  |number  |Multiplicative gain above the filter frequency. Must be larger than or equal to `0` with `1` being no change|

#### **Peak EQ**

Increases the gain of frequencies around the filter frequency. Equivalent to `AudioEffectType.PeakEQ`.

|Property|Datatype|Description                                                                                                  |
|--------|--------|-------------------------------------------------------------------------------------------------------------|
|`type`  |string  |**Must be `peakeq`**                                                                                         |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)                                                              |
|`freq`  |number  |Filter frequency, in Hertz                                                                                   |
|`q`     |number  |From `1` to `100`. How sharp the filter is                                                                   |
|`gain`  |number  |Multiplicative gain around the filter frequency. Must be larger than or equal to `0` with `1` being no change|

#### **Multiband EQ**

Shapes the gain of audio using a combined set of filters. Equivalent to `AudioEffectType.EQ`.

Not all of the filters in a multiband EQ need to be used.

|Property |Datatype|Description                                                                                                  |
|---------|--------|-------------------------------------------------------------------------------------------------------------|
|`type`   |string  |**Must be `peakeq`**                                                                                         |
|`bypass` |boolean |Whether the effect should be bypassed (ignored)                                                              |
|`locut`  |struct  |A high-pass filter. See "High-pass" tab above                                                                |
|`loshelf`|struct  |A low shelf filter. See "Low Shelf" tab above                                                                |
|`eq1`    |struct  |A peak EQ filter. See "Peak EQ" tab above                                                                    |
|`eq2`    |struct  |A peak EQ filter. See "Peak EQ" tab above                                                                    |
|`eq3`    |struct  |A peak EQ filter. See "Peak EQ" tab above                                                                    |
|`eq4`    |struct  |A peak EQ filter. See "Peak EQ" tab above                                                                    |
|`hishelf`|struct  |A low-pass filter. See "Low-pass" tab above                                                                  |
|`hicut`  |struct  |A high shelf filter. See "High Shelf" tab above                                                              |

#### **Tremolo**

Equivalent to `AudioEffectType.Tremolo`.

|Property    |Datatype|Description                                                                           |
|------------|--------|--------------------------------------------------------------------------------------|
|`type`      |string  |**Must be `tremolo`**                                                                 |
|`bypass`    |boolean |Whether the effect should be bypassed (ignored)                                       |
|`rate`      |number  |From `0` to `20` Hertz. Frequency of the LFO modulating the gain                      |
|`intensity` |number  |From `0` to `1`. The depth of the effect. `1` is 100% affected                        |
|`offset`    |number  |From `0` to `1`. Left/right offset                                                    |
|`shape`     |string  |Mudt be one of the following: `sine` `square` `triangle` `sawtooth` `inverse sawtooth`|

#### **Gain**

Basic volume control. Equivalent to `AudioEffectType.Gain`.

|Property|Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `gain`**                             |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`gain`  |number  |From `0` to `1`. Attenuates the signal         |

<!-- tabs:end -->