# Looping

&nbsp;

## `VinylSetLoop`

`VinylSetLoop(voice, state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name   |Datatype|Purpose                                  |
|-------|--------|-----------------------------------------|
|`voice`|voice   |Voice to target                          |
|`state`|boolean |Whether the voice should loop or not loop|

Sets the target voice to loop or not loop. If a head-loop-tail voice is targeted then it is not possible to change the loop behaviour of the head or tail sound. If the loop sound is set to not loop then the tail sound will play after the loop sound has played through.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetLoop`

`VinylGetLoop(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean

|Name   |Datatype|Purpose                     |
|-------|--------|----------------------------|
|`voice`|voice   |Voice to target             |

Returns whether the target voice is set to loop.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->