# Configuration Syntax

&nbsp;

Vinyl's [configuration file](Configuration) is, basically, written as [JSON](https://en.wikipedia.org/wiki/JSON), a popular data interchange format. However, JSON is a pain in the bum to write by hand so Vinyl uses its own custom JSON-like syntax (which I'm going to call "Loose JSON" in lieu of a snappier name). If you've written JSON before then you'll grasp it very quickly, and I think that Loose JSON is faster and easier to write.

?> To match GameMaker's nomenclature, a JavaScript "object" will be referred to as a "struct" throughout Vinyl's documentation.

In brief:

1. Valid standard JSON is also valid Loose JSON
2. Loose JSON supports strings, numbers, boolean, and null as basic value types
3. Loose JSON can express structs and arrays like normal JSON
4. You can use either commas or newlines to separate elements in a struct or array
5. Trailing commas are fine too
6. Strings can be delimited with double quote marks `"` but don't have to be. If a string is _not_ delimited then any potential trailing or leading whitespace is automatically clipped off. If you'd like to use special symbols inside a string (e.g. `"` `:` `,` etc.), and you don't want to escape those characters, then you'll need to delimit strings with double quote marks
7. The keywords `true` `false` `null` `undefined` are translated to their GameMaker equivalents (`null` is convered to GameMaker's `undefined`)
8. If a value looks like a number then the Loose JSON parser will try to turn it into a number. Numbers inside `"` quote marks will stay as a string
9. Loose JSON supports escaped characters, including [Unicode escapes](https://dencode.com/en/string/unicode-escape)
10. A keys can be a string or, optionally, an array of strings. Key strings can have spaces in them
11. If a key is an array of strings, then the value associated with the key array will be duplicated for each member of the key array

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

The config file must contain a single struct, and each member variable in that struct defines a different component of Vinyl (assets, labels, patterns, and so on). You can read more about the precise meaning of each term [here](Terminology). Not every member variable needs to be present for Vinyl to accept the config file. Each component has its own syntax requirements and behaviours so be sure to read the documentation by choosing a topic from the sidebar.

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

# Properties Overview

&nbsp;

## Assets

|Name            |Datatype        |Default                             |Notes                                                                                                      |
|----------------|----------------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`                                 |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`                                 |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |                                    |                                                                                                           |
|`bpm`           |number          |[`VINYL_DEFAULT_BPM`](Config-Macros)|                                                                                                           |
|`loop`          |boolean         |                                    |                                                                                                           |
|`loop points`   |array of numbers|                                    |Array must have two-elements defining the start and end point of a loop, measured in seconds               |
|`stack`         |string          |                                    |                                                                                                           |
|`stack priority`|number          |`0`                                 |                                                                                                           |
|`effect chain`  |string          |                                    |                                                                                                           |
|`persistent`    |boolean         |                                    |                                                                                                           |

&nbsp;

## Labels

|Name            |Datatype        |Default|Notes                                                                                                      |
|----------------|----------------|-------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`    |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`    |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |       |                                                                                                           |
|`loop`          |boolean         |       |                                                                                                           |
|`stack`         |string          |       |                                                                                                           |
|`stack priority`|number          |`0`    |                                                                                                           |
|`effect chain`  |string          |       |                                                                                                           |
|`tag`           |string or array |       |Links this label to a native GameMaker asset tag. Can be a string for one tag, or an array of tags         |
|`children`      |array of structs|`[]`   |Must be an array of label structs                                                                          |

&nbsp;

## Stacks

|Name         |Datatype|Default                                        |Notes                                                                                               |
|-------------|--------|-----------------------------------------------|----------------------------------------------------------------------------------------------------|
|`ducked gain`|number  |`0`                                            |Defaults to `-60` db in [decibel mode](Config-Macros) (silence)                                     |
|`rate`       |number  |[`VINYL_DEFAULT_DUCK_GAIN_RATE`](Config-Macros)|Measured in gain units per second                                                                   |
|`pause`      |boolean |`true`                                         |Whether to pause an instance when fully ducked. Must be `false` if `ducked gain` is greater than `0`|

&nbsp;

## Patterns

|Name            |Datatype        |Default|Notes                                                                                                                        |
|----------------|----------------|-------|-----------------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |       |**Required.** Must be one of the following: `basic` `shuffle` `queue` `multi`                                                |
|`asset`         |string or struct|       |**Required.** Can be asset name, a pattern name, or a pattern struct. Must be an array for shuffle, queue, and multi patterns|
|`gain`          |number          |`1`    |Defaults to `0` db in [decibel mode](Config-Macros)                                                                          |
|`pitch`         |number or array |`1`    |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)                  |
|`transpose`     |number          |       |                                                                                                                             |
|`loop`          |boolean         |       |                                                                                                                             |
|`loop points`   |array of numbers|       |Must be a two-element array defining the start and end point of a loop, measured in seconds                                  |
|`stack`         |string          |       |                                                                                                                             |
|`stack priority`|number          |`0`    |                                                                                                                             |
|`effect chain`  |string          |       |                                                                                                                             |
|`label`         |string or array |       |Label to assign this pattern to. Can be a string for for label, or an array of label names                                   |
|`persistent`    |boolean         |       |                                                                                                                             |

The following properties are only relevant for particular pattern types:

|Name         |Datatype|Default                                        |Notes                                                             |
|-------------|--------|-----------------------------------------------|------------------------------------------------------------------|
|`behavior`   |number  |[`VINYL_DEFAULT_QUEUE_BEHAVIOR`](Config-Macros)|**Queue patterns only.** Must be one of the following: `0` `1` `2`|
|`sync`       |boolean |[`VINYL_DEFAULT_MULTI_SYNC`](Config-Macros)    |**Multi patterns only**                                           |
|`blend`      |number  |[`VINYL_DEFAULT_MULTI_BLEND`](Config-Macros)   |**Multi patterns only**                                           |
|`blend curve`|string  |                                               |**Multi patterns only**                                           |

&nbsp;

## Knobs

|Name          |Datatype        |Default |Notes                                                                                                                           |
|--------------|----------------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`default`     |number          |        |**Required.** Will be clamped between inside of the output range if either the input range or output range is explicitly defined|
|`input range` |array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |
|`output range`|array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |

&nbsp;

## Effect Chains

An effect chain should be defined as an array with, at most, 8 elements. Each element in the array defines an effect in the chain and must be a struct whose properties depend on what type the effect is.

### `reverb` type

Equivalent to `AudioEffectType.Reverb1`.

|Property|Datatype|Description                                                        |
|--------|--------|-------------------------------------------------------------------|
|`type`  |string  |**Must be `reverb`**                                               |
|`bypass`|boolean |                                                                   |
|`size`  |number  |From `0` to `1`. Larger values lead to a longer reverb             |
|`damp`  |number  |From `0` to `1`. Larger values reduce high frequencies more        |
|`mix`   |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

### `delay` type

Equivalent to `AudioEffectType.Delay`.

|Name      |Datatype|Description                                                           |
|----------|--------|----------------------------------------------------------------------|
|`type`    |string  |**Must be `delay`**                                                   |
|`bypass`  |boolean |Whether the effect should be bypassed (ignored)                       |
|`time`    |number  |Length of the delay (in seconds)                                      |
|`feedback`|number  |From `0` to `1`. Proportion of the signal to pass back into the effect|
|`mix`     |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)   |

### `bitcrusher` type

Equivalent to `AudioEffectType.Bitcrusher`.

|Name        |Datatype|Description                                                        |
|------------|--------|-------------------------------------------------------------------|
|`type`      |string  |**Must be `bitcrusher`**                                           |
|`bypass`    |boolean |Whether the effect should be bypassed (ignored)                    |
|`gain`      |number  |Input gain going into the clipping stage                           |
|`factor`    |number  |From `0` to `100`. Downsampling factor                             |
|`resolution`|number  |From `1` to `16`. Bit depth                                        |
|`mix`       |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

### `lpf` type

A low-pass filter that reduces high frequencies. Equivalent to `AudioEffectType.LPF2`.

|Name    |Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `lpf`**                              |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

### `hpf` type

A high-pass filter that thins out sounds by reducing low frequencies. Equivalent to `AudioEffectType.HPF2`.

|Name    |Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `hpf`**                              |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

### `tremolo` type

Equivalent to `AudioEffectType.Tremolo`.

|Name        |Datatype|Description                                                     |
|------------|--------|----------------------------------------------------------------|
|`type`      |string  |**Must be `tremolo`**                                           |
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

|Name    |Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `gain`**                             |
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