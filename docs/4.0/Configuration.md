# Configuration

&nbsp;

Vinyl is centred around a single configuration file that controls the underlying volumes, pitches, and behaviours of audio played with Vinyl. You can find this configuration file in the Vinyl folder in your asset browser; its name is `__VinylConfig`. When you import Vinyl for the first time, this config file will be filled with some example configuration and some comments (you can see an online copy of this file [here](https://github.com/JujuAdams/Vinyl/blob/master/notes/__VinylConfig/__VinylConfig.txt)).

&nbsp;

## "Loose JSON" Syntax

Vinyl's configuration file is, basically, written as [JSON](https://en.wikipedia.org/wiki/JSON), a popular data interchange format. However, JSON is a pain in the bum to write by hand so Vinyl uses its own custom JSON-like syntax (which I'm going to call "Loose JSON" in lieu of a snappier name). If you've written JSON before then you'll grasp it very quickly, and I think that Loose JSON is faster and easier to write.

In brief:

1. Valid standard JSON is also valid Loose JSON
2. Loose JSON supports strings, numbers, boolean, and null as basic value types
2. Loose JSON can express objects and arrays like normal JSON
3. Loose JSON supports escaped characters, including [Unicode escapes](https://dencode.com/en/string/unicode-escape)
4. You can use either commas or newlines to separate elements in an object or array
5. Trailing commas are fine too
6. Strings don't need delimiting quotes `"`. Any trailing or leading whitespace is automatically clipped off. If you'd like to use special symbols inside a string (e.g. `"` `:` `,` etc.), and you don't want to escape those characters, then you'll need to delimit strings with quotes
7. The keywords `true` `false` `null` are translated to their GameMaker equivalents (`null` is GameMaker's `undefined`)
8. If a value looks like a number then the Loose JSON parser will try to turn it into a number
9. Keys must be strings, but can have spaces in them

Here's a standard JSON example:

```
{
	"menu": {
		"id": 4578,
		"value": "File",
		"popup": {
			"menuitem": ["New", "Open", "Close"]
		}
	}
}
```

And here's an equivalent Loose JSON example:

```
{
	menu: {
		id: 4578,
		value: File
		popup: {
			menuitem: [New, Open, Close]
		}
	}
}
```

&nbsp;

## High-level Structure

Vinyl expects - and requires - that the top-level object contains three child objects, called `labels`, `assets`, and `patterns`. Each of these child objects represent different parts of Vinyl's operation. You can read more about the precise meaning of ["Label", "Asset", and "Pattern" here](Terminology). Each category has its own rules and expectations for setup; scroll down for info.

```
{
    labels: {
        ...
    }
    
    assets: {
        ...
    }
    
    patterns: {
        ...
    }
}
```

&nbsp;

## Labels

Labels are the way that Vinyl categorises assets and patterns, and the primary way to control the behaviour of audio in groups. You can read more about the capabilities of labels [here](Terminology).

### `gain`

Gain

### `pitch`

Pitch

### `loop`

Loop

### `limit` and `limit fade out rate`

Limit

### `children`

Children

&nbsp;

```
{
	...

    // Label names must not contain spaces
    // Labels may have six properties defined:
    //   1. "gain", a number, the gain for the asset in decibels
    //   2. "pitch", a number, the pitch for the asset as a percentage, or a two-element array containing the minimum and maximum pitch values to randomize between
    //   3. "children", a dictionary containing labels that should inherit their parent's gain and pitch (applied multiplicatively)
    //   4. "loop", a boolean, whether the asset should default to looping when played. This is overriden by the [loop] argument in VinylPlay()
    //   5. "limit, a number indicating the maximum number of audio instances that can be played using this label
    //   6. "limit fade out rate", a number indicating the rate that audio should be faded out, in decibels per second
    //       N.B. Audio instances played under child labels count towards the limit counter for their parent label(s)
    
	labels: {
	    music: {
	        loop: true
	        limit: 1
	    }
	    ambience: {
	        loop: true
	        limit: 1
	    }
	    menu: {}
	    gameplay: {}
	    sfx: {
	        children: {
	            speech: {
	                pitch: [0.9, 1.1]
	            }
	            footsteps: {
	                pitch: [0.8, 1.2]
	            }
	            ui: {}
	        }
	    }
	}

	...
}
```

&nbsp;

## Assets

```
{
	...
	
    // Audio assets may have three properties defined:
    //   1. "gain", a number, the gain for the asset in decibels
    //   2. "pitch", a number, the pitch for the asset as a percentage, or a two-element array containing the minimum and maximum pitch values to randomize between
    //   3. "label", a string containing the name of the label, or an array of label names. Label gain and pitch are applied multiplicatively if more than one label is defined
    // 
    // Any audio asset not explicitly defined uses the "fallback" audio asset definition
    
    assets: {
        fallback: {}
        sndChickenNuggets: {
            label: music
            copyTo: sndTestTone
        }
    }

	...
}
```

&nbsp;

## Patterns

```
{
	...
	
    patterns: {
        random pitch test: {
            basic: sndTestTone
            pitch: [0.8, 1.2]
        }
        
        shuffle test: {
            shuffle: [
                sndTestTone
                sndChickenNuggets
            ]
        }
    }

	...
}
```