# Transposition

&nbsp;

Tuning sound effects to harmonise nicely with background music is a technique that designers regularly employ to tie a game's audio together. Vinyl allows for audio to track changes in pitch per label, asset, pattern, and voice. The entire system can also have a transposition applied to it - though the global transposition state only applies to sounds that are already being transposed (even if the local resultant transposition value is `0`).

To this end, transposition can be enabled in multiple ways. A voice will inherit transposition value additively from any labels for the voice, from assets and patterns, and the per-voice transposition value can be set by calling `VinylTransposeSet()`.

Generally speaking, you'll want to set your system-wide transposition based on the background music you're playing. Any voice that has inherited a non-`undefined` transposition (even if it's `0`) will then track along with the global transposition state, hopefully tracking along with the tonality of your background music.

```
output = config
         + voice
         + parent
         + (label[0] + label[1] + ...)

if (output == undefined)
{
	output = 0
}
else
{
	output += global
}
```

`output` is the value returned by `VinylOutputPitchGet()`, which is also the actual pitch that is used to fill the audio buffer.

|Term    |Meaning                                                                                                                                                                |
|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`output`|The resultant transposition of the sound after Vinyl finishes messing with it                                                                                          |
|`config`|Set in the [configuration file](Config-File) per asset or pattern                                                                                                      |
|`voice` |Set by [`VinylTransposeSet()`. For sounds that are children of pattern voices, `voice` is inaccessible and is `undefined`                                              |
|`parent`|Set implicitly by a pattern that caused a sound to be played e.g. a Multi pattern voice is the parent of each child voice that is concurrently playing for that pattern|
|`label` |The sum of all transposition values from label that the voice is assigned to                                                                                           |
|`global`|Set by `VinylGlobalTransposeSet()`                                                                                                                                     |