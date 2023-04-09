# Voices

&nbsp;

When you play an audio asset using [`VinylPlay()`](Playing-Audio), [`VinylPlayFadeIn()`](Playing-Audio), or [`VinylPlayOnEmitter()`](Emitter-Functions), Vinyl will create a unique voice that holds information about that specific piece of audio being played.

The best way to understand a voice is to think of them like they're instances of GameMaker objects, only the "objects" in this case are Vinyl assets (or patterns).

Voices can have their gain and pitch altered on the fly, as well as their pan position. Voices can loop, and can be played at positions in a room using Vinyl's custom emitter system as well.

?> Don't confuse voices for GameMaker's [sound instances](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm). They share some similarities but cannot be used interchangeably.

&nbsp;

## Queue/Multi Voices and Parenting 

Queue and Multi voices are special insofar that they themselves are not responsible for directly playing audio. When you play a Queue pattern, it creates a Queue voice as a parent which then manages child voices created whilst iterating through the asset array. The same thing happens for Multi pattern voices - upon creation the Multi voice creates child voices, one for each asset playing from the asset array.

The voice that gets returned from [playback functions](Playing-Audio) is always the **top-level voice**. Basic playback using assets, Basic patterns, or Shuffle patterns won't generate children, so the single voice that does get created becomes the **top-level voice**. For Queue and Multi patterns, the parent voice that creates child voices is the **top-level voice**.

?> Even though Queue and Multi instances spin up additional voices, only the top-level voice can be pushed to a stack. This prevents unexpected outcomes when using Multi patterns to play multitrack music.

Vinyl is set up so that you don't have direct control over child voices to keep things simple. All of the inheritance decisions below have been made to try to combine flexibility with an intuitive end result. Most of the time you won't need to worry about the exact parenting rules and should be able to use Vinyl's features without spending too much time thinking about the internals.

&nbsp;

## Property Inheritance

Voices have no configuration properties because they're created on demand at runtime. They do, however, inherit properties on instantiation by drawing on values set in assets, patterns, and labels. This, regretably, is complex. I've done my best to make it clear!

### Labels

A voice will use the labels defined for its [asset or pattern](Config-File). If a voice has a parent, the voice also inherits all of its parent's labels that it's not already assigned to (i.e. a voice won't inherit a label twice).

### Gain

Inherited multiplicatively between the voice, its asset/pattern, its parent, and any labels. See [gain documentation](Gain).

### Pitch

Inherited multiplicatively between the voice, its asset/pattern, its parent, and any labels. See [pitch documentation](Pitch).

### Transpose

Inherited additively between the voice, its asset/pattern, its parent, and any labels. See [transposition documentation](Transposition).

### Loop

In order of precedence, with the first rule being the highest precedence that overrides following rules:

- Loop argument set when calling [`VinylPlay()` etc.](Playing-Audio)
- Loop state of the top-level voice's pattern
- If any of the voice's labels are set to loop then loop (labels set to **not** loop are ignored)
- Otherwise, default to not looping

### Effect Chain

In order of precedence, with the first rule being the highest precedence that overrides following rules:

- Use the top-level pattern's effect chain
- Use our own asset's (or pattern's) effect chain
- Choose a label's effect chain *(If there's a conflict amongst labels then Vinyl will chose a random effect chain. Try not to let this happen!)*
- Otherwise, default to playing using the [`main` effect chain](Effect-Chains).

### Stack

?> Pushing to a stack only applies to top-level voices.

Use the asset's (or pattern's) stack, otherwise use a stack we find from our labels. *(If there's a conflict amongst labels then Vinyl will chose a random stack. Try not to let this happen!)*

### Stack Priority

?> Pushing to a stack only applies to top-level voices.

Choose the maximum priority from our pattern and our labels.

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
