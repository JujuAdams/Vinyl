# Knobs

&nbsp;

Controlling properties within Vinyl during gameplay could potentially be a complicated and laborious task. To assist with dynamically changing properties in a more convenient and more robust way, Vinyl offers a way to connect what's happening in your game with properties that would otherwise be static. This is done with "knobs" - dynamic controls that update Vinyl when their input value changes.

You can connect a knob to the gain, pitch, or transposition of a label, asset, or pattern. A Multi pattern's blend property can also be controlled with a knob.

Knobs take a input value in a certain range and remaps it to an output value in a certain range. Typically, the output and input ranges are `0` to `1` but this [can be customised per knob](Config-File) and even per property (see below). Knobs can be set as many properties as you want, but a property may only be hooked up to one knob at a time. A knob will only change the value of a property when the input value of the knob changes.

Knobs further have a default value. This is the initial output value for the knob. The default value is an **output** value rather than an input value. This means the default value is limited within the knob's output range.

?> When a knob is set to its default value in reality Vinyl will calculate the appropriate input value to achieve the output value. This is important when considering how per property "array syntax" operates (see below).

You can get and set the input value for knobs using [`VinylKnobGet()` and `VinylKnobSet()`](Knob-Functions). You can also check if a knob exists or reset a knob using other [knob functions](Knob-Functions). Generally speaking, knob functions will not throw an exception if the knob they're targetting doesn't exist to reduce the likelihood of annoying crashes if you spell a knob name wrong in your configuration file.

&nbsp;

## Properties

|Property      |Datatype        |Default |Notes                                                                                                                           |
|--------------|----------------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`default`     |number          |        |**Required.** Will be clamped between inside of the output range if either the input range or output range is explicitly defined|
|`input range` |array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |
|`output range`|array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |

&nbsp;

## Implementing Knobs

Knobs must be set up in the [configuration file](Config-File). Any numerical property - so **not** a boolean and **not** a string - can be adjusted using a knob. Knobs must first be defined in the `knobs: {}` struct in the configuration file before trying to set them up for other components.

A knob can be hooked up to a property in one of two ways:

### `@knob`

This is called "direct syntax". Whatever output value the knob is emitting will be routed to the property, affecting all current and future voices that inherit the property.

```
{
	knobs: {
		bird tone: {
			//Start at no transposition
			default: 0

			//Span a full octave for both input and output
			input range: [0, 12]
			output range: [0, 12]
		}
	}

	assets: {
		sndBirdThrob: {
			transpose: @bird tone
		}

		sndBirdWorble: {
			transpose: @bird tone
		}

		sndBirdCackle: {
			transpose: @bird tone
		}
	}
}
```

### `[@knob, output min, output max]`

This is called "knob syntax". The minimum and maximum values specified will override the output range defined for the knob itself. The value set for the property is calculated by mapping the knob's **input value** to the new output range specified in the array. If you're using the default value for the knob then this will be remapped from the original output range to the new output range.

Array syntax is useful if you're using a knob to control many properties that each have their own expected ranges.

```
{
	knobs: {
		shellshock: {
			//Start at no pitch shift
			default: 1

			//Decrease pitch as knob increases in value
			output range: [1, 0.6]
		}
	}

	assets: {
		sndGunshot: {
			pitch: @shellshock
		}

		sndNPCShout: {
			//Use a different output range for NPC bark
			pitch: [@shellshock, 1, 0.9]
		}
	}
}
```
