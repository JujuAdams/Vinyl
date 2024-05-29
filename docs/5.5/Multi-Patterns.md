# Multi Patterns

&nbsp;

Multi patterns play assets from an array simultaneously. This can be used to create musical arrangement made of many independent parts that can be faded in and out individually, or to smoothly transition between different ambiences depending on time of day.

The blend parameter for voices played from Multi patterns can be set with [`VinylMultiBlendSet()`](Multi-Pattern-Functions) and crossfades between assets. If `blend curve` is not defined, these crossfades will be linear and one voice will fade out as the next voice fades in. If `blend curve` is defined then the relative gains of voices will be derived from the animation curve. Each channel in the animation curve is linked to each asset defined for the Multi pattern. If no channel exists for an asset in the Multi pattern then the gain of that asset will be set to 0 when played.

?> Animation curves used for Multi patterns are live updated by Vinyl and any changes made to animation curves in the IDE will be reflected at runtime.

&nbsp;

## Configuration

Multi patterns should be set up in the [configuration file](Config-File).

|Property        |Datatype        |Default                                     |Notes                                                                                                              |
|----------------|----------------|--------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |                                            |**Required. Must be `multi`**                                                                                      |
|`assets`        |array           |                                            |**Required (or use `assetsWithTag`).** An array of asset names as strings                                          |
|`assetsWithTag` |string or array |                                            |**Required (or use `assets`).** Adds every sound asset with the given native GameMaker asset tag to the asset array|
|`gain`          |number          |`1`                                         |Can be a two-element array for gain variance. Defaults to `0` db in [decibel mode](Config-Macros)                  |
|`pitch`         |number or array |`1`                                         |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)        |
|`transpose`     |number          |*passthrough*                               |                                                                                                                   |
|`loop`          |boolean         |*passthrough*                               |This property is inherited by assets played by this pattern; a Multi pattern cannot inherently loop                |
|`stack`         |string          |*passthrough*                               |[Stack](Stacks) to push voices to                                                                                  |
|`stack priority`|number          |`0`                                         |Priority for voices when pushed to the stack above                                                                 |
|`effect chain`  |string          |*passthrough*                               |                                                                                                                   |
|`label`         |string or array |*passthrough*                               |Label to assign this pattern to. Can be a string for a single label, or an array of label names                    |
|`persistent`    |boolean         |*passthrough*                               |                                                                                                                   |
|`sync`          |boolean         |[`VINYL_DEFAULT_MULTI_SYNC`](Config-Macros) |                                                                                                                   |
|`blend`         |number          |[`VINYL_DEFAULT_MULTI_BLEND`](Config-Macros)|This is a normalised value from `0` to `1` (inclusive)                                                             |
|`blend curve`   |string          |`undefined`                                 |Animation curve to use If not defined, linear crossfades are used                                                  |

&nbsp;

## Examples

```
{ //Start of __VinylConfig
	...
    
	patterns: { //Start of pattern definitions

        ambience: {
        	type: multi
        	loop: true
        	assets: [
                sndAmbienceDay
                sndAmbienceNight
        	]
        }

		synced music: {
			type: multi
			loop: true
			sync: true //Ensure each subvoice stays in time with each other
			assets: [ //Array of music stems to play together
			    sndMusicGong
                sndMusicDulcimer
                sndMusicPiccoloBass
                sndMusicMutedTrumpet
			]
		}

		machinery clank: {
			type: multi

			//Start with the blend factor playing at distance
			blend: 0

			//Use this curve to mix together different sounds
			//acClankMultiWeights should be added to the project as a normal animation curve
			blend curve: acClankMultiWeights

			assets: [
                sndClankDistant
                sndClankNearby
                sndClankClose
			]
		}
	}

	...
}
```

<!-- tabs:end -->