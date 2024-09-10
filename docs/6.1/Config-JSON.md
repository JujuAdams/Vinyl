# Configuration JSON

&nbsp;

## Introduction and Simple Examples

Vinyl can import and export JSON which represents the audio setup for your game. You can define JSON that Vinyl should import on boot by editing `__VinylConfigJSON()`. You can also manually import JSON with `VinylSetupImportJSON()` and `VinylSetupExportJSON()` exports a JSON representation of the current configuration if you want to connect Vinyl to external tooling.

JSON import and export is not essential to using Vinyl and is offered as a way to more easily set up live editing. If you don't want to use JSON, you can use the `VinylSetup*()` functions without any loss in functionality (internally, Vinyl JSON executes `VinylSetup*()` functions anyway).

Vinyl JSON can define mixes, sound properties, and patterns. The root of a Vinyl JSON should be an array. This array should contain structs with each struct being a definition for a mix, a sound, or a pattern. Sound and pattern definitions are "leaf nodes" insofar that they contain no deeper definitions. However, mix definition structs can further contain definitions for sounds and patterns.

Here is an example of a simple Vinyl JSON:

```
[
    {
        "sound": "sndCat",
        "gain": 2
    },
    {
        "sound": "sndBleep1",
        "pitch": 0.6,
    },
    {
        "shuffle": "Footsteps",
        "pitch": [0.9, 1.1],
        "sounds": ["sndFootstep0", "sndFootstep1", "sndFootstep2", "sndFootstep3"]
    }
}
```

In this JSON we see three Vinyl definitions. Two of these resources are sound assets that have been imported to the project's IDE, they are called `sndBleep1` and `sndCat`. `sndCat` is defined to play with a gain of 2 (200% of the original amplitude). sndBleep is defined to play with a pitch of 0.6 (60% of the original pitch). There is additionally a definition for a shuffle pattern called `"Footsteps"`. When played, this pattern will vary the pitch of playback between 90% and 110% and will choose a sound to play from a selection (`sndFootstep0`, `sndFootstep1`, `sndFootstep2`, and `sndFootstep3`).

Sound and patterns definitions can be assigned to a mix by creating a mix definition and placing the sound/pattern definition inside the mix struct. Any sound or pattern not placed inside a mix struct will be assigned to the value of the config macro `VINYL_DEFAULT_MIX` (out of the box, this macro is set to `VINYL_NO_MIX`).

Here is an example of a mix JSON definition:

```
[
    {
        "mix": "music",
        "baseGain": 1.1,
        "members": [
            {
                "sound": "sndOverworld"
            },
            {
                "sound": "sndBossFight"
            }
        ]
    },
    {
        "sound": "sndWarning",
        "pitch": [0.8, 1.2]
    }
]
```

In this JSON we see four Vinyl definitions: three sounds and one mix. Two of these sounds, `"sndOverworld"` and `"sndBossFight"` are assigned to the `"music"` mix. The `"music"` mix has a slight gain boost of 1.1 so that sounds assigned to this mix are played slightly louder. The third sound is not placed inside a mix definition therefore it is assigned to the default mix.

&nbsp;

# Definition Types

## Sounds

|Property  |Datatype        |Default    |Notes                                                                                                      |
|----------|----------------|-----------|-----------------------------------------------------------------------------------------------------------|
|`sound`   |string or sound |N/A        |**Required.** Should be a sound resource, or the name of a sound resource as a string                      |
|`gain`    |number          |`1`        |                                                                                                           |
|`pitch`   |number          |`1`        |                                                                                                           |
|`loop`    |boolean         |`undefined`|Can inherit from a mix if set to `undefined` and the mix has `.membersLoop` set to either `true` or `false`|
|`duckOn`  |string          |`undefined`|[Ducker](Ducker) to push voices to                                                                         |
|`duckPrio`|number          |`0`        |Priority for voices when pushed to the ducker above                                                        |
|`metadata`|any             |`undefined`|Returned by `VinylGetMetadata()`                                                                           |

Sets up a sound asset for playback with Vinyl. Any sound asset without a Vinyl definition will be played at a gain of 1, without any pitch shifting, and on the default mix.

&nbsp;

## Shuffle

|Property  |Datatype               |Default    |Notes                                                                                                      |
|----------|-----------------------|-----------|-----------------------------------------------------------------------------------------------------------|
|`shuffle` |string                 |N/A        |**Required.** Name of the shuffle pattern                                                                  |
|`sounds`  |array, sound, or string|N/A        |**Required.** Sounds to play                                                                               |
|`gain`    |number or array        |`1`        |Can be a two-element array for gain variance                                                               |
|`pitch`   |number or array        |`1`        |Can be a two-element array for pitch variance                                                              |
|`loop`    |boolean                |`undefined`|Can inherit from a mix if set to `undefined` and the mix has `.membersLoop` set to either `true` or `false`|
|`duckOn`  |string                 |`undefined`|[Ducker](Ducker) to push voices to                                                                         |
|`duckPrio`|number                 |`0`        |Priority for voices when pushed to the ducker above                                                        |
|`metadata`|any                    |`undefined`|Returned by `VinylGetMetadata()`                                                                           |

Sets up a shuffle pattern for playback with Vinyl. When played, a shuffle pattern will randomly choose a sound from an array of sounds when played.

&nbsp;

## Head-Loop-Tail

You can read more about head-loop-tail patterns [here](Head-Loop-Tail-Patterns).

|Property  |Datatype       |Default    |Notes                                                                              |
|----------|---------------|-----------|-----------------------------------------------------------------------------------|
|`hlt`     |string         |N/A        |**Required.** Name of the head-loop-tail pattern                                   |
|`head`    |sound or string|`undefined`|First sound to play                                                                |
|`loop`    |sound or string|N/A        |**Required.** Sound to loop until `VinylSetLoop()` is called                       |
|`tail`    |sound or string|`undefined`|Final sound to play, after the `loop` sound is set to not loop via `VinylSetLoop()`|
|`gain`    |number         |`1`        |                                                                                   |
|`duckOn`  |string         |`undefined`|[Ducker](Ducker) to push voices to                                                 |
|`duckPrio`|number         |`0`        |Priority for voices when pushed to the ducker above                                |
|`metadata`|any            |`undefined`|Returned by `VinylGetMetadata()`                                                   |

Sets up a head-loop-tail pattern for playback with Vinyl. When played, an HLT pattern will first play the "head" sound. Once that sound has finished, the loop sound will be played. If `VinylSetLoop()` is called on the HLT voice to stop looping then the tail sound will be played after the loop sound has finished.

&nbsp;

## Blend

|Property   |Datatype       |Default    |Notes                                                                                                      |
|-----------|---------------|-----------|-----------------------------------------------------------------------------------------------------------|
|`blend`    |string         |N/A        |**Required.** Name of the blend pattern                                                                    |
|`sounds`   |array          |N/A        |**Required.** Sounds to play                                                                               |
|`gain`     |number         |`1`        |                                                                                                           |
|`loop`     |boolean        |`undefined`|Can inherit from a mix if set to `undefined` and the mix has `.membersLoop` set to either `true` or `false`|
|`animCurve`|animation curve|`undefined`|                                                                                                           |
|`duckOn`   |string         |`undefined`|[Ducker](Ducker) to push voices to                                                                         |
|`duckPrio` |number         |`0`        |Priority for voices when pushed to the ducker above                                                        |
|`metadata` |any            |`undefined`|Returned by `VinylGetMetadata()`                                                                           |

Sets up a blend pattern for playback with Vinyl. When played, a blend pattern will play multiple sounds whose balance can be adjusted by setting the blend factor with the `VinylSetBlendFactor()` and `VinylSetBlendAnimCurve()` functions.

&nbsp;

## Mixes

?> Mixes cannot be children of other mixes i.e. there are no hierarchical mixes.

|Property       |Datatype|Default    |Notes                                                                         |
|---------------|--------|-----------|------------------------------------------------------------------------------|
|`mix`          |string  |N/A        |**Required.** Name of the mix                                                 |
|`baseGain`     |number  |`1`        |                                                                              |
|`membersLoop`  |number  |`undefined`|Will override loop settings for members whose loop value is set to `undefined`|
|`membersDuckOn`|string  |`undefined`|Will override ducker settings for members whose ducker is set to `undefined`  |
|`members`      |array   |empty      |                                                                              |
|`metadata`     |any     |`undefined`|Returned by `VinylGetMetadata()`                                              |
 
Sets up a mix that can be used to control multiple sounds, patterns, and voices all at the same time. Mixes should be defined before sounds and patterns.

&nbsp;

## Duckers

|Property               |Datatype|Default|Notes                                                                            |
|-----------------------|--------|-------|---------------------------------------------------------------------------------|
|`ducker`               |string  |N/A    |**Required.** Name of the ducker                                                 |
|`duckedGain`           |number  |`0`    |Gain value to set for voices that are ducked                                     |
|`rateOfChange`         |number  |`1`    |Measured in gain units per second                                                |
|`samePriorityInterrupt`|boolean |`true` |Whether sounds of the same priority will interrupt (fade out and stop) each other|

Sets up a ducker that can be used to control dynamically control the gain of sounds depending on their priority relative to the currently playing sound.

If the `samePriorityInterrupt` parameter is set to `true` (the default) then the following behaviour will occur:

- Incoming audio with a lower priority will have its gain reduced
- Incoming audio with the same priority will fade out the old audio and replace it
- Incoming audio with a higher priority will reduce the gain of the old audio

If the `samePriorityInterrupt` parameter is set to `false` then the following behaviour will occur:

- Incoming audio with a lower priority will have its gain reduced
- Incoming audio with the same priority will play as normal
- Incoming audio with a higher priority will reduce the gain of the old audio

Regardless, when a sound stops playing, sounds with a lower priority (if any exist) will have their gain increased.

&nbsp;

## Metadata

|Property  |Datatype|Default|Notes                                                 |
|----------|--------|-------|------------------------------------------------------|
|`metadata`|string  |N/A    |**Required.** Name of the metadata                    |
|`data`    |string  |N/A    |**Required.** Data to associate with the metadata name|

Sets a global metadata value inside Vinyl. This value isn't used by Vinyl but can be helpful to add extra rules or behaviours to audio playback.