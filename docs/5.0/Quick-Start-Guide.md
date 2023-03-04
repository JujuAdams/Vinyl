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

!> Vinyl is intended for use with Git, or an equivalent source control system. You should set up source control before importing Vinyl.

You can find the latest version of Vinyl [here](https://github.com/JujuAdams/Vinyl/releases). Make sure that you're using a version of GameMaker that Vinyl supports, and then download the `.yymps` from that page and import into your GameMaker project. You'll see a folder called `Vinyl` appear in your asset browser, and a file called `vinyl.dat` will also be created in your Included Files.

If you look inside the Vinyl folder you'll see a lot of subfolders. These subfolders contain functions that comprise the API - the interface that you'll need to execute Vinyl code in your game. The `(Internals)` folder holds code that Vinyl requires to operate and has to be there but otherwise you can forget it exists. You'll also see two scripts and a Note asset (`__VinylConfigMacros` `__VinylConfigDebug` `__VinylConfig`). You'll be using these to customise Vinyl for your use case.

?> You may notice that `vinyl.dat` frequently shows inscrutiable changes in your source control. Don't worry! `vinyl.dat` is regenerated for every compile from `__VinylConfig` and doesn't contain persistent data. You can either add `vinyl.dat` to your `.gitignore`, or you can literally ignore any changes made to that file.

&nbsp;

## Basic Audio Playback

Vinyl has a few functions to play back audio. You should choose which function to use based on your needs. To begin with we'll stick to using [`VinylPlay()`](Playing-Audio) but you may want to look into the other playback functions, [`VinylPlayFadeIn()`](Playing-Audio), [`VinylPlaySimple()`](Playing-Audio), and [`VinylPlayOnEmitter()`](Emitter-Functions), as you get more comfortable with the library.

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

This is nice and everything but it's not much of a step up from GameMaker's native functionality. What else can we do?

Let's take a look at a common thing to do with music - fade it in and fade it out. We going to add an extra spin on this as well by pitch shifting as we fade in and out to give the effect of a record player or casette deck accelerating. For this we'll use [`VinylGainTargetSet()`](Gain-Functions), [`VinylPitchTargetSet()`](Pitch-Functions), and [`VinylFadeOut()`](Stopping-Audio). (You could also use [`VinylPlayFadeIn()`](Playing-Audio).)

Every time you call `VinylPlay()`, Vinyl will internally create a "voice" that holds all the information necessary to manage playback of the asset (or pattern) that you specified. This voice is indentified by a numeric ID that is returned to you from the `VinylPlay()` function. You can think of `VinylPlay()` being like `instance_create_depth()` and assets being like GameMaker objects. If you want to manipulate audio after it's started being played then you'll usually need to use the voice ID for it.

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
VinylFadeOut(music);
VinylPitchTargetSet(music, 0.5);
```

<!-- tabs:end -->

!> The other Vinyl playback functions [`VinylPlayFadeIn()`](Playing-Audio) and [`VinylPlayOnEmitter()`](Emitter-Functions) return a voice ID. **However, [`VinylPlaySimple()`](Playing-Audio) does not return a voice ID**. It instead returns a standard GameMaker sound instance ID which cannot be used with any other Vinyl functions. A sound instance ID can be used with native GameMaker functions though, should you wish to endure that.

&nbsp;

## The Config File

Looking at the examples above - playback of `sndMainMenu` `sndSmallMeow` etc. - you'll notice that they involve hardcoding magic numbers for different properties. Inserting magic numbers into your codebase is a guaranteed way to have a bad time later on, and especially so if we intend to use a sound effect in multiple places which would mean copy-pasting numbers all over the place.

Vinyl solves this problem by giving you a way to define properties in a single place and have those properties influence how audio is played no matter where in your code it's being played. With the correct configuration, the above example would look like this:

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

Setting up configuration doesn't mean that you can't further customise per-usage properties. Let's say we wanted to play `sndSmallMeow` slightly louder in one particular situation. We can still do that by using `VinylPlay()` in the same way as before.

```gml
VinylPlay(sndSmallMeow, false, 1.2);
```

Gain is applied multiplicatively between the gain set when calling `VinylPlay()` (called "voice gain") and the gain set up in the configuration file (called "asset gain"). The rules on gain inheritance are a little complex so they get their own page [here](Gain). Similar rules exist for [pitch](Pitch) and [transposition](Transposition) as well, and you can find a complete overview of voice properties [here](Voices).

&nbsp;

## Live Updating

Vinyl allows to live update any properties in the configuration file whilst the game is running. You don't need to set up anything else, it works out of the box.

If you want to experiment with a louder `sndSmallMeow` then you can change the `gain` property for the asset in your IDE whilst the game is running and, when you save the project to disk, those changes will be reflect near instantly in the game. If you want your `sndBonk` to bonk higher, change its `pitch` property. You can even add new definitions for assets you didn't define before you compiled the game. This becomes especially powerful when you're working on a bigger project and getting audio to mix nicely would otherwise involve dozens of recompiles to adjust gain values by tiny amounts.

?> You can't live update audio when running the game on a different device to the machine you're running the IDE in. Maybe in the future I'll write something to make that happen, but for now you can only live update locally.

&nbsp;

## Labels

Labels are a useful way to share properties and operations across categories of assets (and patterns). Labels can be configured in a similar way to assets and share a lot of the [same properties](Labels). Any asset that is assigned to a label will inherit those properties. This means that a label with a `pitch` property of `1.3` will cause any assets assigned to that label to be played at a higher pitch. You can read the in-depth guide on labels [here](Labels).

Labels have their own gain and pitch states at runtime. You can change the gain or pitch of a label whilst the game is running and all voices assigned to that label will dynamically update, following the changes you've made. This is useful for any number of things, but the primary use case is allowing users to control the volume of e.g. music, sound effects, speech, ambience etc. This can be done with a little setup in the configuration file and then a single line of code in GML.

?> The gain and pitch contributions from labels are applied multiplicatively with other gain/pitch values. Please read the documentation for [gain](Gain) and [pitch](Pitch) for more information.

<!-- tabs:start -->

#### **Configuration File**

```
{
    labels: {
        //Use the default settings for the "music" label
        music: {}
        
        //Mix sound effects a little quieter always
        sfx: {
            gain: 0.8
        }
    }

    assets: {
        sndGameMusic: {
            //Assign this asset to the "music" label too
            label: music
        }

        sndUIClick: {
            //Assign this asset to the "sfx" label
            label: sfx
        }
    }
}
```

#### **GML**

```gml
//Set the gain of the "music" and "sfx" labels from the settings
VinylGainSet("music", global.settings.musicGain);
VinylGainSet("sfx", global.settings.sfxGain);

//Will be affect by the new gain value for the "sfx" label
VinylPlay(sndUIClick);
```

<!-- tabs:end -->

Labels have another interesting use case too, and that's distributing a single Vinyl function call across all voices assigned to a label. This is a more advanced topic and best left to the dedicated [labels](Labels) page.

<!-- tabs:start -->

#### **Configuration File**

```
{
    labels: {
        music: {}
    }

    assets: {
        sndMainMenuMusic: {
            label: music
        }

        sndGameMusic: {
            label: music
        }
    }
}
```

#### **GML**

```gml
//Play both music tracks
//... not sure why you'd ever do this but stick with me
VinylPlay(sndMainMenuMusic);
VinylPlay(sndGameMusic);

//Stop both audio tracks we just played
VinylStop("music");
```

<!-- tabs:end -->

An asset can be assigned to multiple labels at the same time and will inherit properties from all labels. The logic behind inheritance is explained [here](Assets). It gets pretty complicated but hopefully makes sense when you start using it in context. You can assign an asset to multiple labels by putting all of the labels you want in an array inside the configuration file.

```
{
    labels: {
        //Mix sound effects a little quieter always
        sfx: {
            gain: 0.8
        }

        //Assets assigned to "speech" will vary their pitch a little
        speech: {
            pitch: [0.9, 1.1]
        }
    }

    assets: {
        sndNPCYoungGirl: {
            label: [sfx, speech]
        }
    }
}
```

Writing out `[sfx, speech]` for each and every asset that wants to be assigned to both labels is going to be tiring. To alleviate the strain you can add child labels to a parent label. Any asset that's assigned to the child label is automatically assigned to the parent label too.

```
{
    labels: {
        sfx: {
        	//Mix all sound effects a little quieter always
            gain: 0.8

        	//All assets assigned to "speech" will automatically be assigned to "sfx"
            children: {
                speech: {
        			//Assets assigned to "speech" will vary their pitch a little
                    pitch: [0.9, 1.1]
                }
            }
        }
    }

    assets: {
        sndNPCYoungGirl: {
        	//This asset will also be assigned to "sfx"
            label: speech
        }
    }
}
```

&nbsp;

## Patterns

Patterns allow you to execute behaviours

1. Basic
2. Shuffle
3. Queue
4. Multi