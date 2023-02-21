# Positional

&nbsp;

Functions on this page relate to spatial positioning of audio, either through panning or Vinyl's custom emitters.

&nbsp;

## `VinylListenerSet`

`VinylListenerSet(x, y)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose                                     |
|----|--------|--------------------------------------------|
|`x` |number  |x-coordinate to set the listener position to|
|`y` |number  |y-coordinate to set the listener position to|

Sets the listener "head" for the player. This will typically be the centre of the view or the player character's position.

&nbsp;

## `VinylPanSet`

`VinylPanSet(id, pan)`

&nbsp;

*Returns:*

|Name |Datatype      |Purpose                                                        |
|-----|--------------|---------------------------------------------------------------|
|`id` |Vinyl instance|Instance to target                                             |
|`pan`|number        |Panning value, from `-1` (left) to `0` (centre) to `+1` (right)|

Sets the panning position of a Vinyl instance created by `VinylPlay()`. The panning position should be a value from `-1` to `+1`, with `-1` indicating hard left and `+1` indicating hard right.

!> The target Vinyl instance must be created by the `VinylPlay()` function with a defined `pan` argument (even if that value is `0` for centred panned).

&nbsp;

## `VinylPanGet`

`VinylPanGet(id)`

&nbsp;

*Returns:* Number, the panning position for the Vinyl instance

|Name |Datatype      |Purpose           |
|-----|--------------|------------------|
|`id` |Vinyl instance|Instance to target|

This function will return a value from `-1` to `+1`, with `-1` indicating hard left and `+1` indicating hard right.

&nbsp;

## `VinylPlayOnEmitter`

`VinylPlayOnEmitter(emitter, sound, [loop], [gain=1], [pitch=1])`

&nbsp;

*Returns:* Vinyl instance

|Name     |Datatype        |Purpose                                                                                                                                                                           |
|---------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter   |Emitter to play on. This must be a Vinyl emitter and **not** a native GameMaker emitter                                                                                           |
|`sound`  |sound or pattern|The sound to play, either a GameMaker sound or a Vinyl pattern                                                                                                                    |
|`[loop]` |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop                          |
|`[gain]` |number          |Instance gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain-Structure)|
|`[pitch]`|number          |Instance pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                                       |


Begins playback of a sound on a Vinyl emitter, as created by the functions below (`VinylEmitterPoint()` etc.). It is not possible to use this function to play sounds on a native GameMaker emitter.

&nbsp;

## `VinylEmitterPoint`

`VinylEmitterPoint(x, y)`

&nbsp;

*Returns:* Vinyl emitter, point-type

|Name|Datatype|Purpose                            |
|----|--------|-----------------------------------|
|`x` |number  |x-position to create the emitter at|
|`y` |number  |y-position to create the emitter at|

Creates an emitter at a point in your game world. This is the same behaviour as GameMaker's [native emitters](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Emitters/Audio_Emitters.htm).

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

&nbsp;

## `VinylEmitterCircle`

`VinylEmitterPoint(x, y, radius)`

&nbsp;

*Returns:* Vinyl emitter, circle-type

|Name    |Datatype|Purpose                            |
|--------|--------|-----------------------------------|
|`x`     |number  |x-position to create the emitter at|
|`y`     |number  |y-position to create the emitter at|
|`radius`|number  |Radius of the emitter              |

Creates an emitter that occupies a circular region in your game world. This means that the listener position can be anywhere in the circle to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the circle.

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

&nbsp;

## `VinylEmitterRectangle`

`VinylEmitterPoint(left, top, right, bottom)`

&nbsp;

*Returns:* Vinyl emitter, rectangle-type

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`left`   |number  |x-coordinate of the left-hand side of the emitter |
|`top`    |number  |y-coordinate of the top of the emitter            |
|`right`  |number  |x-coordinate of the right-hand side of the emitter|
|`bottom` |number  |y-coordinate of the bottom of the emitter         |

Creates an emitter that occupies a rectangular region in your game world. This means that the listener position can be anywhere in the rectangle to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the rectangle.

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

&nbsp;

## `VinylEmitterPositionSet`

`VinylEmitterPositionSet(emitter, x, y)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|
|`x`      |number       |New x-position of the centre of the emitter                                           |
|`y`      |number       |New y-position of the centre of the emitter                                           |

&nbsp;

## `VinylEmitterFalloffSet`

`VinylEmitterFalloffSet(emitter, min, max, factor)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|
|`min`    |number       |Minimum range of the emitter's falloff                                                |
|`max`    |number       |Maximum range of the emitter's falloff                                                |
|`factor` |number       |Falloff factor. Adjusts the curve of the falloff                                      |

Sets the falloff parameters for the Vinyl emitter. For more information on falloff parameters, please see the [GameMaker documentation](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_falloff_set_model.htm) on the topic.

&nbsp;

## `VinylEmitterExists`

`VinylEmitterExists(emitter)`

&nbsp;

*Returns:* Boolean, whether the emitter exists

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|

&nbsp;

## `VinylEmitterDestroy`

`VinylEmitterDestroy(emitter)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|

Destroys the target emitter immediately.

&nbsp;

## `VinylEmitterDebugDraw`

`VinylEmitterDebugDraw(emitter)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|

Draws a debug representation of a Vinyl emitter to assist with visualising how emitters are positioned in your game world.