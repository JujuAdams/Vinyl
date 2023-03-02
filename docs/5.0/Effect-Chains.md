# Effect Chains

&nbsp;

## Configuration Properties

An effect chain should be defined as an array with, at most, 8 elements. Each element in the array defines an effect in the chain and must be a struct whose properties depend on what type the effect is.

The effect chain name `main` is special and is used for any voices without a defined effect chain.

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

<!-- tabs:start -->

#### **Reverb**

Equivalent to `AudioEffectType.Reverb1`.

|Property   |Config Name|Datatype|Description                                                        |
|-----------|-----------|--------|-------------------------------------------------------------------|
|Effect type|`type`     |string  |**Must be `reverb`**                                               |
|Bypass     |`bypass`   |boolean |Whether the effect should be bypassed (ignored)                    |
|Size       |`size`     |number  |From `0` to `1`. Larger values lead to a longer reverb             |
|Damping    |`damp`     |number  |From `0` to `1`. Larger values reduce high frequencies more        |
|Mix        |`mix`      |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

#### **Delay**

Equivalent to `AudioEffectType.Delay`.

|Property   |Config Name|Datatype|Description                                                           |
|-----------|-----------|--------|----------------------------------------------------------------------|
|Effect type|`type`     |string  |**Must be `delay`**                                                   |
|Bypass     |`bypass`   |boolean |Whether the effect should be bypassed (ignored)                       |
|Time       |`time`     |number  |Length of the delay (in seconds)                                      |
|Feedback   |`feedback` |number  |From `0` to `1`. Proportion of the signal to pass back into the effect|
|Mix        |`mix`      |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)   |

#### **Bitcrusher**

Equivalent to `AudioEffectType.Bitcrusher`.

|Property   |Config Name |Datatype|Description                                                        |
|-----------|------------|--------|-------------------------------------------------------------------|
|Effect type|`type`      |string  |**Must be `bitcrusher`**                                           |
|Bypass     |`bypass`    |boolean |Whether the effect should be bypassed (ignored)                    |
|Gain       |`gain`      |number  |Input gain going into the clipping stage                           |
|Factor     |`factor`    |number  |From `0` to `100`. Downsampling factor                             |
|Resolution |`resolution`|number  |From `1` to `16`. Bit depth                                        |
|Mix        |`mix`       |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

#### **Low-pass**

A low-pass filter that reduces high frequencies. Equivalent to `AudioEffectType.LPF2`.

|Property   |Config Name|Datatype|Description                                    |
|-----------|-----------|--------|-----------------------------------------------|
|Effect type|`type`     |string  |**Must be `lpf`**                              |
|Bypass     |`bypass`   |boolean |Whether the effect should be bypassed (ignored)|
|Cutoff     |`cutoff`   |number  |Cutoff frequency, in Hertz                     |
|Q          |`q`        |number  |From `1` to `100`. How sharp the cutoff is     |

#### **High-pass**

A high-pass filter that thins out sounds by reducing low frequencies. Equivalent to `AudioEffectType.HPF2`.

|Property   |Config Name|Datatype|Description                                    |
|-----------|-----------|--------|-----------------------------------------------|
|Effect type|`type`     |string  |**Must be `hpf`**                              |
|Bypass     |`bypass`   |boolean |Whether the effect should be bypassed (ignored)|
|Cutoff     |`cutoff`   |number  |Cutoff frequency, in Hertz                     |
|Q          |`q`        |number  |From `1` to `100`. How sharp the cutoff is     |

#### **Tremolo**

Equivalent to `AudioEffectType.Tremolo`.

|Property   |Config Name|Datatype|Description                                                                           |
|-----------|-----------|--------|--------------------------------------------------------------------------------------|
|Effect type|`type`     |string  |**Must be `tremolo`**                                                                 |
|Bypass     |`bypass`   |boolean |Whether the effect should be bypassed (ignored)                                       |
|Cutoff     |`rate`     |number  |From `0` to `20` Hertz. Frequency of the LFO modulating the gain                      |
|Intensity  |`intensity`|number  |From `0` to `1`. The depth of the effect. `1` is 100% affected                        |
|Offset     |`offset`   |number  |From `0` to `1`. Left/right offset                                                    |
|Shape      |`shape`    |string  |Mudt be one of the following: `sine` `square` `triangle` `sawtooth` `inverse sawtooth`|

#### **Gain**

Basic volume control. Equivalent to `AudioEffectType.Gain`.

|Property   |Config Name|Datatype|Description                                    |
|-----------|-----------|--------|-----------------------------------------------|
|Effect type|`type`     |string  |**Must be `gain`**                             |
|Bypass     |`bypass`   |boolean |Whether the effect should be bypassed (ignored)|
|Gain       |`gain`     |number  |From `0` to `1`. Attenuates the signal         |

<!-- tabs:end -->