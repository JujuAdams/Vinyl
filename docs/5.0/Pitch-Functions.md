# Pitch

&nbsp;

## `VinylPitchSet`

`VinylPitchSet(target, pitch)`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name    |Datatype      |Purpose                                                                 |
|--------|--------------|------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                            |
|`pitch` |number        |Voice pitch, in normalised pitch units. Defaults to `1`, no pitch change|

Sets the pitch of [voice](Voice) or [label](Label).

If a voice is specified, the voice pitch is set. This pitch is independent of, for example, label pitch and asset pitch.

If a label is specified, the pitch for the label is set. This will immediately impact all current voices assigned to that label, and will impact future voices too.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPitchGet`

`VinylPitchGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the pitch for the [voice](Voice) or [label](Label)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPitchTargetSet`

`VinylPitchTargetSet(target, pitch, [rate=VINYL_DEFAULT_PITCH_RATE])`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name    |Datatype      |Purpose                                                                                              |
|--------|--------------|-----------------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                                         |
|`pitch` |number        |Target pitch, in normalised pitch units                                                              |
|`[rate]`|number        |Speed to approach the target pitch, in pitch units per second. Defaults to `VINYL_DEFAULT_PITCH_RATE`|

Sets the target pitch of a [voice](Voice) or [label](Label). The pitch for that voice or label will change over time at the given rate until reaching its target.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPitchTargetGet`

`VinylPitchTargetGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the target pitch for the [voice](Voice) or [label](Label)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylOutputPitchGet`

`VinylOutputPitchGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the final output pitch of the [voice](Voice) or [label](Label)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->