# Assets

&nbsp;

An asset is any [sound asset](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm) added to the GameMaker IDE. You should aim to further define properties for these assets to [Vinyl's internal configuration file](Config-File) in order to take advantage of Vinyl's features. Vinyl allows you to control the gain and pitch for assets, as well as assigning assets to labels for bulk control.

&nbsp;

<!-- tabs:start -->

#### **Configuration Properties**

|Property        |Datatype        |Default                             |Notes                                                                                                      |
|----------------|----------------|------------------------------------|-----------------------------------------------------------------------------------------------------------|
|`gain`          |number          |`1`                                 |Defaults to `0` db in [decibel mode](Config-Macros)                                                        |
|`pitch`         |number or array |`1`                                 |Can be a two-element array for pitch variance. Defaults to `100`% in [percentage pitch mode](Config-Macros)|
|`transpose`     |number          |*passthrough*                       |                                                                                                           |
|`bpm`           |number          |[`VINYL_DEFAULT_BPM`](Config-Macros)|                                                                                                           |
|`loop`          |boolean         |*passthrough*                       |                                                                                                           |
|`loop points`   |array of numbers|*passthrough*                       |Array must have two-elements defining the start and end point of a loop, measured in seconds               |
|`stack`         |string          |*passthrough*                       |                                                                                                           |
|`stack priority`|number          |`0`                                 |                                                                                                           |
|`effect chain`  |string          |*passthrough*                       |                                                                                                           |
|`label`         |string or array |`[]`                                |Label to assign this asset to. Can be a string for a single label, or an array of label names              |
|`persistent`    |boolean         |*passthrough*                       |                                                                                                           |

#### **Example**

```
{
	...

	assets: {
		sndCat: {
			gain: 1.4
			pitch: 0.9
			effect chain: echo
			label: [sfx, speech]
		}
	}

	...
}
```

<!-- tabs:end -->