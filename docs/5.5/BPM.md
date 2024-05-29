# BPM

&nbsp;

"BPM" is short for "beats per minute", a measure of the musical pace of music. These values are useful for tying rhythmic elements in your game to the music, or to some other looping periodic sound.

?> A music's BPM is not automatically detected; BPM values should be set [per asset](Assets) in the [configuration file](Config-File).

&nbsp;

## `VinylBPMGet`

`VinylBPMGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the BPM for a [voice](Voices)

|Name    |Datatype|Purpose        |
|--------|--------|---------------|
|`target`|voice   |Voice to target|

?> When targeting a [Multi pattern voice](Multi-Patterns), this function will return the BPM of the asset with the shortest length.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylBPMPulseGet`

`VinylBPMPulseGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, a BPM pulse for a [voice](Voices)

|Name    |Datatype|Purpose        |
|--------|--------|---------------|
|`target`|voice   |Voice to target|

The BPM pulse is set to `true` at the frequency specified by the voice's asset's BPM. If the voice is paused (either by [`VinylPause()`](Pausing) or by a [stack](Stacks)), `BPM` pulse will return `false`.

?> When targeting a [Multi pattern voice](Multi-Patterns), this function will return the BPM pulse of the asset with the shortest length.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylBeatCountGet`

`VinylBeatCountGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the total number of beats played for a [voice](Voices)

|Name    |Datatype|Purpose        |
|--------|--------|---------------|
|`target`|voice   |Voice to target|

?> When targeting a [Multi pattern voice](Multi-Patterns), this function will return the BPM count of the asset with the shortest length.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->