# Knobs

&nbsp;

## `VinylKnobSet`

`VinylKnobSet(name, value)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                                                                   |
|-------|--------|--------------------------------------------------------------------------|
|`name` |string  |Knob to target                                                            |
|`value`|number  |Input value for the knob, clamped to the [input range](Knobs) for the knob|

Sets the input value of a knob. This value is remapped via the [input range and output range](Knobs) and then sets downstream property linked to the knob.

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

*Returns:* Number, the input value of the knob

|Name  |Datatype|Purpose       |
|------|--------|--------------|
|`name`|string  |Knob to target|

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

Resets the output value of a knob to the [default](Knobs) specified in the [configuration file](Config-File). This will also reset the input value as returned by `VinylKnobGet()`.

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

*Returns:* Boolean, if a knob with the given name exists

|Name  |Datatype|Purpose       |
|------|--------|--------------|
|`name`|string  |Knob to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->