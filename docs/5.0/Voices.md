# Voices

&nbsp;

When you play an audio asset using [`VinylPlay()`](Playing-Audio), [`VinylPlayFadeIn()`](Playing-Audio), or [`VinylPlayOnEmitter()`](Emitter-Functions), Vinyl will create a unique voice that holds information about that specific piece of audio being played.

The best way to understand a voice is to think of them like they're instances of GameMaker objects, only the "objects" in this case are Vinyl patterns.

Voices can have their gain and pitch altered on the fly, as well as their pan position. Voices can loop, and can be played at positions in a room using Vinyl's custom emitter system as well.

?> Don't confuse voices for GameMaker's [sound instances](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm). They share some similarities but cannot be used interchangeably.

&nbsp;

## Inheritance

Voices have no configuration properties because they're created on demand at runtime. They do, however, inherit properties on instantiation by drawing on values set in assets, patterns, and labels. This, regretably, is complex. I've done my best to make it clear!

### Labels

Inherited cumulatively.

### Gain

Inherited multiplicatively. See [gain documentation](Gain).

### Pitch

Inherited multiplicatively. See [pitch documentation](Pitch).

### Transpose

Inherited additively. See [transposition documentation](Transposition).

### Loop

Loop state set via `VinylPlay()` function takes precedence, otherwise the loop state on our pattern takes precedence, otherwise `true` if any of our labels are configured to loop.

### Effect Chain

Inherited from the parent voice if defined, otherwise use our own effect chain defined by our pattern.

### Stack

**Only applies to top-level voices.** Use our pattern's stack, otherwise use the first defined stack we find from our labels.

### Stack Priority

**Only applies to top-level voices.** Choose the maximum priority from our pattern and our labels.

&nbsp;

## Runtime State

The following are the state variables that a voice will track at runtime. You can modify and interact with these variables per voice. Notably missing is the effect chain that a voice is playing on as this is determined when the voice is first created for playback.

|State            |Notes                                                                                                          |
|-----------------|---------------------------------------------------------------------------------------------------------------|
|Gain             |Local gain factor for the voice. [Applied multiplicatively with other gain values](Gain)                       |
|Gain target      |Target gain for the voice                                                                                      |
|Gain change rate |Rate to approach the target gain                                                                               |
|Pitch            |Local pitch factor the voice. [Applied multiplicatively with other pitch values](Pitch)                        |
|Pitch target     |Target pitch for the voice                                                                                     |
|Pitch change rate|Rate to approach the target pitch                                                                              |
|Transposition    |Number of semitones to transpose the voice. [Applied additively with other transposition values](Transposition)|
|Loop             |Whether the voice is looping                                                                                   |
|Persistent       |Whether the voice is persistent (relevant for persistence-related functions)                                   |
|Shutdown         |Whether the voice is fading out. Set to `true` after calling [`VinylFadeOut()`](Stopping-Audio) (or equivalent)|
|Pan              |Position, left-to-right, in the audio field to play the voice                                                  |