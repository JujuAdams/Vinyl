# Queue Functions

&nbsp;

## `VinylQueuePush`

`VinylQueuePush(target, asset, [dontRepeatLast=false])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name              |Datatype|Purpose                                                           |
|------------------|--------|------------------------------------------------------------------|
|`target`          |voice   |The Queue pattern voice to target                                 |
|`asset`           |sound   |The sound to push to the end of the queue                         |
|`[dontRepeatLast]`|boolean |Whether to allow sequential, identical assets. Defaults to `false`|

Pushes an asset onto a Queue pattern voice for playback. If `dontRepeatLast` is set to `false` then you may push the same asset to the end of the queue multiple times. If `dontRepeatLast` is set to `true`, only one copy of a particular asset can be at the end of the queue.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->