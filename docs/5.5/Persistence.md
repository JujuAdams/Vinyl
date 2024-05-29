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

Sets the persistence state of a [voice](Voice) or [label](Label).

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

*Returns:* Boolean, the persistent state of the [voice](Voices)

|Name    |Datatype|Purpose        |
|--------|--------|---------------|
|`target`|voice   |Voice to target|

?> You cannot get a "persistent" state from a label as they have no independent persistent state (at least not one set by `VinylLoopSet()`).

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylStopAllNonPersistent`

`VinylStopAll()`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Immediately stops playback of all currently playing voices not set to "persistent" using `VinylPersistentSet()` and marks them as destroyed.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

## `VinylFadeOutAllNonPersistent`

`VinylFadeOut(target, [rate=VINYL_DEFAULT_GAIN_RATE])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                             |
|--------|--------------|------------------------------------------------------------------------------------|
|`target`|voice or label|Voice or label to target                                                            |
|`[rate]`|number  |Speed to approach silence, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Begins a fade out for all currently playing voices not set to "persistent" using `VinylPersistentSet()`. This puts targeted voices into "shutdown mode" which can be detected later by [`VinylShutdownGet()`](Advanced).

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->