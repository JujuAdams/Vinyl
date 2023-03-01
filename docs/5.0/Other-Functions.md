# Other Functions

&nbsp;

## `VinylTypeGet`

`VinylTypeGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* String, the type of a [voice](Terminology)

|Name    |Datatype|Purpose            |
|--------|--------|-------------------|
|`target`|voice   |The voice to target|

This function can return one of the following values as strings: `"asset"` `"basic"` `"queue"` `"multi"`

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLabelVoicesGet`

`VinylLabelVoicesGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Array of [voices](Terminology)

|Name  |Datatype|Purpose        |
|------|--------|---------------|
|`name`|string  |Label to target|

Returns an array containing every voice assigned to the label.

!> Do not modify the array returned by this function!

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLabelVoiceCountGet`

`VinylLabelVoiceCountGet(name)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the number of [voices](Terminology) assigned to the label

|Name  |Datatype|Purpose        |
|------|--------|---------------|
|`name`|string  |Label to target|

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylSystemReadConfig`

`VinylSystemReadConfig(configStruct)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name          |Datatype|Purpose                                           |
|--------------|--------|--------------------------------------------------|
|`configStruct`|        |                                                  |

Updates Vinyl's internal configuration from a struct representation of the [configuration file](Configuration). You'll generally never need to call this if you've got live update enabled, but it is provided if you're building out a custom workflow of some kind (e.g. loading YAML-formatted configuration instead).

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLiveUpdateSet`

`VinylLiveUpdateSet(state)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                   |
|----------|--------|------------------------------------------|
|`state`   |boolean |Whether to enable or disable live updating|

Toggles live updating on and off. Live updating has a slight performance hit (moreso when storing your project on a "spinning disk" hard drive) so turning it off can be help for profiling and development in general.

?> This function will do nothing when running outside the IDE, or when not running on Windows, Mac, or Linux.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylLiveUpdateGet`

`VinylLiveUpdateGet()`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether live updating of [Vinyl's configuration file](Configuration) is enabled

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This function will always return `false` when running outside the IDE, or when not running on Windows, Mac, or Linux.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->