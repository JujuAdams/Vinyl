# Configuration File

&nbsp;

Vinyl's [configuration file](Config-File) is, basically, written as [JSON](https://en.wikipedia.org/wiki/JSON), a popular data interchange format. However, JSON is a pain in the bum to write by hand so Vinyl uses its own custom JSON-like syntax (which I'm going to call "Loose JSON" in lieu of a snappier name). If you've written JSON before then you'll grasp it very quickly, and I think that Loose JSON is faster and easier to write.

?> To match GameMaker's nomenclature, a JavaScript "object" will be referred to as a "struct" throughout Vinyl's documentation.

!> In order for live updating to work you must ensure that you have disabled the file system sandbox for your target platform. You can find this setting in Game Options in your project.

|Rule|                                                                                                                                                                                        |
|----|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|1   |Valid standard JSON is also valid Loose JSON                                                                                                                                            |
|2   |Loose JSON supports strings, numbers, boolean, and null/undefined as basic value types                                                                                                  |
|3   |Loose JSON can express structs and arrays like normal JSON                                                                                                                              |
|4   |You can use either commas or newlines to separate elements in a struct or array                                                                                                         |
|5   |Trailing commas are fine too                                                                                                                                                            |
|6   |Strings can be delimited with double quote marks `"` but don't *usually* have to be                                                                                                     |
|7   |If you'd like to use special symbols inside a string (e.g. `"` `:` `,` etc.), and you don't want to escape those characters, then you'll need to delimit strings with double quote marks|
|8   |If a string is _not_ delimited then any potential trailing or leading whitespace is automatically clipped off                                                                           |
|9   |If an undelimited string matches a keyword (`true` `false` `null` `undefined`) then it's converted to the GameMaker equivalent value (`null` is convered to GameMaker's `undefined`)    |
|10  |If an undelimited string like a number then the Loose JSON parser will try to turn it into a number                                                                                     |
|11  |Loose JSON supports escaped characters, including [Unicode escapes](https://dencode.com/en/string/unicode-escape)                                                                       |
|12  |A struct key can be a string or, optionally, an array of strings. Key strings can have spaces in them                                                                                   |
|13  |If a key is an array of strings, then the value associated with the key array will be duplicated for each member of the key array                                                       |

Here's an example of how JSON and Loose JSON compare (click the tabs to switch between formats):

<!-- tabs:start -->

#### **Loose JSON**

```loose
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

#### **JSON**

```json
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

<!-- tabs:end -->

As mentioned above, arrays of strings can be used in place of a string for struct keys. This will create duplicate key-value pairs for each element in the array. This feature is very helpful for sharing configuration across many assets with fewer lines of text. Here's an example of this:

<!-- tabs:start -->

#### **Loose JSON**

```loose
{
    [sndFootstepGrass, sndFootstepMetal, sndFootstepStone]: {
        gain: 0.9
        pitch: [0.9, 1.1]
        effect: footstep reverb
    }
}
```

#### **JSON**

```json
{
    "sndFootstepGrass": {
        "gain": 0.9,
        "pitch": [0.9, 1.1],
        "effect": "footstep reverb"
    },

    "sndFootstepMetal": {
        "gain": 0.9,
        "pitch": [0.9, 1.1],
        "effect": "footstep reverb"
    },

    "sndFootstepStone": {
        "gain": 0.9,
        "pitch": [0.9, 1.1],
        "effect": "footstep reverb"
    }
}
```

<!-- tabs:end -->

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

#### **High-pass**

A high-pass filter that thins out sounds by reducing low frequencies. Equivalent to `AudioEffectType.HPF2`.

|Property|Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `hpf`**                              |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

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
