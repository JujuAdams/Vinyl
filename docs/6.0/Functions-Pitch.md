# Pitch Functions

&nbsp;

## `VinylPitchSet`

`VinylPitchSet(target, pitch)`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name    |Datatype      |Purpose                                                                                                                       |
|--------|--------------|------------------------------------------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                                                                  |
|`pitch` |number        |Voice pitch, in normalised pitch units. Defaults to `1`, no pitch change. Applied multiplicatively with other sources of pitch|

Sets the pitch of [voice](Voice) or [label](Label).

If a voice is specified, the voice pitch is set. This pitch is independent of, for example, label pitch and asset pitch.

If a label is specified, the pitch for the label is set. This will immediately impact all current voices assigned to that label, and will impact future voices too.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->