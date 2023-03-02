# Transposition

&nbsp;

Tuning sound effects to harmonise nicely with background music is a technique that designers regularly employ to tie a game's audio together. Vinyl allows for audio to track changes in pitch per label, asset, pattern, and voice. The entire system can also have a transposition applied to it - though the global transposition state only applies to sounds that are already being transposed (even if the local resultant transposition value is `0`).

To this end, transposition can be enabled in multiple ways. A voice will inherit transposition value additively from any labels for the voice, from assets and patterns, and the per-voice transposition value can be set by calling `VinylTransposeSet()`.

Generally speaking, you'll want to set your system-wide transposition based on the background music you're playing. Any voice that has inherited a non-`undefined` transposition (even if it's `0`) will then track along with the global transposition state, hopefully tracking along with the tonality of your background music.

&nbsp;

## `VinylGlobalTransposeSet`

`VinylGlobalTransposeSet(semitone)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`semitone`|number  |Number of semitones to transpose the entire system|

The pitch shift set by this function follows the Western diatonic scale with the pitch shift being calculated as `pitch = power(2, semitones/12)`.

?> Setting the global transposition will only affect [voices](Voices) that have had their transposition state set.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylGlobalTransposeGet`

`VinylGlobalTransposeGet()`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the current transposition state

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylTransposeSet`

`VinylTransposeSet(target, semitone)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name      |Datatype      |Purpose                                           |
|----------|--------------|--------------------------------------------------|
|`target`  |voice or label|The voice or label to target                      |
|`semitone`|number        |Number of semitones to transpose the entire system|

Sets the number of semitones to transpose a particular [voice](Voice) or [label](Label). A value of `0` will turn on transposition for the voice and make it sensitive to the global transposition state. The pitch shift set by this function follows the Western diatonic scale with the pitch shift being calculated as `pitch = power(2, semitones/12)`.

If a label is specified, each currently playing voice assigned to that label will have its transposition state set. The label itself has no "transposition" state and any new voices will be played without transposition.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylTransposeGet`

`VinylGlobalTransposeGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the current transposition state for the [voice](Voices)

|Name    |Datatype|Purpose  |
|--------|--------|---------|
|`target`|voice   |The voice|

?> You cannot get a transposition state from a label as they have none.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->