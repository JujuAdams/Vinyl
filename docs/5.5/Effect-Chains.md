# Effect Chains

&nbsp;

Vinyl offers a streamlined version of GameMaker's native ["effect bus" system](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Effects/AudioEffect.htm) that automates much of the boilerplate code required to use dynamic audio effects, such as reverb or low-pass filters. Vinyl also allows you to live update effect parameters whilst the game is running, much like other properties in the [configuration file](Config-File).

Vinyl supports the following effects:
- Reverb (`AudioEffectType.Reverb1`)
- Delay (`AudioEffectType.Delay`)
- Bitcrusher (`AudioEffectType.Bitcrusher`)
- Low-pass filter (`AudioEffectType.LPF2`)
- Low shelf (`AudioEffectType.LoShelf`)
- High-pass filter (`AudioEffectType.HPF2`)
- High shelf (`AudioEffectType.HiShelf`)
- Peak EQ (`AudioEffectType.PeakEQ`)
- Multiband EQ (`AudioEffectType.EQ`)
- Tremolo (`AudioEffectType.Tremolo`)
- Compressor (`AudioEffectType.Compressor`)

Assets can be set up to automatically play using effect chains in the [configuration file](Config-File). Labels can also be set up in the [configuration file](Config-File) such that any assigned assets will use a particular effect chain.

?> When playing an asset using `VinylPlayOnEmitter()`, the effect chain will be determined by the emitter rather than the asset or label(s). You can set the effect chain to use for an emitter with `VinylEmitterEffectChain()`.

!> A voice can only be played on one effect chain at a time. As a result, a [label's `effect chain` property](Labels) can potentially conflict with effect chain definitions in other labels if an asset is assigned to multiple labels. This is not considered a critical error by Vinyl but can lead to unexpected behaviour.

&nbsp;

## Configuration Properties

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

## Examples

```
{ //Start of __VinylConfig
    ...
    
    effect chains: { //Start of effect chain definitions

        //Set up a default effect chain
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

        radio: [
            {
                type: hpf
                cutoff: 12000
                q: 10
            }
            {
                type: bitcrusher
                //Use GameMaker's default settings
            }
            {
                type: hpf
                cutoff: 400
                q: 65
            }
        ]
    }

    ...
}
```