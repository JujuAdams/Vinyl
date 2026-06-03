# Ducker Functions

&nbsp;

## `VinylDuckerCheck`

`VinylDuckerCheck(duckerName, priority)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number or `undefined`

|Name        |Datatype|Purpose                                      |
|------------|--------|---------------------------------------------|
|`duckerName`|string  |Ducker to target                             |
|`priority`  |number  |Reference priority                           |

Checks whether a new voice played with the given priority would either not play, would replace an existing voice, or would become the new maximum priority voice.

This function returns one of the following values:

|Value      |Meaning                                          |
|-----------|-------------------------------------------------|
|`0`        |Priority is below the current maximum priority   |
|`1`        |Priority is equal to the current maximum priority|
|`2`        |Priority is above the current maximum priority   |
|`undefined`|Ducker name not recognised                       |

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylDuckerGetVoice`

`VinylDuckerGetVoice(duckerName, priority)`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice or `undefined`

|Name        |Datatype|Purpose                                      |
|------------|--------|---------------------------------------------|
|`duckerName`|string  |Ducker to target                             |
|`priority`  |number  |Priority to target                           |

Returns the voice currently playing on the ducker with the given priority. If either the ducker doesn't exist or no voice is playing with that priority then this function returns `undefined`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylDuckerGetMaxPriority`

`VinylDuckerGetMaxPriority(duckerName)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number

|Name        |Datatype|Purpose                                      |
|------------|--------|---------------------------------------------|
|`duckerName`|string  |Ducker to target                             |

Returns the maximum priority out of all sounds currently playing. If either the ducker doesn't exist or no audio is playing on the ducker then this function returns `-infinity`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->

&nbsp;

## `VinylDuckerGetMaxVoice`

`VinylDuckerGetMaxVoice(duckerName)`

<!-- tabs:start -->

#### **Description**

*Returns:* Voice or `undefined`

|Name        |Datatype|Purpose                                      |
|------------|--------|---------------------------------------------|
|`duckerName`|string  |Ducker to target                             |

Returns the voice with the maximum priority out of all sounds currently playing. If either the ducker doesn't exist or no audio is playing on the ducker then this function returns `undefined`.

#### **Example**

```gml
No example provided.
```

<!-- tabs:end -->