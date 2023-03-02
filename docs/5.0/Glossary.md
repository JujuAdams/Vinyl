# Glossary

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
- [Emitters](Emitters)
- [Effect Chains](Effect-Chains)
- [Knobs](Knobs)

&nbsp;

## Asset

An asset is any [sound asset](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm) added to the GameMaker IDE. You should aim to further define properties for these assets to [Vinyl's internal configuration file](Configuration) in order to take advantage of Vinyl's features. Vinyl allows you to control the gain and pitch for assets, as well as assigning assets to labels for bulk control.

You can read in-depth information about configuring assets [here](Assets).

&nbsp;

## Pattern

There are certain common operations that crop up frequently when playing sound effects, and audio in general, in games. Vinyl patterns are a way to define behaviours that would otherwise be complex or time-consuming to construct. Vinyl patterns are played using [the standard playback functions](Playing-Audio) and return a voice similar to the way `audio_play_sound()` returns a sound instance. Patterns must be set up in the [configuration file](Configuration).

<!-- tabs:start -->

#### **Basic**

Basic patterns are effectively a copy of asset definitions but with the option to change properties independently of the source asset. This is useful for repurposing a single sound asset for multiple purposes, such as a coin pick-up sound effect pitch shifted to different values depending on whether a low value or high value coin has been collected.

You can read in-depth information about configuring basic patterns [here](Basic-Patterns).

#### **Shuffle**

Shuffle patterns play a random asset from an array. Shuffle patterns also try to ensure that the same sound is not played twice in a row (in fact, shuffle patterns try to space out sounds as much as possible).

You can read in-depth information about working with Shuffle patterns [here](Shuffle-Patterns) (both in the configuration file and at runtime).

#### **Queue**

Queue patterns play assets from an array one after another. If a sound asset is set to loop then the queue will hold on that looping asset until the voice is told to stop looping by using `VinylLoopSet()`.

The queue itself can be set to loop, restarting the entire sequence from the start once playback reaches the end of the queue.

You can read in-depth information about working with Queue patterns [here](Queue-Patterns) (both in the configuration file and at runtime).

#### **Multi**

Multi patterns play assets from an array simultaneously. The blend parameter stored within the pattern can be set with [`VinylMultiBlendSet()`](Multi-Patterns) and crossfades between assets.

You can read in-depth information about working with Multi patterns [here](Multi-Patterns) (both in the configuration file and at runtime).

<!-- tabs:end -->

&nbsp;

## Voice

When you play an audio asset using [one of Viny's functions](Playing-Audio), Vinyl will create a unique voice that holds information about that specific piece of audio being played.

The best way to understand a voice is to think of them like they're instances of GameMaker objects, only the "objects" in this case are Vinyl patterns.

Voices can have their gain and pitch altered on the fly, as well as their pan position. Voices can loop, and can be played at positions in a room using Vinyl's custom emitter system as well.

You can read in-depth information about voices [here](Voices).

?> Don't confuse voices for GameMaker's [sound instances](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm). They share some similarities but cannot be used interchangeably.

&nbsp;

## Label

Labels are how Vinyl handles groups of assets (and patterns) of similar types. An asset can be assigned to zero, one, or many labels. When properties on that label are adjusted - such as gain or pitch - those properties are applied to each asset, and further those properties are applied to each voice assigned to the label. This means that changing e.g. the gain value on a label called `ambience` to be lower will diminish the volume of all assets assigned to that label.

You can stop all audio that's assigned to a label by using [`VinylStop()`](Stopping-Audio). You can also fade out labels, set gain and pitch targets for labels etc. Labels can be interacted with in much the same way as voices.

Vinyl allows you to assign assets within the configuration file, but Vinyl can also hook into GameMaker's native asset tagging system. Labels can be configured to be automatically assigned to any sound asset that has a specific tag.

When setting up complex audio systems it's often useful to use a hierarchy to share properties from one parent label to child labels. For example, an `sfx` label might have `ui`, `footsteps`, and `explosions` labels as children. Changing properties on the parent `sfx` label will affect its child labels. Child labels can themselves have children, recursively. Label parenting can be set up in the [configuration file](Configuration).

You can read in-depth information about working with labels [here](Multi-Patterns) (both in the configuration file and at runtime).

!> GameMaker's [audio groups](https://manual.yoyogames.com/Settings/Audio_Groups.htm) are vaguely similar to labels. It is recommended to avoid using GameMaker's audio groups for anything apart from managing memory whn using Vinyl.

&nbsp;

## Emitter

Building sonically convincing environments involves a lot of detailed work, not least the considered use of panning and spatial positioning. Emitters are points or regions in space that can play voices. As the player moves towards and away from each emitter, sounds played on that emitter pan and modulate their volume accordingly. GameMaker has its own [emitter system](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Emitters/Audio_Emitters.htm) built around point emitters. Vinyl extends this basic featureset to allow for [region emitters](Emitters) as well as simple [panned audio](Panning).

You can read in-depth information about emitters [here](Emitters).

&nbsp;

## Effect Chain

Vinyl offers a streamlined version of GameMaker's native ["effect bus" system](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Effects/AudioEffect.htm) that automates much of the boilerplate code required to use dynamic audio effects, such as reverb or low-pass filters. Vinyl also allows you to live update effect parameters whilst the game is running, much like other properties in the [configuration file](Configuration).

Vinyl supports the following effects:
- Reverb (`AudioEffectType.Reverb1`)
- Delay (`AudioEffectType.Delay`)
- Bitcrusher (`AudioEffectType.Bitcrusher`)
- Low-pass filter (`AudioEffectType.LPF2`)
- High-pass filter (`AudioEffectType.HPF2`)
- Tremolo (`AudioEffectType.Tremolo`)

Assets can be set up to automatically play using effect chains in the [configuration file](Configuration).

?> When playing an asset using `VinylPlayOnEmitter()`, the effect chain will be determined by the emitter rather than the asset or label(s). You can set the effect chain to use for an emitter with `VinylEmitterEffectChain()`.

Labels can also be set up in the [configuration file](Configuration) such that any assigned assets will use a particular effect chain.

You can read in-depth information about configuring effect chains [here](Effect-Chains).

!> A sound can only be played on one effect chain at a time. As a result, the label `effect chain` property can potentially conflict with effect chain definitions in other labels if an asset is assigned to multiple labels. This is not considered a critical error by Vinyl but can lead to unexpected behaviour.

&nbsp;

## Knobs

Controlling properties within Vinyl during gameplay could potentially be a complicated and laborious task. To assist with dynamically changing properties in a more convenient and more robust way, Vinyl offers a way to connect what's happening in your game with properties that would otherwise be static. This is done with "knobs" - dynamic controls that update Vinyl when their input value changes.

You can connect a knob to the gain, pitch, or transposition of a label, asset, or pattern. Knobs can also control effect parameters, though a knob **cannot** control any effect parameters that require string or boolean arguments, such as tremolo shape or bypass state. A Multi pattern's blend property can also be controlled with a knob.

Knobs take a input value in a certain range and remaps it to an output value in a certain range. Typically, the output and input ranges are `0` to `1` but this [can be customised per knob](Configuration). Knobs can be set as many properties as you want, but a property may only be hooked up to one knob at a time. A knob will only change the value of a property when the input value of the knob changes.

Knobs further have a default value. This is the initial output value for the knob. The default value is an **output** value rather than a normalised input value. This means the default value is limited within the knob's output range.

You can get and set the input value for knobs using [`VinylKnobGet()` and `VinylKnobSet()`](Knobs). You can also check if a knob exists or reset a knob using other [knob functions](Knobs). Generally speaking, knob functions will not throw an exception if the knob they're targetting doesn't exist to reduce the likelihood of annoying crashes if you spell a knob name wrong.

You can read in-depth information about working with Knobs [here](Knobs) (both in the configuration file and at runtime).