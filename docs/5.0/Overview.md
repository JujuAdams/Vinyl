# Overview

&nbsp;

Vinyl uses standard audio terminology where appropriate. On top of this, Vinyl has some specific concepts unique to the library.

You can read in-depth information for different terms here:
- [Assets](Assets)
- [Basic Patterns](Basic-Patterns)
- [Shuffle Patterns](Shuffle-Patterns)
- [Queue Patterns](Queue-Patterns)
- [Multi Patterns](Multi-Patterns)
- [Voices](Voices)
- [Labels](Labels)
- [Stacks](Stacks)
- [Emitters](Emitters)
- [Effect Chains](Effect-Chains)
- [Knobs](Knobs)

&nbsp;

## Asset

[In-depth documentation](Assets)

An asset is any [sound asset](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm) added to the GameMaker IDE. You should aim to further define properties for these assets to [Vinyl's internal configuration file](Config-File) in order to take advantage of Vinyl's features. Vinyl allows you to control the gain and pitch for assets, as well as assigning assets to labels for bulk control.

&nbsp;

## Pattern

There are certain common operations that crop up frequently when playing sound effects, and audio in general, in games. Vinyl patterns are a way to define behaviours that would otherwise be complex or time-consuming to construct. Vinyl patterns are played using [the standard playback functions](Playing-Audio) and return a voice similar to the way `audio_play_sound()` returns a sound instance. Patterns must be set up in the [configuration file](Config-File).

<!-- tabs:start -->

#### **Basic**

[In-depth documentation](Basic-Patterns)

Basic patterns are effectively a copy of asset definitions but with the option to change properties independently of the source asset. This is useful for repurposing a single sound asset for multiple purposes, such as a coin pick-up sound effect pitch shifted to different values depending on whether a low value or high value coin has been collected.

#### **Shuffle**

[In-depth documentation](Shuffle-Patterns)

Shuffle patterns play a random asset from an array. Shuffle patterns also try to ensure that the same sound is not played twice in a row (in fact, shuffle patterns try to space out sounds as much as possible).

#### **Queue**

[In-depth documentation](Queue-Patterns)

Queue patterns play assets from an array one after another. If a sound asset is set to loop then the queue will hold on that looping asset until the voice is told to stop looping by using `VinylLoopSet()`.

The queue itself can be set to loop, restarting the entire sequence from the start once playback reaches the end of the queue.

#### **Multi**

[In-depth documentation](Multi-Patterns)

Multi patterns play assets from an array simultaneously. The blend parameter stored within the pattern can be set with [`VinylMultiBlendSet()`](Multi-Patterns) and crossfades between assets.

<!-- tabs:end -->

&nbsp;

## Voice

[In-depth documentation](Voices)

When you play an audio asset using [one of Viny's functions](Playing-Audio), Vinyl will create a unique voice that holds information about that specific piece of audio being played.

The best way to understand a voice is to think of them like they're instances of GameMaker objects, only the "objects" in this case are Vinyl patterns.

Voices can have their gain and pitch altered on the fly, as well as their pan position. Voices can loop, and can be played at positions in a room using Vinyl's custom emitter system as well.

?> Don't confuse voices for GameMaker's [sound instances](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm). They share some similarities but cannot be used interchangeably.

&nbsp;

## Label

[In-depth documentation](Labels)

Labels are how Vinyl handles groups of assets (and patterns) of similar types. An asset can be assigned to zero, one, or many labels. When properties on that label are adjusted - such as gain or pitch - those properties are applied to each asset, and further those properties are applied to each voice assigned to the label. This means that changing e.g. the gain value on a label called `ambience` to be lower will diminish the volume of all assets assigned to that label.

Vinyl allows you to assign assets within the configuration file, but Vinyl can also hook into GameMaker's native asset tagging system. Labels can be configured to be automatically assigned to any sound asset that has a specific tag.

!> GameMaker's [audio groups](https://manual.yoyogames.com/Settings/Audio_Groups.htm) are vaguely similar to labels. It is recommended to avoid using GameMaker's audio groups for anything apart from managing memory whn using Vinyl.

&nbsp;

## Emitter

[In-depth documentation](Emitters)

Building sonically convincing environments involves a lot of detailed work, not least the considered use of panning and spatial positioning. Emitters are points or regions in space that can play voices. As the player moves towards and away from each emitter, sounds played on that emitter pan and modulate their volume accordingly. GameMaker has its own [emitter system](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Emitters/Audio_Emitters.htm) built around point emitters. Vinyl extends this basic featureset to allow for [region emitters](Emitters) as well as simple [panned audio](Panning).

&nbsp;

## Effect Chain

[In-depth documentation](Effect-Chains)

Vinyl offers a streamlined version of GameMaker's native ["effect bus" system](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Effects/AudioEffect.htm) that automates much of the boilerplate code required to use dynamic audio effects, such as reverb or low-pass filters. Vinyl also allows you to live update effect parameters whilst the game is running, much like other properties in the [configuration file](Config-File).

Vinyl supports the following effects:
- Reverb (`AudioEffectType.Reverb1`)
- Delay (`AudioEffectType.Delay`)
- Bitcrusher (`AudioEffectType.Bitcrusher`)
- Low-pass filter (`AudioEffectType.LPF2`)
- High-pass filter (`AudioEffectType.HPF2`)
- Tremolo (`AudioEffectType.Tremolo`)

Assets can be set up to automatically play using effect chains in the [configuration file](Config-File). Labels can also be set up in the [configuration file](Config-File) such that any assigned assets will use a particular effect chain.

?> When playing an asset using `VinylPlayOnEmitter()`, the effect chain will be determined by the emitter rather than the asset or label(s). You can set the effect chain to use for an emitter with `VinylEmitterEffectChain()`.

!> A sound can only be played on one effect chain at a time. As a result, the label `effect chain` property can potentially conflict with effect chain definitions in other labels if an asset is assigned to multiple labels. This is not considered a critical error by Vinyl but can lead to unexpected behaviour.

&nbsp;

## Knobs

[In-depth documentation](Knobs)

Controlling properties within Vinyl during gameplay could potentially be a complicated and laborious task. To assist with dynamically changing properties in a more convenient and more robust way, Vinyl offers a way to connect what's happening in your game with properties that would otherwise be static. This is done with "knobs" - dynamic controls that update Vinyl when their input value changes.
