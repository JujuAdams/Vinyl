# Voices

&nbsp;

## Inheritance

Voices have no configuration properties because they're created on demand at runtime by calling `VinylPlay()`, `VinylPlayFadeIn()`, or `VinylPlayOnEmitter()`. They do, however, inherit properties on instantiation by drawing on values set in assets, patterns, and labels. This, regretably, is complex. I've done my best to make it clear!

|Property         |Purpose                         |
|-----------------|--------------------------------|
|Label            |                                |
|Gain             |                                |
|Pitch            |                                |
|Transpose        |                                |
|Loop             |                                |
|Effect chain     |                                |
|Stack            |                                |
|Stack priority   |                                |

&nbsp;

## Runtime State

|State            |Purpose                                                                                                        |
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
|Shutdown         |Whether the voice is fading out                                                                                |
|Pan              |Position, left-to-right, in the audio field to play the voice                                                  |
|Emitter          |Which emitter the voice is playing on                                                                          |