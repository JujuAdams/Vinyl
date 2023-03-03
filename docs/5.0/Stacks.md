# Stacks

&nbsp;

Stacks are special logic containers that automatically manage voices interrupting each other.

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

		basic stack: {} //Use a blank struct to use the default settings

		slow fade: {
			rate: 0.05 //Reaaaally slow fade
		}

		shallow duck: {
			ducked gain: 0.4 //Don't duck all the way
			rate: 1.4        //Faster rate
		}
	}

	...
}
```