# Quick Start Guide

There's a lot you can do with Vinyl, but sticking to simple stuff is the best way to get started. This guide will take you through these topics:

1. Importing Vinyl
2. Basic audio playback
3. Setting up Vinyl's [configuration file](Config-File) for your audio assets
4. Live updating
5. Basic use of labels
6. Basic use of patterns

&nbsp;

## Importing Vinyl

!> Vinyl is intended for use with Git, or an equivalent source control system.

You can find the latest version of Vinyl [here](https://github.com/JujuAdams/Vinyl/releases). Make sure that you're using a version of GameMaker that Vinyl supports, and then download the `.yymps` from that page and import into GameMaker. You'll see a folder called `Vinyl` appear in your asset browser, and a file called `vinyl.dat` will also be created in your Included Files.

If you look inside the Vinyl folder you'll see a lot of subfolders. These subfolders contain functions that comprise the API - the interface that you'll need to execute Vinyl code in your game. The `(Internals)` folder holds code that Vinyl requires to operate and has to be there but otherwise you can forget it exists. You'll also see two scripts and a Note asset (`__VinylConfigMacros` `__VinylConfigDebug` `__VinylConfig`). You'll be using these to customise Vinyl for your use case.

?> When you import `__VinylConfig` it'll contain some example data. If you run your game straight away you'll likely see warnings or outright errors. If you want to postpone getting Vinyl ready for use, delete the entire contents of `__VinylConfig` and that'll avoid errors on boot.

&nbsp;

## Basic Audio Playback

Vinyl has a few functions to play back audio. You should choose which function to play based on your needs. To begin with we'll stick to using [`VinylPlay()`](Playing-Audio) but you may want to look into the other playback functions [`VinylPlaySimple()`](Playing-Audio) and [`VinylPlayOnEmitter()`](Emitter-Functions) as you get more comfortable with the library.

`VinylPlay()` has the following arguments:

|Name     |Datatype        |Purpose                                                                                                                                                              |
|---------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sound`  |asset or pattern|The sound to play, either an asset or a pattern                                                                                                                      |
|`[loop]` |boolean         |Whether the sound should loop. Defaults to whatever has been set for the asset or pattern in question, and if none has been set, the sound will not loop             |
|`[gain]` |number          |Voice gain, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other [sources of gain](Gain)|
|`[pitch]`|number          |Voice pitch, in normalised pitch units. Defaults to `1`, no pitch change                                                                                             |
|`[pan]`  |number          |Panning value, from `-1` (left) to `0` (centre) to `+1` (right). Defaults to no panning                                                                              |

You can see that most of these arguments are optional arguments, as indicated by the `[` `]` square brackets around the parameter names. This means `VinylPlay()` has a lot of flexibility. Here are some examples of use:

```gml
//Play sndMeow with no frills
VinylPlay(sndMeow);

//Play the sound and loop it
VinylPlay(sndMainMenuMusic, true);

//Play sndSmallMeow, but at half gain
VinylPlay(sndSmallMeow, false, 0.5);

//Bonk! at a randomised pitch
VinylPlay(sndBonk, false, 1, random_range(0.9, 1.1));

//Play a creepy noise on repeat at a low volume and pitch shifted down
VinylPlay(sndHorrorAmbience, true, 0.2, 0.6);
```

This is all very simplistic and of course we do can more. Let's take a look at a common thing to do with music - fade it in and fade it out. We going to add an extra spin on this as well by pitch shifting as we fade in and out to give the effect of a record player or casette deck accelerating. For this we'll use [`VinylGainTargetSet()`](Gain-Functions), [`VinylPitchTargetSet()`](Pitch-Functions), and [`VinylFadeOut()`](Stopping-Audio). (You could also use [`VinylPlayFadeIn()`](Playing-Audio).)

<!-- tabs:start -->

#### **Create Event**

```gml
/// oMainMenu Create event

//Starts the music at silence and at a reduced pitch
music = VinylPlay(sndMainMenuMusic, true, 0, 0.5);

//And then fade it in, speeding it up at the same time
VinylGainTargetSet(music, 1);
VinylPitchTargetSet(music, 1);
```

#### **Destroy Event**

```gml
/// oMainMenu Destroy event

//Fade out the music whilst slowing it down
//VinylFadeOut() explicitly stops audio when it's faded out
VinylFadeOut(sndMainMenuMusic);
VinylPitchTargetSet(music, 0.5);
```

<!-- tabs:end -->

&nbsp;

## The Config File

So far so good. The exciting bit starts now.

Looking at the examples above - playback of `sndMainMenu` `sndSmallMeow` etc. - you'll notice that they involve hardcoding magic numbers for different properties. Inserting magic numbers into your codebase is a guaranteed way to have a bad time later on, and especially so if we intend to use a sound effect in multiple places which would mean copy-pasting numbers all over the place.

Vinyl solves this problem by giving you a way to define properties in a single place and have those properties influence how audio is played no matter where in your code its being played. With the correct configuration, the above example would look like this:

<!-- tabs:start -->

#### **New, Clean Version**

```gml
VinylPlay(sndMeow);

VinylPlay(sndMainMenuMusic);

VinylPlay(sndSmallMeow);

VinylPlay(sndBonk);

VinylPlay(sndHorrorAmbience);
```

#### **Old, Messy Version**

```gml
VinylPlay(sndMeow);

VinylPlay(sndMainMenuMusic, true);

VinylPlay(sndSmallMeow, false, 0.5);

VinylPlay(sndBonk, false, 1, random_range(0.9, 1.1));

VinylPlay(sndHorrorAmbience, true, 0.2, 0.6);
```

<!-- tabs:end -->

I'm sure you'll agree this is much cleaner!

It's very easy to set up this sort of configuration in Vinyl. If you go to the `Vinyl` folder in your Asset Browser in the GameMaker IDE you'll see a Note asset called `__VinylConfig`. Open that up and you'll see a template configuration. You can read in-depth documentation for what sort of data you can put into the configuration file [here](Config-File). For expediency, here's an example of a configuration file that replicates the hardcoded numbers we had before:

```
{
	assets: {
		sndMainMenuMusic: {
			loop: true
		}

		sndSmallMeow: {
			gain: 0.5
		}

		sndBonk: {
			pitch: [0.9, 1.1]
		}

		sndHorrorAmbience: {
			loop: true
			gain: 0.2
			pitch: 0.6
		}
	}
}
```

Each asset gets its own struct, and each struct contains information that changes how the audio is played back. Whenever `sndBonk` is played, it'll be played with a 90% to 110% pitch variation, chosen randomly. Whenever `sndSmallMeow` is played, it will be played at half gain, and so on. There are a lot of different properties you can manipulate for assets and you can read about that [here](Assets).

&nbsp;

## Live Updating

Vinyl allows to live update any properties in the configuration file whilst the game is running. You don't need to set up anything else, it works out of the box.

If you want to experiment with a louder `sndSmallMeow` then you can change the `gain` property for the asset in your IDE whilst the game is running and, when you save the project to disk, those changes will be reflect near instantly in the game. If you want your `sndBonk` to bonk higher, change its `pitch` property. You can even add new definitions for assets you didn't define before you compiled the game. This becomes especially powerful when you're working on a bigger project and getting audio to mix nicely would otherwise involve dozens of recompiles to adjust gain values by tiny amounts.

There is one limitation however: you can't live update audio when running the game on a different device to the machine you're running the IDE in. Maybe in the future I'll write something to make that happen, but for now you can only live update locally.

&nbsp;

## Labels

&nbsp;

## Patterns