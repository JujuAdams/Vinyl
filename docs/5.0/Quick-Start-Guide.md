# Quick Start Guide

There's a lot you can do with Vinyl, but sticking to simple stuff is the best way to get started. This guide will take you through five things:

1. Importing Vinyl
2. Basic audio playback
3. Setting up Vinyl's [configuration file](Config-File) for your audio assets
4. Basic use of labels
5. Basic use of patterns

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

This is all very simplistic and of course we do can more. Let's take a look at a common thing to do with music - fade it in and fade it out. We going to add an extra spin on this as well by pitch shifting as we fade in and out to give the effect of a record player or casette deck accelerating. For this we'll use [`VinylGainTargetSet()`](Gain-Functions) (you )could also use [`VinylPlayFadeIn()`](Playing-Audio)) and [`VinylFadeOut()`](Stopping-Audio).

<!-- tabs:start -->

#### **Create Event**

```gml
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

```gml
VinylPlay(sndMeow);

VinylPlay(sndMainMenuMusic);

VinylPlay(sndSmallMeow);

VinylPlay(sndBonk);

VinylPlay(sndHorrorAmbience);
```

I'm sure you'll agree this is much cleaner! Here's what the [config file](Config-File) would look like to support this:

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

&nbsp;

## Labels

&nbsp;

## Patterns