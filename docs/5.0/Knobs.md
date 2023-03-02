# Knobs

&nbsp;

Controlling properties within Vinyl during gameplay could potentially be a complicated and laborious task. To assist with dynamically changing properties in a more convenient and more robust way, Vinyl offers a way to connect what's happening in your game with properties that would otherwise be static. This is done with "knobs" - dynamic controls that update Vinyl when their input value changes.

You can connect a knob to the gain, pitch, or transposition of a label, asset, or pattern. Knobs can also control effect parameters, though a knob **cannot** control any effect parameters that require string or boolean arguments, such as tremolo shape or bypass state. A Multi pattern's blend property can also be controlled with a knob.

Knobs take a input value in a certain range and remaps it to an output value in a certain range. Typically, the output and input ranges are `0` to `1` but this [can be customised per knob](Configuration). Knobs can be set as many properties as you want, but a property may only be hooked up to one knob at a time. A knob will only change the value of a property when the input value of the knob changes.

Knobs further have a default value. This is the initial output value for the knob. The default value is an **output** value rather than a normalised input value. This means the default value is limited within the knob's output range.

You can get and set the input value for knobs using [`VinylKnobGet()` and `VinylKnobSet()`](Knobs). You can also check if a knob exists or reset a knob using other [knob functions](Knobs). Generally speaking, knob functions will not throw an exception if the knob they're targetting doesn't exist to reduce the likelihood of annoying crashes if you spell a knob name wrong.

&nbsp;

## Configuration Properties

|Property      |Datatype        |Default |Notes                                                                                                                           |
|--------------|----------------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`default`     |number          |        |**Required.** Will be clamped between inside of the output range if either the input range or output range is explicitly defined|
|`input range` |array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |
|`output range`|array of numbers|`[0, 1]`|Must be a two-element array                                                                                                     |

&nbsp;

## `VinylKnobSet`

`VinylKnobSet(name, value)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                                  |
|-------|--------|-----------------------------------------|
|`name` |string  |Knob to target                           |
|`value`|number  |Input value for the knob, from `0` to `1`|

Sets the normalised input value of a [Vinyl knob](Terminology). This is converted into an output value using the range of the knob if necessary.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylKnobGet`

`VinylKnobGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the normalised input value of the knob

|Name  |Datatype|Purpose       |
|------|--------|--------------|
|`name`|string  |Knob to target|

If the knob has not had a value set, or the knob has been reset (see `VinylKnobReset()`), this function will return `undefined`.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylKnobTargetSet`

`VinylKnobTargetSet(name, targetValue, rate)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name         |Datatype|Purpose                                          |
|-------------|--------|-------------------------------------------------|
|`name`       |string  |Knob to target                                   |
|`targetValue`|number  |Target input value                               |
|`rate`       |number  |Speed to approach the target, in units per second|

Sets the target input value of a knob. The knob's input value will change over time at the given rate until reaching its target.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylKnobTargetGet`

`VinylKnobTargetGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the target value for the knob

|Name  |Datatype|Purpose       |
|------|--------|--------------|
|`name`|string  |Knob to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylKnobOutputGet`

`VinylKnobOutputGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the output value of the knob

|Name  |Datatype|Purpose       |
|------|--------|--------------|
|`name`|string  |Knob to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylKnobReset`

`VinylKnobReset(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name  |Datatype|Purpose       |
|------|--------|--------------|
|`name`|string  |Knob to target|

Resets the output value of a [Vinyl knob](Terminology) to the default. This also "unsets" the normalised input value.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

## `VinylKnobResetAll`

`VinylKnobResetAll(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Resets all knobs to their default value.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylKnobExists`

`VinylKnobExists(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, if a [Vinyl knob](Terminology) with the given name exists

|Name  |Datatype|Purpose       |
|------|--------|--------------|
|`name`|string  |Knob to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->