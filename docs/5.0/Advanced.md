# Advanced

&nbsp;

## `VinylShutdownGet`

`VinylShutdownGet(id)`

&nbsp;

*Returns:* Boolean, whether a [Vinyl instance](Terminology) is in "shutdown mode"

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`id`      |        |                                                  |

An instance will be put into shutdown mode if [`VinylFadeOut()`](Basics) has been called for either the instance itself for one of the label it's assigned to.

&nbsp;

## `VinylLabelInstancesGet`

`VinylLabelInstancesGet(id)`

&nbsp;

*Returns:* Array of [Vinyl instances](Terminology)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`id`      |        |                                                  |

Returns an array containing every Vinyl instance assigned to the label.

!> Do not modify the array returned by this function!

&nbsp;

## `VinylLabelInstanceCountGet`

`VinylLabelInstanceCountGet(id)`

&nbsp;

*Returns:* Number, the number of [Vinyl instances](Terminology) assigned to the label

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`id`      |        |                                                  |

&nbsp;

## `VinylSystemGainSet`

`VinylSystemGainSet(gain)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`gain`    |        |                                                  |

Sets the gain of the overall system. You may want to use this for controlling the master volume of all sounds, or to compensate for platform-specific audio requirements.

&nbsp;

## `VinylSystemPlayCountGet`

`VinylSystemPlayCountGet()`

&nbsp;

*Returns:* Number, the number of [Vinyl instances](Terminology) being played across the entire system

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `VinylSystemReadConfig`

`VinylSystemReadConfig(configStruct)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name          |Datatype|Purpose                                           |
|--------------|--------|--------------------------------------------------|
|`configStruct`|        |                                                  |

Updates Vinyl's internal configuration from a struct representation of the [configuration file](Configuration). You'll generally never need to call this if you've got live update enabled, but it is provided if you're building out a custom workflow of some kind (e.g. loading YAML-formatted configuration instead).

&nbsp;

## `VinylLiveUpdateSet`

`VinylLiveUpdateSet(state)`

&nbsp;

*Returns:* N/A (`undefined`)

|Name      |Datatype|Purpose                                           |
|----------|--------|--------------------------------------------------|
|`state`   |        |                                                  |

Toggles live updating on and off. Live updating has a slight performance hit (moreso when storing your project on a "spinning disk" hard drive) so turning it off can be help for profiling and development in general.

?> This function will do nothing when running outside the IDE, or when not running on Windows, Mac, or Linux.

&nbsp;

## `VinylLiveUpdateGet`

`VinylLiveUpdateGet()`

&nbsp;

*Returns:* Boolean, whether live updating of [Vinyl's configuration file](Configuration) is enabled

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This function will always return `false` when running outside the IDE, or when not running on Windows, Mac, or Linux.