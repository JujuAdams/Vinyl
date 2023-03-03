# Assets

&nbsp;

An asset is any [sound asset](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm) added to the GameMaker IDE. You can further define properties for these assets to [the configuration file](Config-File) in order to take advantage of Vinyl's features.

&nbsp;

## Configuration

<!-- tabs:start -->

#### **Properties**

|Property        |Datatype        |Default                             |Notes                                                                                                      |
|----------------|----------------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`                                 |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`                                 |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*                       |                                                                                                           |
|`bpm`           |number          |[`VINYL_DEFAULT_BPM`](Config-Macros)|                                                                                                           |
|`loop`          |boolean         |*passthrough*                       |                                                                                                           |
|`loop points`   |array of numbers|*passthrough*                       |Array must have two-elements defining the start and end point of a loop, measured in seconds               |
|`stack`         |string          |*passthrough*                       |                                                                                                           |
|`stack priority`|number          |`0`                                 |                                                                                                           |
|`effect chain`  |string          |*passthrough*                       |                                                                                                           |
|`label`         |string or array |`[]`                                |Label to assign this asset to. Can be a string for a single label, or an array of label names              |
|`persistent`    |boolean         |*passthrough*                       |                                                                                                           |

#### **Examples**

```
{ //Start of __VinylConfig
	...
    
	assets: { //Start of asset definitions

        sndGunshot: {
        	gain: 1.5 //Boom!
        }
        
        //Duplicate pitch randomisation across three different assets
        [sndFootstepGrass, sndFootstepMetal, sndFootstepWood]: {
        	pitch: [0.92, 1.08] //Vary the pitch as we're walking
        }

        sndPlayerMumble: {
        	gain: 0.9
        	label: speech //Use the "speech" label for extra control
        }

        sndMusic: {
        	loop: true
            stack: bgm //Use the background music stack
            //Stack priority defaults to 0
        }
        
        sndMusicWithLoopPoints: {
            loop: true
            loop points: [3, 33] //Loop the middle 30 seconds of the asset
            stack: bgm
            //Stack priority defaults to 0
        }
        
        sndChestJingle: {
        	stack: bgm
        	stack priority: 1 //Duck lower priority music when we're playing
        }

		sndDeath: {
			gain: 1.4
			pitch: 0.9
			effect chain: echo //Echoey for extra drama!
			label: [sfx, speech]
		}

		sndTransition: {
			gain: 0.4
			persistent: true //Don't stop this audio between rooms
		}
        
        sndXylophone: {
        	transpose: 0 //We want to track the global transposition
        	pitch: [0.98, 1.02] //Add a subtle pitch variation on top
        }
	}

	...
}
```

<!-- tabs:end -->