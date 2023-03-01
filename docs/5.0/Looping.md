# Looping

&nbsp;

## `VinylLoopSet`

`VinylLoopSet(target, state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|
|`state` |boolean       |Loop state to set       |

Sets the looping state of a [voice or label](Terminology). If a voice currently has loop points enabled then turning off looping (setting state to `false`) will disable the loop points and allow the audio to play to the end

If passed a label name, every voice currently assigned to the label will individually have its loop state set. This is the same as calling `VinylLoopSet()` for each individual audio instance. The label itself does not hold a "looped" state and any new audio will not be affected by the loop state set by this function.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLoopGet`

`VinylPause(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, the loop state of the [voice](Terminology)

|Name    |Datatype|Purpose        |
|--------|--------|---------------|
|`target`|voice   |Voice to target|

?> You cannot get a "loop" state from a label as they have no independent loop state (at least not one set by `VinylLoopSet()`).


#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->