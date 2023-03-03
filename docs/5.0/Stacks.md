# Stacks

&nbsp;

Stacks are special logic containers that automatically manage audio clips interrupting each other.

&nbsp;

## Configuration

|Property     |Datatype|Default                                        |Notes                                                                                           |
|-------------|--------|-----------------------------------------------|------------------------------------------------------------------------------------------------|
|`ducked gain`|number  |`0`                                            |Defaults to `-60` db in [decibel mode](Config-Macros) (silence)                                 |
|`rate`       |number  |[`VINYL_DEFAULT_DUCK_GAIN_RATE`](Config-Macros)|Measured in gain units per second                                                               |
|`pause`      |boolean |`true`                                         |Whether to pause a voice when fully ducked. Must be `false` if `ducked gain` is greater than `0`|

&nbsp;

## Examples

```
{ //Start of __VinylConfig
	...
    
	stacks: { //Start of stack definitions
		
	}

	...
}
```