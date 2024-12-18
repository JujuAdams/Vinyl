# Queue Functions

&nbsp;

## `VinylQueueCreate`

`VinylQueueCreate(behaviour, loopQueue, [gain=1], [emitter])`

<!-- tabs:start -->

#### **Description**

*Returns:* Queue voice

|Name          |Datatype          |Purpose                                                                        |
|--------------|------------------|-------------------------------------------------------------------------------|
|`behaviour`   |`VINYL_QUEUE` enum|Behaviour to use for the queue, see below                                      |
|`loopQueue`   |boolean           |Whether to loop the queue by pushing stopping sounds to the bottom of the queue|
|`[gain]`      |number            |Local gain to set for the queue                                                |
|`[emitter]`   |GameMaker emitter |GameMaker emitter to play sounds on                                            |
|`[fadeInRate]`|number            |Rate of change for the gain during the fade in of the queue as a whole. Defaults to `infinity`, playing the audio without a fade in|

Create a new sound queue. A sound queue is used to play audio in a particular sequence which is useful to set up dynamic soundtracks, in-game radio stations etc.  This function returns a queue index which can be used like the voice index returned by `VinylPlay()`. This means you can call `VinylFadeOut()`, `VinylPause()`, `VinylSetGain()` etc. targeting a queue and the queue will behave appropriately.

There are three behaviours that a sound queue can use, found in `VINYL_QUEUE` enum:

|Enum Member    |Value|Behaviour                                                              |
|---------------|-----|-----------------------------------------------------------------------|
|`.DONT_LOOP`   |`0`  |Play each sound in the queue once                                      |
|`.LOOP_ON_LAST`|`1`  |Play each sound in the queue once until the last sound, which is looped|
|`.LOOP_EACH`   |`2`  |Loop each sound                                                        |

The currently playing sound can be manually set to loop or not loop by calling `VinylSetLoop()` targeting the queue. If a sound is not looping and completes playing then the next sound in the queue will be played.

?> If you push a new sound to a `.LOOP_ON_LAST` queue Vinyl will **not** automatically set a currently looping sound to stop looping. You will need to call `VinylSetLoop(..., false)` to stop a loop in all cases.

The queue itself can be set to loop as well. Internally this is achieved by pushing stopping sounds to the bottom of the queue. A queue that is itself set to loop will never trigger `.LOOP_ON_LAST`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueCreateFromTemplate`

`VinylQueueCreateFromTemplate(queueTemplateName, [gain=1], [emitter], [fadeInRate=infinity])`

<!-- tabs:start -->

#### **Description**

*Returns:* Queue voice

|Name               |Datatype         |Purpose                                                                        |
|-------------------|-----------------|-------------------------------------------------------------------------------|
|`queueTemplateName`|string           |Name of the template to use                                                    |
|`[gain]`           |number           |Local gain to set for the queue                                                |
|`[emitter]`        |GameMaker emitter|GameMaker emitter to play sounds on                                            |
|`[fadeInRate]`     |number           |Rate of change for the gain during the fade in of the queue as a whole. Defaults to `infinity`, playing the audio without a fade in|

Create a new sound queue using parameters previously defined by a queue template, either in the [Config JSON](Config-JSON?id=queue-template) or by using the `VinylSetupQueueTemplate()` function. The `emitter` parameter for this function, if specified, will override the emitter defined in the queue template.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueSetBehaviour`

`VinylQueueSetBehaviour(voice, behaviour, [setForPlaying=true])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name             |Datatype          |Purpose                                                                                                             |
|-----------------|------------------|--------------------------------------------------------------------------------------------------------------------|
|`voice`          |voice             |Queue voice to target                                                                                               |
|`behaviour`      |`VINYL_QUEUE` enum|Behaviour to use for the queue, see `VinylQueueCreate()`                                                            |
|`[setForPlaying]`|boolean           |Optional, defaults to `true`. Whether to immediately apply the new looping behaviour for the currently playing sound|

Sets the target queue's behaviour. Please see `VinylQueueCreate()` for more information.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueGetBehaviour`

`VinylQueueGetBehaviour(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number or `undefined`

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |Queue voice to target    |

Returns the target queue's behaviour.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueSetLoop`

`VinylQueueSetLoop(voice, state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name       |Datatype|Purpose                  |
|-----------|--------|-------------------------|
|`voice`    |voice   |Queue voice to target    |
|`loopQueue`|boolean |Whether to loop the queue by pushing stopping sounds to the bottom of the queue|

Sets whether the queue itself should loop.

?> If you'd like to alter the loop state of the currently playing sound then use `VinylGetLoop()`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueGetLoop`

`VinylQueueSetLoop(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |Queue voice to target    |

Returns whether the queue itself is set to loop.

?> If you'd like to return the loop state of the currently playing sound then use `VinylGetLoop()`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueSetArray`

`VinylQueueSetArray(voice, soundArray)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name        |Datatype       |Purpose                             |
|------------|---------------|------------------------------------|
|`voice`     |voice          |Queue voice to target               |
|`soundArray`|array of sounds|Array of sounds to set for the queue|

Sets the queue of sounds for a queue created by VinylQueueCreate(). This function will "save" a copy of the input array which means that any adjustment to the input array after calling `VinylQueueSetArray()` will not alter what sounds are played back. You will need to call `VinylQueueSetArray()` again if you want to change the internal sound array.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueGetArray`

`VinylQueueGetArray(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Array of sounds

|Name        |Datatype       |Purpose                             |
|------------|---------------|------------------------------------|
|`voice`     |voice          |Queue voice to target               |

Returns the array of sounds that are queued for the target queue. This queue does not include the currently playing sound. This function returns a copy of the internal array that the queue uses. Modifying the returned array will therefore not alter the queue's behaviour and you will need to use `VinylQueueSetArray()` to "save" any changes you've made to the array.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueuePushBottom`

`VinylQueuePushBottom(voice, sound)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                                 |
|-------|--------|----------------------------------------|
|`voice`|voice   |Queue voice to target                   |
|`sound`|sound   |Sound to push to the bottom of the queue|

Pushes a sound to the bottom of a queue's array of sounds. If the queue is empty then the next sound will be played at the start of the next frame.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueuePushTop`

`VinylQueuePushTop(voice, sound)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                              |
|-------|--------|-------------------------------------|
|`voice`|voice   |Queue voice to target                |
|`sound`|sound   |Sound to push to the top of the queue|

Pushes a sound to the top of a queue's array of sounds. Once the currently playing sound has stopped, the sound pushed by this function will play. If the queue is empty then the next sound will be played at the start of the next frame.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueContains`

`VinylQueueContains(voice, sound)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean

|Name   |Datatype|Purpose              |
|-------|--------|---------------------|
|`voice`|voice   |Queue voice to target|
|`sound`|sound   |Sound to check for   |

Returns whether a queue's array of sounds contains the specified target sound. This function will return `true` if the currently playing sound also matches the target sound.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueClear`

`VinylQueueClear(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose              |
|-------|--------|---------------------|
|`voice`|voice   |Queue voice to target|

Clears all sounds in a queue's array of sounds.

!> This function won't stop the currently playing sound. Use `VinylStop()` to stop the currently playing sound in a queue.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylQueueDestroy`

`VinylQueueDestroy(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose              |
|-------|--------|---------------------|
|`voice`|voice   |Queue voice to target|

Destroys a Vinyl queue. This stops any currently playing audio and renders the queue inoperable. This function is provided for convenience and you don't have to call this function to manage memory.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->