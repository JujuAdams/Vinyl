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

Emulates an echoey room where individual reflections cannot be clearly heard. Equivalent to `AudioEffectType.Reverb1`.

|Property|Datatype|Description                                                        |
|--------|--------|-------------------------------------------------------------------|
|`type`  |string  |**Must be `reverb`**                                               |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)                    |
|`size`  |number  |From `0` to `1`. Larger values lead to a longer reverb             |
|`damp`  |number  |From `0` to `1`. Larger values reduce high frequencies more        |
|`mix`   |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

#### **Delay**

Emulates a cavern or hard surface where individual reflections can be clearly heard. Equivalent to `AudioEffectType.Delay`.

|Name      |Datatype|Description                                                           |
|----------|--------|----------------------------------------------------------------------|
|`type`    |string  |**Must be `delay`**                                                   |
|`bypass`  |boolean |Whether the effect should be bypassed (ignored)                       |
|`time`    |number  |Length of the delay (in seconds)                                      |
|`feedback`|number  |From `0` to `1`. Proportion of the signal to pass back into the effect|
|`mix`     |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)   |

#### **Bitcrusher**

Distortion effect that futzes up audio for a harsh sound. Equivalent to `AudioEffectType.Bitcrusher`.

|Name        |Datatype|Description                                                        |
|------------|--------|-------------------------------------------------------------------|
|`type`      |string  |**Must be `bitcrusher`**                                           |
|`bypass`    |boolean |Whether the effect should be bypassed (ignored)                    |
|`gain`      |number  |Input gain going into the clipping stage                           |
|`factor`    |number  |From `0` to `100`. Downsampling factor                             |
|`resolution`|number  |From `1` to `16`. Bit depth                                        |
|`mix`       |number  |From `0` to `1`. Proportion of affected signal (`0` is 0% affected)|

#### **Low-pass**

A low-pass filter that thickens up sounds by reducing high frequencies. Equivalent to `AudioEffectType.LPF2`.

|Name    |Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `lpf`**                              |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

#### **High-pass**

A high-pass filter that thins out sounds by reducing low frequencies Equivalent to `AudioEffectType.HPF2`.

|Name    |Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `hpf`**                              |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`cutoff`|number  |Cutoff frequency, in Hertz                     |
|`q`     |number  |From `1` to `100`. How sharp the cutoff is     |

#### **Tremolo**

Modulates the gain of audio up and down over time. Equivalent to `AudioEffectType.Tremolo`.

|Name        |Datatype|Description                                                                           |
|------------|--------|--------------------------------------------------------------------------------------|
|`type`      |string  |**Must be `tremolo`**                                                                 |
|`bypass`    |boolean |Whether the effect should be bypassed (ignored)                                       |
|`rate`      |number  |From `0` to `20` Hertz. Frequency of the LFO modulating the gain                      |
|`intensity` |number  |From `0` to `1`. The depth of the effect. `1` is 100% affected                        |
|`offset`    |number  |From `0` to `1`. Left/right offset                                                    |
|`shape`     |string  |Mudt be one of the following: `sine` `square` `triangle` `sawtooth` `inverse sawtooth`|

#### **Gain**

Basic volume control. Equivalent to `AudioEffectType.Gain`.

|Name    |Datatype|Description                                    |
|--------|--------|-----------------------------------------------|
|`type`  |string  |**Must be `gain`**                             |
|`bypass`|boolean |Whether the effect should be bypassed (ignored)|
|`gain`  |number  |From `0` to `1`. Attenuates the signal         |

<!-- tabs:end -->