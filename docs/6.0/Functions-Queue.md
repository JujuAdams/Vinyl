# Queue Functions

&nbsp;

## `VinylQueueCreate`

`VinylQueueCreate(behaviour, loopQueue, [gain=1])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name       |Datatype          |Purpose                  |
|-----------|------------------|-------------------------|
|`behaviour`|`VINYL_QUEUE` enum|                         |
|`loopQueue`|boolean           |                         |
|`[gain]`   |number            |                         |

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

|Name             |Datatype          |Purpose                  |
|-----------------|------------------|-------------------------|
|`voice`          |voice             |                         |
|`behaviour`      |`VINYL_QUEUE` enum|                         |
|`[setForPlaying]`|boolean           |                         |

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

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |

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

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |
|`state`|boolean |                         |

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

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |

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

|Name        |Datatype       |Purpose                  |
|------------|---------------|-------------------------|
|`voice`     |voice          |                         |
|`soundArray`|array of sounds|                         |

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

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |

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

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |
|`sound`|sound   |                         |

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

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |
|`sound`|sound   |                         |

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

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |
|`sound`|sound   |                         |

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

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |

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

|Name   |Datatype|Purpose                  |
|-------|--------|-------------------------|
|`voice`|voice   |                         |

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->