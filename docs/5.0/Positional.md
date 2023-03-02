# Panning

&nbsp;

## `VinylPanSet`

`VinylPanSet(target, pan)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype|Purpose                                                        |
|--------|--------|---------------------------------------------------------------|
|`target`|voice   |The voice to target                                            |
|`pan`   |number  |Panning value, from `-1` (left) to `0` (centre) to `+1` (right)|

Sets the panning position of a voice created by `VinylPlay()`. The panning position should be a value from `-1` to `+1`, with `-1` indicating hard left and `+1` indicating hard right.

!> The target voice must be created by the `VinylPlay()` function with a defined `pan` argument (even if that value is `0` for centred panned).

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPanGet`

`VinylPanGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the panning position for the voice

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

This function will return a value from `-1` to `+1`, with `-1` indicating hard left and `+1` indicating hard right.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->