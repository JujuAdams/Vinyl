# Stacks

&nbsp;

Stacks are special logic containers that automatically manage voices interrupting each other. The rules that stacks obey are simple:

1. Voice are pushed onto a stack either through [configuration](Configuration-File) or by using [`VinylStackPush`](Stack-Functions)
2. Each voice played on a stack has a priority, set through [configuration](Configuration-File) or when using [`VinylStackPush`](Stack-Functions)
3. If a voice's priority is higher than all other voices in the stack then the other voices are ducked
4. If a voice's priority is equal to an existing voice's priority then the other voice is faded out and stopped
5. If a voice's priority is lower than any other voices in the stack then the voice is ducked

What exactly happens when a voice is ducked is defined by the stack configuration (see below). There are a few function that relate to stacks, and you can read about them [here](Stack-Functions).

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