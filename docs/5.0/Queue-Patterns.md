# Queue Patterns

&nbsp;

Queue patterns play assets from an array one after another. If a sound asset is set to loop then the queue will hold on that looping asset until the voice is told to stop looping by using `VinylLoopSet()`.

Queues can have one of three behaviours:

|Behaviour|Functionality                                                                                                                 |
|---------|------------------------------------------------------------------------------------------------------------------------------|
|0        |Play the queue once. Assets will be removed from the queue once they finish playing                                           |
|1        |Replay the queue once it’s finished. No assets are removed from the queue, and the queue will replay from the start           |
|2        |Replay the last asset in the queue. Assets will be removed from the queue once they finish playing (apart from the last asset)|

You can set the behaviour of a Queue pattern in the [configuration file](Config-File) and you can override the behaviour at runtime using [`VinylQueueBehaviorSet()`](Queue-Pattern-Functions). You can also push new voices to a Queue voice at runtime by using [`VinylQueuePush()`](Queue-Pattern-Functions).

&nbsp;

## Properties

Queue patterns should be set up in the [configuration file](Config-File).

|Property        |Datatype        |Default                                        |Notes                                                                                                                         |
|----------------|----------------|-----------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
|`type`          |string          |                                               |**Required. Must be `queue`**                                                                                                 |
|`assets`        |array           |                                               |**Required.** An array of asset names as strings                                                                              |
|`gain`          |number          |`1`                                            |Defaults to `0` db in [decibel mode](Config-Macros)                                                                           |
|`pitch`         |number or array |`1`                                            |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)                   |
|`transpose`     |number          |*passthrough*                                  |                                                                                                                              |
|`loop`          |boolean         |*passthrough*                                  |This property is inherited by assets played by this pattern; to automatically replay Queue pattern use the `behavior` property|
|`stack`         |string          |*passthrough*                                  |[Stack](Stacks) to push voices to                                                                                             |
|`stack priority`|number          |`0`                                            |Priority for voices when pushed to the stack above                                                                            |
|`effect chain`  |string          |*passthrough*                                  |                                                                                                                              |
|`label`         |string or array |*passthrough*                                  |Label to assign this pattern to. Can be a string for a single label, or an array of label names                               |
|`persistent`    |boolean         |*passthrough*                                  |                                                                                                                              |
|`behavior`      |number          |[`VINYL_DEFAULT_QUEUE_BEHAVIOR`](Config-Macros)|Must be one of the following: `0` `1` `2`                                                                                     |

&nbsp;

## Examples

```
{ //Start of __VinylConfig
	...
    
	patterns: { //Start of pattern definitions
        
        smithing sequence: {
        	type: queue
        	gain: 1.1
        	stack: bgm //Interrupt background music
        	stack priority: 1
        	behavior: 0 //Play through the queue once
        	assets: [ //
                sndBlip
                sndBlop
                sndBloop
                sndClang
        	]
        }

        ambient loop: {
        	type: queue
        	effect chain: echo
        	label: ambience
        	behaviour: 1 //Replay forever
        	assets: [
                sndChirp
                sndTwitter
                sndCheep
                sndHoot
        	]
        }

        car engine: {
        	type: queue
        	behaviour: 2 //Replay the last asset
        	assets: [
                sndEngineStart
                sndEngineRevUp
                sndEndingIdle
                //Use VinylQueuePush() to push a new state onto the queue
        	]
        }
	}

	...
}
```