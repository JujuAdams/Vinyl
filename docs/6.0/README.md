&nbsp;

<img src="https://raw.githubusercontent.com/JujuAdams/Vinyl/master/LOGO.png" width="50%" style="display: block; margin: auto;" />
<h1 align="center">Vinyl 6.0</h1>
<p align="center">Live updating audio system for GameMaker 2024.4 by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>

<p align="center"><a href="https://github.com/JujuAdams/Vinyl/releases/" target="_blank">Download the .yymps</a></p>

&nbsp;

## Features

- Easy functions for fade in, fade out, and playback control
- Shuffle patterns to choose random sounds, pitches, and gains for playback
- Head-loop-tail patterns to implement smoother background music
- Blend patterns to mix between multiple sounds at the same time with a single parameter
- Queues to create in-game playlists or dynamic scores
- Mix groups to easily adjust the gain of multiple sounds and patterns at the same time
- Duckers to handle crossfades and ducking
- Live update of all the above using a simple JSON format
- Easier gain control that allow you to exceed GameMaker's normal maximum gain

## Updating

Releases go out once in while, typically expedited if there is a serious bug. This library uses [semantic versioning](https://semver.org/). In short, if the left-most number in the version is increased then this is a "major version increase". Major version increases introduce breaking changes and you'll almost certainly have to rewrite some code. However, if the middle or right-most number in the version is increased then you probably won't have to rewrite any code. For example, moving from `1.1.0` to `2.0.0` is a major version increase but moving from `1.1.0` to `1.2.0` isn't.

?> Please always read patch notes. Very occasionally a minor breaking change in an obscure feature may be introduced by a minor version increase.

At any rate, the process to update is as follows:

1. **Back up your whole project using source control!**
2. Back up the contents of your configuration scripts (`__VinylConfigMacros` and `__VinylConfigJSON`) within your project. Duplicating scripts is sufficient
3. Delete all library scripts from your project. Unless you've moved things around, this means deleting the library folder from the asset browser
4. Import the latest [.yymps](https://github.com/JujuAdams/Vinyl/releases/)
5. Restore your configuration scripts from the back-up line by line

!> Because configuration macros might be added or removed between versions, it's important to restore your configuration scripts carefully.
