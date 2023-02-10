# Positional

&nbsp;

Functions on this page relate to spatial positioning of audio, either through panning or Vinyl's custom emitters.

&nbsp;

## `VinylListenerSet`

`VinylListenerSet(x, y)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`x`      |        |                                                  |
|`y`      |        |                                                  |

Sets the listener "head" for the player. This will typically be the centre of the view or the player character's position.

&nbsp;

## `VinylPanSet`

`VinylPanSet(id, pan)`

&nbsp;

*Returns:*

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |
|`pan`    |        |                                                  |

Sets the panning position of a Vinyl instance created by `VinylPlay()`. The panning position should be a value from `-1` to `+1`, with `-1` indicating hard left and `+1` indicating hard right.

!> The target Vinyl instance must be created by the `VinylPlay()` function with a defined `pan` argument (even if that value is `0` for centred panned).

&nbsp;

## `VinylPanGet`

`VinylPanGet(id)`

&nbsp;

*Returns:* Number, the panning position for the Vinyl instance

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`id`     |        |                                                  |

This function will return a value from `-1` to `+1`, with `-1` indicating hard left and `+1` indicating hard right.

&nbsp;

## `VinylPlayOnEmitter`

`VinylPlayOnEmitter(emitter, sound, [loop], [gain=1], [pitch=1])`

&nbsp;

*Returns:* Vinyl instance

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`emitter`|        |                                                  |
|`sound`  |        |                                                  |
|`[loop]` |        |                                                  |
|`[gain]` |        |                                                  |
|`[pitch]`|        |                                                  |

Begins playback of a sound on a Vinyl emitter, as created by the functions below (`VinylEmitterPoint()` etc.). It is not possible to use this function to play sounds on a native GameMaker emitter.

&nbsp;

## `VinylEmitterPoint`

`VinylEmitterPoint(x, y)`

&nbsp;

*Returns:* Vinyl emitter, point-type

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`x`      |        |                                                  |
|`y`      |        |                                                  |

Creates an emitter at a point in your game world. This is the same behaviour as GameMaker's [native emitters](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Emitters/Audio_Emitters.htm).

!> Vinyl will automatically clean up unneeded emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

&nbsp;

## `VinylEmitterCircle`

`VinylEmitterPoint(x, y, radius)`

&nbsp;

*Returns:* Vinyl emitter, circle-type

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`x`      |        |                                                  |
|`y`      |        |                                                  |
|`radius` |        |                                                  |

Creates an emitter that occupies a circular region in your game world. This means that the listener position can be anywhere in the circle to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the circle.

!> Vinyl will automatically clean up unneeded emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

&nbsp;

## `VinylEmitterRectangle`

`VinylEmitterPoint(left, top, right, bottom)`

&nbsp;

*Returns:* Vinyl emitter, rectangle-type

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`left`   |        |                                                  |
|`top`    |        |                                                  |
|`right`  |        |                                                  |
|`bottom` |        |                                                  |

Creates an emitter that occupies a rectangular region in your game world. This means that the listener position can be anywhere in the rectangle to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the rectangle.

!> Vinyl will automatically clean up unneeded emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

&nbsp;

## `VinylEmitterFalloff`

`VinylEmitterFalloff(emitter, min, max, factor)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`emitter`|        |                                                  |
|`min`    |        |                                                  |
|`max`    |        |                                                  |
|`factor` |        |                                                  |

Sets the falloff parameters for the Vinyl emitter. For more information on falloff parameters, please see the [GameMaker documentation](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_falloff_set_model.htm) on the topic.

&nbsp;

## `VinylEmitterExists`

`VinylEmitterExists(emitter)`

&nbsp;

*Returns:* Boolean, whether the emitter exists

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`emitter`|        |                                                  |

&nbsp;

## `VinylEmitterDestroy`

`VinylEmitterDestroy(emitter)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`emitter`|        |                                                  |

Destroys the target emitter immediately.

&nbsp;

## `VinylEmitterDebugDraw`

`VinylEmitterDebugDraw(emitter)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`emitter`|        |                                                  |

Draws a debug representation of a Vinyl emitter to assist with visualising how emitters are positioned in your game world.