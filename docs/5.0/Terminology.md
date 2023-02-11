# Terminology

&nbsp;

Vinyl uses standard audio terminology where appropriate. On top of this, Vinyl has some specific concepts unique to the library.

&nbsp;

## Gain

"Gain" is, effectively, the "volume" of a sound. Where Vinyl requires a gain value to be supplied as a function argument, the gain value should from `0` to, typically, `1`.

Some professional audio designers prefer to work with decibel gain values rather than normalised gain values. By setting [`VINYL_CONFIG_DECIBEL_GAIN`](Config-Macros) to `true`, [Vinyl's configuration file](Configuration) will now use decibel values. A value of `0` db is equivalent to a normalised value of `1`, and a decibel value of `-60` db is equivalent to a normalised gain of `0` (i.e. silence).

?> The whys and wherefores of gain structure have their own page [here](Gain-Structure).

&nbsp;

## Pitch

Pitch is a multiplier applied to the frequency of the sound. A higher value makes the sound higher pitched (squeakier) and shorter, whereas a lower value makes the sound deeper and longer. Where Vinyl requires a pitch value to be supplied as a function argument, expects normalised pitch values. A pitch value of `1` indicates no change to pitch, a value of `2` indicates a doubling in pitch, and so on.

I've always found the use of normalised values for pitch confusing. By setting [`VINYL_CONFIG_PERCENTAGE_PITCH`](Config-Macros) to `true`, [Vinyl's configuration file](Configuration) will now use percentage values for pitches (functions still use normalised values, however). A value of `100` is equivalent to a normalised value of `1`, and a value of `50` db is equivalent to a normalised gain of `0.5` (i.e. half the frequency).

&nbsp;

## Asset

An asset is any [sound asset](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm) added to the GameMaker IDE. You should aim to further define properties for these assets to [Vinyl's internal configuration file](Configuration) in order to take advantage of Vinyl's features. Vinyl allows you to control the gain and pitch for assets, as well as assigning assets to labels for bulk control.

&nbsp;

## Vinyl Instance

When you play an audio asset using [one of Viny's functions](Basics), Vinyl will create a unique instance that holds information about that specific piece of audio being played.

Vinyl instances can have their gain and pitch altered on the fly, as well as their pan position. Vinyl instances can loop, and can be played at positions in a room using Vinyl's custom emitter system as well.

?> Don't confuse Vinyl instances for GameMaker's [sound instances](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm). They share some similarities but cannot be used interchangeably.

&nbsp;

## Label

Labels are how Vinyl handles groups of assets (and patterns) of similar types. An asset can be assigned to zero, one, or many labels. When properties on that label are adjusted - such as gain or pitch - those properties are applied to each asset, and further those properties are applied to each Vinyl instance assigned to the label. This means that changing e.g. the gain value on a label called `ambience` to be lower will diminish the volume of all assets assigned to that label.

You can stop all audio that's assigned to a label by using [`VinylStop()`](Basics). You can also fade out labels, set gain and pitch targets for labels etc. Labels can be interacted with in much the same way as Vinyl instances.

Labels can have a limit set on the number of concurrent instances that can be played. If the limit is exceeded, old Vinyl instances that are currently playing will be faded out. This is especially useful for handling swapping between background music tracks. You can change the parameters of label limits in Vinyl's [configuration file](Configuration).

Vinyl allows you to assign assets within the configuration file, but Vinyl can also hook into GameMaker's native asset tagging system. Labels can be configured to be automatically assigned to any sound asset that has a specific tag.

When setting up complex audio systems it's often useful to use a hierarchy to share properties from one parent label to child labels. For example, an `sfx` label might have `ui`, `footsteps`, and `explosions` labels as children. Changing properties on the parent `sfx` label will affect its child labels. Child labels can themselves have children, recursively. Label parenting can be set up in the [configuration file](Configuration).

!> GameMaker's [audio groups](https://manual.yoyogames.com/Settings/Audio_Groups.htm) are vaguely similar to labels. It is recommended to avoid using GameMaker's audio groups for anything apart from managing memory whn using Vinyl.

&nbsp;

## Pattern

There are certain common operation that crop up frequently when playing sound effects, and audio in general, in games. Vinyl patterns are a way to define behaviours that would otherwise be complex or time-consuming to construct. Vinyl patterns are played using [the standard playback functions](Basics) and return a Vinyl instance like a standard sound asset. Patterns must be set up in the [configuration file](Configuration).

### Basic

Basic patterns are effectively a copy of asset definitions but with the option to change properties independently of the source asset. This is useful for repurposing a single sound asset for multiple purposes, such as a coin pick-up sound effect pitch shifted to different values depending on whether a low value or high value coin has been collected.

### Shuffle

Plays a random sound asset from an array. Shuffle patterns also try to ensure that the same sound is not played twice in a row (in fact, shuffle patterns try to space out sounds as much as possible).

### Queue

Plays sound assets from an array one after another. If a sound asset is set to loop then the queue will hold on that looping asset until instructed to advance by calling [`VinylCue()`](Patterns). The queue itself can be set to loop, restarting the entire sequence from the start once playback reaches the end of the queue.

### Blend

Play sound assets from an array simultaneously. The blend parameter stored within the pattern can be set with [`VinylBlendSet()`](Patterns) and crossfades between assets.

!> Individual assets within a blend pattern may fall out of sync. Do not rely on this pattern for audio synchronisation.

&nbsp;

## Emitter

Building sonically convincing environments involves a lot of detailed work, not least the considered use of panning and spatial positioning. Emitters are points or regions in space that can host Vinyl instances. As the player moves towards and away from each emitter, sounds played on that emitter pan and modulate their volume accordingly. GameMaker has its own [emitter system](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Emitters/Audio_Emitters.htm) built around point emitters. Vinyl extends this basic featureset to allow for [region emitters](Positional) as well as simple [panned audio](Positional).

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

!> A sound can only be played on one effect chain at a time. As a result, the label `effect chain` property can potentially conflict with effect chain definitions in other labels if an asset is assigned to multiple labels. This is not considered a critical error by Vinyl but can lead to unexpected behaviour.

&nbsp;

## Knobs

Controlling properties within Vinyl during gameplay could potentially be a complicated and laborious task. To assist with dynamically changing properties in a more convenient and more robust way, Vinyl offers a way to connect what's happening in your game with properties that would otherwise be static. This is done with "knobs" - dynamic controls that update Vinyl when their input value changes.

You can connect a knob to the gain or pitch of a label, asset, or pattern. Knobs can also control the effect parameters, though a knob **cannot** control any effect parameters that require string or boolean arguments, such as tremolo shape or bypass state.

Knobs take a normalised input value from `0` to `1` and then emit an output value in a certain range. Typically, this range is also `0` to `1` but this [can be customised per knob](Configuration). Knobs can be set as many properties as you want, but a property may only be hooked up to one knob at a time. A knob will only change the value of a property when the input value of the knob changes.

Knobs further have a default value. This is the initial output value for the knob. The default value is an **output** value rather than a normalised input value. This means the default value is limited within the knob's output range.

You can get and set the input value for knobs using [`VinylKnobGet()` and `VinylKnobSet()`](Knobs). You can also check if a knob exists or reset a knob using other [knob functions](Knobs). Generally speaking, knob functions will not throw an exception if the knob they're targetting doesn't exist to reduce the likelihood of annoying crashes if you spell a knob name wrong.