# Playing Audio

&nbsp;

## `VinylPlay`

`VinylPlay(sound, [loop], [gain=1], [pitch=1], [pan])`

<!-- tabs:start -->

#### **Description**

*Returns:* [Voice](Voices)

|Name     |Datatype        |Purpose                                                                                                                                                              |
|---------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`  |asset or pattern|The sound to play, either an asset or a pattern                                                                                                                      |
|`[loop]` |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop             |
|`[gain]` |number          |Voice gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain)|
|`[pitch]`|number          |Voice pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                             |
|`[pan]`  |number          |Panning value, from `-1` (left) to `0` (centre) to `+1` (right). Defaults to no panning                                                                              |

Plays an [asset](Assets) or a [pattern](Glossary) with the desired settings and returns a [voice](Voices). This voice can then be used with many other Vinyl functions to manipulate and adjust the sound.

!> In the interests of managing performance, if no panning value is specified then the returned voice cannot be panned later with `VinylPanSet()`.

#### **Example**

```gml
//Play a short sound when we enter a new level
VinylPlay(sndNewLevel);

//Play some music and make sure it loops
//We keep track of the voice ID in the <music> variable for use later
music = VinylPlay(sndOverworldMusic, true);

//And play ambience too, but quietly
VinylPlay(sndAmbience, true, 0.5);

//Finally play a pitch-shifted bird cheep
//We don't want to fiddle with the default loop / gain values
VinylPlay(sndBirdCheep, undefined, undefined, 1.2);
```

<!-- tabs:end -->

&nbsp;

## `VinylPlayFadeIn`

`VinylPlayFadeIn(sound, [loop], [targetGain=1], [rate=VINYL_DEFAULT_GAIN_RATE], [pitch=1])`

<!-- tabs:start -->

#### **Description**

*Returns:* [Voice](Voices)

|Name          |Datatype        |Purpose                                                                                                                                                 |
|--------------|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`       |asset or pattern|The sound to play, either an asset or a pattern                                                                                                         |
|`[loop]`      |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop|
|`[targetGain]`|number          |Target gain, in normalised gain units                                                                                                                   |
|`[rate]`      |number          |Speed to approach the target gain, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`                                                      |
|`[pitch]`     |number          |Voice pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                |

A convenience function that starts playing an [asset](Assets) or a [pattern](Glossary) at silence and then gradually increases its gain to reach the given target.

#### **Example**

```gml
//It's time to get fighty!
VinylPlayFadeIn(sndBattleAmbience, true);

//Slowly fade in the battle music
//We want the final volume to be louder too
VinylPlayFadeIn(sndBattleMusic, true, 1.5, 0.1);
```

<!-- tabs:end -->

&nbsp;

## `VinylExists`

`VinylExists(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether the given [voice](Voice) or [label](Label) exists and has not been [stopped](Stopping-Audio)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

#### **Example**

```gml
//When the voice stored in <transitionMusic> finishes go to the next room
if (not VinylExists(transitionMusic))
{
	room_goto_next();
}
```

<!-- tabs:end -->

&nbsp;

## `VinylPlaySimple`

`VinylPlaySimple(sound, [gain=1], [pitch=1])`

<!-- tabs:start -->

#### **Description**

*Returns:* GameMaker [sound instance](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm)

|Name     |Datatype        |Purpose                                                                                                                                                                 |
|---------|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`  |asset or pattern|The sound to play, either an asset or a pattern                                                                                                                         |
|`[gain]` |number          |Instance gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain)|
|`[pitch]`|number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                             |

Plays an [asset](Assets) or a [pattern](Glossary), taking advantage of Vinyl's configuration data (including labels). However, this function does **not** create a full fat [voice](Voices) and is, in effect, only a wrapper around GameMaker's native [`audio_play_sound()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm) with a few basic properties calculated through Vinyl.

Sounds played using this function will never loop.

!> `VinylPlaySimple()` returns a GameMaker sound instance and **not** a Vinyl voice. As such, the sound instance is not compatible with any Vinyl functions and is provided for your convenience only.

#### **Example**

```gml
//Play a simple coin pickup sound, varying its pitch
VinylPlaySimple(sndCoin, 1, random_range(0.8, 1.2));
```

<!-- tabs:end -->