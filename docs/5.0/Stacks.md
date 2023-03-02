# Stacks

&nbsp;

Stacks are special logic containers that automatically manage audio clips interrupting each other.

&nbsp;

## Configuration Properties

|Property     |Datatype|Default                                        |Notes                                                                                           |
|-------------|--------|-----------------------------------------------|------------------------------------------------------------------------------------------------|
|`ducked gain`|number  |`0`                                            |Defaults to `-60` db in [decibel mode](Config-Macros) (silence)                                 |
|`rate`       |number  |[`VINYL_DEFAULT_DUCK_GAIN_RATE`](Config-Macros)|Measured in gain units per second                                                               |
|`pause`      |boolean |`true`                                         |Whether to pause a voice when fully ducked. Must be `false` if `ducked gain` is greater than `0`|

&nbsp;

## `VinylStackPush`

`VinylStackPush(name, priority, voice)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                      |
|----------|--------|---------------------------------------------|
|`name`    |string  |Stack to target                              |
|`priority`|number  |Priority for the specified voice in the stack|
|`voice`   |voice   |Voice to push to the stack                   |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylStackGet`

`VinylStackGet(name, priority)`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, the voice with the given priority (or `undefined` if no voice is found)

|Name      |Datatype|Purpose                                      |
|----------|--------|---------------------------------------------|
|`name`    |string  |Stack to target                              |
|`priority`|number  |Priority for the specified voice in the stack|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylStackMaxPriorityGet`

`VinylStackMaxPriorityGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the maximum priority of all voices being played (or `undefined` if the stack has no voices)

|Name  |Datatype|Purpose        |
|------|--------|---------------|
|`name`|string  |Stack to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->