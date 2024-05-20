# Shuffle Patterns

&nbsp;

Shuffle patterns play a random asset from an array. Shuffle patterns also try to ensure that the same asset is not played twice in a row (in fact, shuffle patterns try to space out assets as much as possible).

&nbsp;

## Properties

Shuffle patterns should be set up in the [configuration file](Config-File).

|Property        |Datatype        |Default      |Notes                                                                                                              |
|----------------|----------------|-------------|-------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |             |**Required. Must be `shuffle`**                                                                                    |
|`assets`        |array           |             |**Required (or use `assetsWithTag`).** An array of asset names as strings                                          |
|`assetsWithTag` |string or array |             |**Required (or use `assets`).** Adds every sound asset with the given native GameMaker asset tag to the asset array|
|`gain`          |number          |`1`          |Can be a two-element array for gain variance. Defaults to `0` db in [decibel mode](Config-Macros)                  |
|`pitch`         |number or array |`1`          |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)        |
|`transpose`     |number          |*passthrough*|                                                                                                                   |
|`loop`          |boolean         |*passthrough*|This property is inherited by assets played by this pattern; a Shuffle pattern cannot inherently loop              |
|`stack`         |string          |*passthrough*|[Stack](Stacks) to push voices to                                                                                  |
|`stack priority`|number          |`0`          |Priority for voices when pushed to the stack above                                                                 |
|`effect chain`  |string          |*passthrough*|                                                                                                                   |
|`label`         |string or array |*passthrough*|Label to assign this pattern to. Can be a string for a single label, or an array of label names                    |
|`persistent`    |boolean         |*passthrough*|                                                                                                                   |

&nbsp;

## Examples

```
{ //Start of __VinylConfig
	...
    
	patterns: { //Start of pattern definitions

        enemy death: {
        	type: shuffle
        	label: [enemy, speech]
        	assets: [
                sndEnemyOw1
                sndEnemyOw2
                sndEnemyOw3
        	]
        }

        play xylophone: {
        	type: shuffle
        	label: ambience
        	transpose: 0 //Follow global transposition

        	//Choose a random note from the C Major scale
        	//... or is it A Minor?
        	assets: [
                sndXylophoneC
                sndXylophoneD
                sndXylophoneE
                sndXylophoneF
                sndXylophoneG
                sndXylophoneA
                sndXylophoneB
        	]
        }
	}

	...
}
```