# Blend Functions

&nbsp;

## `VinylSetBlendFactor`

`VinylSetBlendFactor(voice, factor)`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name    |Datatype|Purpose                          |
|--------|--------|---------------------------------|
|`voice` |voice   |Voice to target                  |
|`factor`|number  |Blend factor to set              |

Sets the blend factor for a blend voice. The blend factor should be a value between 0 and 1. How the blend factor interacts with the blend voice depends on whether the blend voice is set to use an animation curve to determine gains, or whether the blend voice is not using an animation curve. If the target voice is not a blend voice then this function will do nothing.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetBlendFactor`

`VinylGetBlendFactor(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name   |Datatype|Purpose                          |
|-------|--------|---------------------------------|
|`voice`|voice   |Voice to target                  |

Returns the blend factor for a blend voice. If the target voice is not a blend voice then this function will return `undefined`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylSetBlendAnimCurve`

`VinylSetBlendAnimCurve(voice, animCurve, [factor])`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name       |Datatype       |Purpose                                        |
|-----------|---------------|-----------------------------------------------|
|`voice`    |voice          |Voice to target                                |
|`animCurve`|animation curve|Animation curve to use to calculate sound gains|
|`[factor]` |number         |Optional. New blend factor to set              |

Sets the animation curve for a blend voice. This animation curve will be used to derive gains for each of the blend voice's sounds. If the target voice is not a blend voice then this function does nothing. If the `factor` argument is specified then this function will also adjust the blend factor as though `VinylSetBlendFactor()` had been called.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylGetBlendAnimCurve`

`VinylGetBlendAnimCurve(voice)`

<!-- tabs:start -->

#### **Description**

*Returns:*

|Name   |Datatype|Purpose                          |
|-------|--------|---------------------------------|
|`voice`|voice   |Voice to target                  |

Returns the animation curve set for a blend voice. If no animation curve has been set then this function will return `undefined`. If the target voice is not a blend voice then this function will return `undefined`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->