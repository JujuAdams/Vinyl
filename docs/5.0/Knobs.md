# Knobs

&nbsp;

Controlling properties within Vinyl during gameplay could potentially be a complicated and laborious task. To assist with dynamically changing properties in a more convenient and more robust way, Vinyl offers a way to connect what's happening in your game with properties that would otherwise be static. This is done with "knobs" - dynamic controls that update Vinyl when their input value changes.

You can connect a knob to the gain, pitch, or transposition of a label, asset, or pattern. Knobs can also control effect parameters, though a knob **cannot** control any effect parameters that require string or boolean arguments, such as tremolo shape or bypass state. A Multi pattern's blend property can also be controlled with a knob.

Knobs take a input value in a certain range and remaps it to an output value in a certain range. Typically, the output and input ranges are `0` to `1` but this [can be customised per knob](Config-File). Knobs can be set as many properties as you want, but a property may only be hooked up to one knob at a time. A knob will only change the value of a property when the input value of the knob changes.

Knobs further have a default value. This is the initial output value for the knob. The default value is an **output** value rather than a normalised input value. This means the default value is limited within the knob's output range.

You can get and set the input value for knobs using [`VinylKnobGet()` and `VinylKnobSet()`](Knobs). You can also check if a knob exists or reset a knob using other [knob functions](Knobs). Generally speaking, knob functions will not throw an exception if the knob they're targetting doesn't exist to reduce the likelihood of annoying crashes if you spell a knob name wrong.

&nbsp;

## Properties

|Property      |Datatype        |Default |Notes                                                                                                                           |
|--------------|----------------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`default`     |number          |        |**Required.** Will be clamped between inside of the output range if either the input range or output range is explicitly defined|
|`input range` |array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |
|`output range`|array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |

&nbsp;

## Examples

```
{ //Start of __VinylConfig
	...
    
	knobs: { //Start of knob definitions

	}

	...
}
```