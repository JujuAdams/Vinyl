# Basic Patterns

&nbsp;

Basic patterns are wrappers around asset definitions that allow you to further tweak audio properties. This is useful for repurposing a single sound asset for multiple purposes, such as a coin pick-up sound effect pitch shifted to different values depending on whether a low value or high value coin has been collected.

&nbsp;

## Configuration

Basic patterns should be set up in the [configuration file](Config-File).

|Property        |Datatype        |Default      |Notes                                                                                                      |
|----------------|----------------|-------------|-----------------------------------------------------------------------------------------------------------|
|`type`          |string          |             |**Required. Must be `basic`**                                                                              |
|`asset`         |string          |             |**Required.** The name of the asset to play                                                                |
|`gain`          |number          |`1`          |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`          |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*|                                                                                                           |
|`loop`          |boolean         |*passthrough*|                                                                                                           |
|`stack`         |string          |*passthrough*|[Stack](Stacks) to push voices to                                                                          |
|`stack priority`|number          |`0`          |Priority for voices when pushed to the stack above                                                         |
|`label`         |string or array |*passthrough*|Label to assign this pattern to. Can be a string for a single label, or an array of label names            |
|`persistent`    |boolean         |*passthrough*|                                                                                                           |

&nbsp;

## Examples

```
{ //Start of __VinylConfig
	...
    
	patterns: { //Start of pattern definitions
        coin small: {
        	type: basic
        	asset: sndCoin
        	transpose: -5 //Down a fifth
        }

        coin medium: {
        	type: basic
        	asset: sndCoin
        	transpose: 0 //No change, but follow global transposition
        }

        coin large: {
        	type: basic
        	asset: sndCoin
        	transpose: 7 //Up a fifth
        }

        robot npc mumble: {
        	type: basic
        	asset: sndMetalImpact
        	gain: 0.5
        	pitch: [0.7, 1.1]
        	label: speech //Repurpose this sound for use as speech
        }
	}

	...
}
```