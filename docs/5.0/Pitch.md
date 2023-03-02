# Pitch

&nbsp;

Pitch is a multiplier applied to the frequency of the sound. A higher value makes the sound higher pitched (squeakier) and shorter, whereas a lower value makes the sound deeper and longer. Where Vinyl requires a pitch value to be supplied as a function argument, expects normalised pitch values. A pitch value of `1` indicates no change to pitch, a value of `2` indicates a doubling in pitch, and so on.

Some people may find the use of normalised pitch confusing. By setting [`VINYL_CONFIG_PERCENTAGE_PITCH`](Config-Macros) to `true`, [Vinyl's configuration file](Config-File) will now use percentage values for pitches (functions still use normalised values, however). A value of `100` is equivalent to a normalised value of `1`, and a value of `50` is equivalent to a normalised gain of `0.5` (i.e. half the frequency). This hopefully eases the process of configuration pitches.

Vinyl can adjust the pitch of a sound at multiple stages in the signal path. Here's the fundamental pitch equation:

```
output = config
         * voice
         * transposition
         * parent
         * (label[0] * label[1] * ...)
```

`output` is the value returned by `VinylOutputPitchGet()`, which is also the actual pitch that is used to fill the audio buffer.

|Term           |Meaning                                                                                                                                                                                                                    |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`output`       |The resultant pitch of the sound after Vinyl finishes messing with it                                                                                                                                                      |
|`config`       |Set in the [configuration file](Config-File) per asset or pattern                                                                                                                                                          |
|`voice`        |Set on creation (by `VinylPlay()` etc.) and additionally altered by [`VinylPitchSet()` and `VinylTargetPitchSet()`](Gain). For sounds that are children of pattern voices, `voice pitch` is inaccessible and is usually `1`|
|`transposition`|The pitch contribution from [transposition](Transposition) (which has its own inheritance behaviour)                                                                                                                       |
|`parent`       |Set implicitly by a pattern that caused a sound to be played e.g. a Multi pattern voice is the parent of each child voice that is concurrently playing for that pattern                                                    |
|`label`        |Set in the [configuration file](Config-File), and additionally altered by `VinylPitchSet()` and `VinylTargetPitchSet()` when targeting a label                                                                             |