# Introduction

&nbsp;

Vinyl is an audio system built for GameMaker 2023.2 that serves as a replacement for GameMaker's audio API. It builds on top of what GameMaker already provides by wrapping functionality in a more convenient form and by adding altogether new audio features for GameMaker games. Its biggest feature is being able to live update the properties and behaviour of audio without recompiling your game.

There is one particular feature that Vinyl does **not** concern itself with, and that's loading audio via GameMaker's native audio groups. At some point in the future this may change, but GameMaker's audio group system works well enough for memory management so I don't feel a pressing need to augment it. Using audio groups to manage gain is crap though and Vinyl happily replaces that functionality with [its own label system](Labels).

Vinyl is a library of two halves: 1) Configuration 2) The API. As a solo developer you'll need to familiarise yourself with both. In a team with a dedicated audio designer you may find that it's efficient to leave the bulk of the configuration work to the audio designer so that a programmer can focus on hooking up game events to Vinyl's API. At any rate, the API is simple enough that even a reluctant coder will get along fine implementing audio.

&nbsp;

## Importing Vinyl

!> Vinyl is intended for use with Git, or an equivalent source control system. You should set up source control before importing Vinyl.

You can find the latest version of Vinyl [here](https://github.com/JujuAdams/Vinyl/releases). Make sure that you're using a version of GameMaker that Vinyl supports, and then download the `.yymps` from that page and import into your GameMaker project. You'll see a folder called `Vinyl` appear in your asset browser, and a file called `vinyl.dat` will also be created in your Included Files.

If you look inside the Vinyl folder you'll see a lot of subfolders. These subfolders contain functions that comprise the API - the interface that you'll need to execute Vinyl code in your game. The `(Internals)` folder holds code that Vinyl requires to operate and has to be there but otherwise you can forget it exists. You'll also see two scripts and a Note asset (`__VinylConfigMacros` `__VinylConfigDebug` `__VinylConfig`). You'll be using these to customise Vinyl for your use case.

You may notice that `vinyl.dat` frequently shows inscrutiable changes in your source control. Don't worry! `vinyl.dat` is regenerated for every compile from `__VinylConfig` and doesn't contain persistent data. You can either add `vinyl.dat` to your `.gitignore`, or you can literally ignore any changes made to that file.

&nbsp;

## Configuration

Vinyl splits configuration into three sources, two being a couple of scripts that hold macros (which is fairly typical) and the other being a configuration file held in a Note asset that gets dynamically attached to your game at compile time (which is fairly atypical).

You can find information about the two macro scripts, `__VinylConfigMacros` and `__VinylDebugMacros`, [here](Config-Macros) and [here](Debug-Macros). Each script contains a handful of macros that you can adjust to get Vinyl operating exactly how you want. You should edit these scripts.

The configuration file is stored in `__VinylConfig` and has its own particular syntax and expects data to be formatted in [a certain way](Config-File). You can use this file to control the underlying gains, pitches, and behaviours of audio played with Vinyl. When you import Vinyl for the first time, this config file will be filled with an empty template. You'll need to add information to the file to customise Vinyl.

`__VinylConfig` can be edited whilst the game is running from the IDE on Windows, Mac, or Linux. If Vinyl detects that a change has been made, Vinyl will live update audio playback without you having to close and recompile the entire game. This means you can finesse your audio mix without having to stop playing the game - a substantial workflow improvement over what GameMaker offers natively.

&nbsp;

## The API

This is where the rubber meets the road, so to speak. Configuring audio is all well and good but at some point you'll need to execute functions to get Vinyl to do anything. There are no special setup functions to call - you can start calling Vinyl functions straight away after importing it.

If you take a look at the sidebar, the API is split across multiple different features. Each broad feature gets its own page, and on each page there's a description of feature, any quirks you need to be aware of, and functions that interact with that feature. Where I've had time I've also added example code to make things a bit quicker to pick up.

Functions are rarely complex and follow GML-ish conventions. Many functions take a [voice](Voices) as an argument, and these functions *often* (but not *always*) accept a label too. With only a few exceptions ([1](Gain)) ([2](Pitch)), if you provide a label instead of a voice ID then the operation in question will be executed for each individual voice assigned to that label. [Labels do not carry much state](State) and so operations will typically pass through them and then get picked up by voices themselves.

&nbsp;

## Updating Vinyl

Vinyl is distributed as a `.yymps`. Standard practice when importing these sorts of files into GameMaker is to delete the existing library completely before reimporting it, and this is still broadly an effective technique for Vinyl. However, `__VinylConfig` comes packaged with the Vinyl library and, as such, replacing Vinyl necessarily means replacing `__VinylConfig` and erasing all of the work you put in configuring your audio.

There's no great trick to get around this - make a backup of `__VinylConfig` before updating, or restore the old file from your source control history. You may find that you need to do similar things to restore macros in [`__VinylConfigMacros`](Config-Macros) and [`__VinylDebugMacros`](Debug-Macros). *You're using source control, right? You really should be using source control.*
