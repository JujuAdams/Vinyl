# Knobs

&nbsp;

Functions on this page relate to [Vinyl knobs](Terminology), used to manipulate properties during gameplay.

&nbsp;

## `VinylKnobSet`

`VinylKnobSet(name, value)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                                  |
|-------|--------|-----------------------------------------|
|`name` |number  |Knob to target                           |
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
|`name`|number  |Knob to target|

If the knob has not had a value set, or the knob has been reset (see `VinylKnobReset()`), this function will return `undefined`.

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
|`name`|number  |Knob to target|

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
|`name`|number  |Knob to target|

Resets the output value of a [Vinyl knob](Terminology) to the default. This also "unsets" the normalised input value.

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
|`name`|number  |Knob to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->