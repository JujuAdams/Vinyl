# Stacks

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

## `VinylStackPatternGet`

`VinylStackPatternGet(name, priority)`

<!-- tabs:start -->

#### **Description**

*Returns:* String or [audio asset](Overview) index, the pattern used to create the voice playing with the given priority

|Name      |Datatype|Purpose                                      |
|----------|--------|---------------------------------------------|
|`name`    |string  |Stack to target                              |
|`priority`|number  |Priority for the specified voice in the stack|

This function returns `undefined` if no voice is playing for the stack with the given priority.

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

&nbsp;

## `VinylStackMaxVoiceGet`

`VinylStackMaxVoiceGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice, the voice with the maximum priority (or `undefined` if no voice is playing on the stack)

|Name  |Datatype|Purpose        |
|------|--------|---------------|
|`name`|string  |Stack to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->