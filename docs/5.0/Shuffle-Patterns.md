# Shuffle Patterns

&nbsp;

Shuffle patterns play a random asset from an array. Shuffle patterns also try to ensure that the same asset is not played twice in a row (in fact, shuffle patterns try to space out assets as much as possible).

&nbsp;

## Configuration

<!-- tabs:start -->

#### **Properties**

|Property        |Datatype        |Default      |Notes                                                                                                      |
|----------------|----------------|-------------|-----------------------------------------------------------------------------------------------------------|
|`type`          |string          |             |**Required. Must be `shuffle`**                                                                            |
|`assets`        |array           |             |**Required.** An array of asset names as strings                                                           |
|`gain`          |number          |`1`          |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`          |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*|                                                                                                           |
|`loop`          |boolean         |*passthrough*|This property is inherited by assets played by this pattern; a Shuffle pattern cannot inherently loop      |
|`stack`         |string          |*passthrough*|                                                                                                           |
|`stack priority`|number          |`0`          |                                                                                                           |
|`effect chain`  |string          |*passthrough*|                                                                                                           |
|`label`         |string or array |*passthrough*|Label to assign this pattern to. Can be a string for a single label, or an array of label names            |
|`persistent`    |boolean         |*passthrough*|                                                                                                           |

#### **Examples**

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

<!-- tabs:end -->