# Persistence

&nbsp;

## `VinylPersistentSet`

`VinylPersistentSet(target, state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|
|`state` |boolean       |Loop state to set       |

Sets the persistence state of a [voice or label](Terminology).

If passed a label name, every voice currently assigned to the label will individually have its persistence state set. This is the same as calling `VinylPersistentSet()` for each individual voice. The label itself does not hold a "looped" state and any new audio will not be affected by the loop state set by this function.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPersistentSet`

`VinylPersistentGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, the persistent state of the [voice](Terminology)

|Name    |Datatype|Purpose        |
|--------|--------|---------------|
|`target`|voice   |Voice to target|

?> You cannot get a "persistent" state from a label as they have no independent persistent state (at least not one set by `VinylLoopSet()`).


#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->