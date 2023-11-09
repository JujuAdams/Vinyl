# Emitters

&nbsp;

## `VinylListenerSet`

`VinylListenerSet(x, y)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose                                     |
|----|--------|--------------------------------------------|
|`x` |number  |x-coordinate to set the listener position to|
|`y` |number  |y-coordinate to set the listener position to|

Sets the listener "head" for the player. This will typically be the centre of the view or the player character's position.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylListenerGet`

`VinylListenerGet()`

<!-- tabs:start -->

#### **Description**

*Returns:* Struct

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This function returns a struct that contains the following member variables:

|Name|Datatype|Purpose                                                |
|----|--------|-------------------------------------------------------|
|`.x` |number  |x-coordinate the listener position is currently set to|
|`.y` |number  |y-coordinate the listener position is currently set to|

!> The struct returned from this function is static. Do not keep a reference to the struct as it is liable to change unexpectedly.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylPlayOnEmitter`

`VinylPlayOnEmitter(emitter, sound, [loop], [gain=1], [pitch=1])`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice

|Name     |Datatype        |Purpose                                                                                                                                                              |
|---------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter   |Emitter to play on. This must be a Vinyl emitter and **not** a native GameMaker emitter                                                                              |
|`sound`  |asset or pattern|The sound to play, either an asset or a pattern                                                                                                                      |
|`[loop]` |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop             |
|`[gain]` |number          |Voice gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain)|
|`[pitch]`|number          |Voice pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                             |

Begins playback of a sound on a Vinyl emitter, as created by the functions below (`VinylEmitterPoint()` etc.). It is not possible to use this function to play sounds on a native GameMaker emitter.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterPoint`

`VinylEmitterPoint(x, y)`

<!-- tabs:start -->

#### **Description**

*Returns:* Vinyl emitter, point-type

|Name|Datatype|Purpose                            |
|----|--------|-----------------------------------|
|`x` |number  |x-position to create the emitter at|
|`y` |number  |y-position to create the emitter at|

Creates an emitter at a point in your game world. This is the same behaviour as GameMaker's [native emitters](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Emitters/Audio_Emitters.htm).

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterCircle`

`VinylEmitterPoint(x, y, radius)`

<!-- tabs:start -->

#### **Description**

*Returns:* Vinyl emitter, circle-type

|Name    |Datatype|Purpose                            |
|--------|--------|-----------------------------------|
|`x`     |number  |x-position to create the emitter at|
|`y`     |number  |y-position to create the emitter at|
|`radius`|number  |Radius of the emitter              |

Creates an emitter that occupies a circular region in your game world. This means that the listener position can be anywhere in the circle to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the circle.

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterRectangle`

`VinylEmitterPoint(left, top, right, bottom)`

<!-- tabs:start -->

#### **Description**

*Returns:* Vinyl emitter, rectangle-type

|Name     |Datatype|Purpose                                           |
|---------|--------|--------------------------------------------------|
|`left`   |number  |x-coordinate of the left-hand side of the emitter |
|`top`    |number  |y-coordinate of the top of the emitter            |
|`right`  |number  |x-coordinate of the right-hand side of the emitter|
|`bottom` |number  |y-coordinate of the bottom of the emitter         |

Creates an emitter that occupies a rectangular region in your game world. This means that the listener position can be anywhere in the rectangle to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the rectangle.

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterPolyline`

`VinylEmitterPolyline(radius, pointArray/path)`

<!-- tabs:start -->

#### **Description**

*Returns:* Vinyl emitter, polyline-type

|Name             |Datatype     |Purpose                                                                               |
|-----------------|-------------|--------------------------------------------------------------------------------------|
|`radius`         |number       |Radius of the emitter                                                                 |
|`pointArray/path`|array or path|Array of sequential coordinate pairs defining the polyline, or a GameMaker native path|

Creates an emitter that's defined by a polyline (a.k.a. line strip). The polyline has a "thickness" determined by the `radius` argument. This means that the listener position can be anywhere within the thickness of the polyline to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the thickness of the polyline. The "position" of the polyline is determined by the centre of the axis-aligned bounding box that encloses the polyline.

You can alternatively define the vertices on the polyline by using a native GameMaker patch. This function does not support curved paths, however.

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterPolygon`

`VinylEmitterPolygon(radius, pointArray/path)`

<!-- tabs:start -->

#### **Description**

*Returns:* Vinyl emitter, polygon-type

|Name             |Datatype     |Purpose                                                                              |
|-----------------|-------------|-------------------------------------------------------------------------------------|
|`radius`         |number       |Radius of the emitter                                                                |
|`pointArray/path`|array or path|Array of sequential coordinate pairs defining the polygon, or a GameMaker native path|

Creates an emitter that occupies a polygonal region in your game world. This means that the listener position can be anywhere in the polygon to hear sound played on the emitter at full volume at centred in the stereo field, and panning and falloff only occurs when the listener is outside the polygon. The "position" of the polygon is determined by the centre of the axis-aligned bounding box that encloses the polygon.

You can alternatively define the vertices on the polygon by using a native GameMaker patch. This function does not support curved paths, however.

!> Vinyl will automatically clean up orphaned emitters for you, but you should keep a reference to the created emitter and destroy it when it's no longer needed with `VinylEmitterDestroy()` to keep control over how and when that clean up occurs.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterPositionSet`

`VinylEmitterPositionSet(emitter, x, y)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|
|`x`      |number       |New x-position of the centre of the emitter                                           |
|`y`      |number       |New y-position of the centre of the emitter                                           |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterPositionGet`

`VinylEmitterPositionSet(emitter)`

<!-- tabs:start -->

#### **Description**

*Returns:* Struct, the position of the emitter

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|

The struct returned by this function contains two variables, `x` and `y`, giving the position of the emitter.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterFalloffSet`

`VinylEmitterFalloffSet(emitter, min, max, factor)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|
|`min`    |number       |Minimum range of the emitter's falloff                                                |
|`max`    |number       |Maximum range of the emitter's falloff                                                |
|`factor` |number       |Falloff factor. Adjusts the curve of the falloff                                      |

Sets the falloff parameters for the Vinyl emitter. For more information on falloff parameters, please see the [GameMaker documentation](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_falloff_set_model.htm) on the topic.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterExists`

`VinylEmitterExists(emitter)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether the emitter exists

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterDestroy`

`VinylEmitterDestroy(emitter)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|

Destroys the target emitter immediately.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylEmitterDebugDraw`

`VinylEmitterDebugDraw(emitter)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name     |Datatype     |Purpose                                                                               |
|---------|-------------|--------------------------------------------------------------------------------------|
|`emitter`|Vinyl emitter|Emitter to target. This must be a Vinyl emitter and **not** a native GameMaker emitter|

Draws a debug representation of a Vinyl emitter to assist with visualising how emitters are positioned in your game world.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->