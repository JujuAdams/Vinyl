<!-- <img src="https://raw.githubusercontent.com/JujuAdams/Vinyl/master/LOGO.png" width="50%" style="display: block; margin: auto;" /> -->
<h1 align="center">Vinyl 4.0</h1>
<p align="center">Live updating audio system for GameMaker LTS 2022 by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>

<p align="center"><a href="https://github.com/JujuAdams/Vinyl/releases/" target="_blank">Download the .yymps</a></p>
<p align="center">Talk about Vinyl on the <a href="https://discord.gg/8krYCqr" target="_blank">Discord server</a></p>

&nbsp;

## About Vinyl

Implementing audio in GameMaker - be it music, sound effects, ambience, or UI blips - is a time-consuming process. There's a lot of [boilerplate](https://en.wikipedia.org/wiki/Boilerplate_code) and setup code that's required to get sounds playing in a structured, controllable way. Even after your audio is playing in roughly the way you want, mixing the audio (i.e. adjusting volumes) takes ages because you often have to recompile the entire game to hear your changes. Vinyl solves this recompilation issue at the same time as simplifying many common audio implementation tasks.

**Vinyl lets you mix your audio whilst the game is playing.**

The core of Vinyl is a [configuration file](Configuration) stored in the GameMaker IDE that contains a multitude of rules for how audio should be played in your game. You can read more about this file [here](Configuration). So long as you're playing your game on Windows, Mac, or Linxu and you're running the game from the IDE, any change made to the configuration file is immediately reflected in the audio playback in-game. This means that if you want that meaty shotgun blast to be even louder, you can change one value in the GameMaker IDE and hear the impact of your change instantly. No recompilation required.

**Vinyl lets you organise groups of assets in the way that you want.**

Vinyl organises sound assets by attaching "labels" to them. A sound asset can be assigned to zero, one, or many labels. If you change a property on a label - either in the configuration file or in code - then that is reflected in playback of instances. Handling crossfades for music tracks is also easy using labels. By setting up a simple `limit: 1` property in the [configuration file](Configuration), you ensure that only one piece of audio can be played for that particular label. Any already-playing tracks are faded out gracefully. All you have to do to label up each of your music assets with the right label and you're done.

Vinyl of course supports pitch randomisation, emitters, panning, fade-ins and fade-outs, semitone transposition, and all the rest of it. It's a fully-featured audio system that makes it faster and easier to hear your game come to life.