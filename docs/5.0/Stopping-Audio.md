# Stopping Audio

&nbsp;

Stopping audio is a surprisingly involved process.

&nbsp;

## `VinylStop`

`VinylStop(id)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

Immediately stops playback of a Vinyl instance and marks it as destroyed.

If a label is specified, each currently playing instance assigned to that label will be immediately stopped. The label itself has no "stopped" state and any new instances will be played as normal.

&nbsp;

## `VinylStopAll`

`VinylStopAll()`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Immediately stops playback of all currently playing Vinyl instances and marks them as destroyed.

?> If you want a little more control of which instances get stopped, consider using `VinylStop()` with a [label](Terminology), or using `VinylStopAllNonPersistent()`.

&nbsp;

## `VinylFadeOut`

`VinylFadeOut(id, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                                   |
|--------|--------------|------------------------------------------------------------------------------------------|
|`id`    |Vinyl instance|Instance to target                                                                        |
|`[rate]`|number        |Speed to approach silence, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Begins a fade out for a [Vinyl instance](Terminology) or [Vinyl label](Terminology). This puts the instance into "shutdown mode" which can be detected later by [`VinylShutdownGet()`](Advanced).

If an instance is specified, the instance's gain will decrease at the given rate (in normalised gain units per second) until the gain reaches zero, at which point the sound is stopped and the instance is marked as destroyed.

If a label is specified, each currently playing instance assigned to that label will fade out. The label itself has no "fade out" state and any new instances will be played at their normal gain.

&nbsp;

## `VinylFadeOutAll`

`VinylFadeOut(id, [rate=VINYL_DEFAULT_GAIN_RATE])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name    |Datatype|Purpose                                                                                   |
|--------|--------|------------------------------------------------------------------------------------------|
|`[rate]`|number  |Speed to approach silence, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Begins a fade out for all currently playing Vinyl instances. This puts all instances into "shutdown mode" which can be detected later by [`VinylShutdownGet()`](Advanced).

?> If you want a little more control of which instances get faded out, consider using `VinylFadeOut()` with a [label](Terminology), or using `VinylFadeOutAllNonPersistent()`.

&nbsp;

## `VinylShutdownGet`

`VinylShutdownGet(id)`

&nbsp;

*Returns:* Boolean, whether a [Vinyl instance](Terminology) is in "shutdown mode"

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

&nbsp;

## `VinylStopCallbackSet`

`VinylStopCallbackSet(id, callback, [callbackData])`

&nbsp;

*Returns:* N/A (`undefined`)

|Name            |Datatype        |Purpose                                                                                                   |
|----------------|----------------|----------------------------------------------------------------------------------------------------------|
|`id`            |Vinyl instance  |Instance to target                                                                                        |
|`callback`      |method or script|Method or script to execute when the instance stops playing                                               |
|`[callbackData]`|any             |Data to be passed into the callback when the instance stops playing. If not specified, `undefined` is used|

Sets a callback for execution when the instance stops playing. This callback will be executed no matter how the instance is stopped (e.g. via a fade out, via a direct stop command, via a stack). The callback function will be given two arguments:

|Argument   |Name         |Datatype|                                                               |
|-----------|-------------|--------|---------------------------------------------------------------|
|`argument0`|Callback data|any     |The data that was defined when calling `VinylStopCallbackSet()`|
|`argument1`|Instance ID  |number  |The ID of the Vinyl instance that triggered the callback       |

&nbsp;

## `VinylStopCallbackSet`

`VinylStopCallbackGet(id)`

&nbsp;

*Returns:* Struct, containing the callback and callback data as set by `VinylStopCallbackGet()`

|Name|Datatype      |Purpose           |
|----|--------------|------------------|
|`id`|Vinyl instance|Instance to target|

The struct returned from this function contains two members variable.

|Member    |Datatype                      |Usage                                                              |
|----------|------------------------------|-------------------------------------------------------------------|
|`callback`|method, script, or `undefined`|Method or script to execute when the instance stops playing        |
|`data`    |any                           |Data to be passed into the callback when the instance stops playing|

!> The returned struct is static! Do not keep a copy of this struct as it is liable to change unexpectedly.