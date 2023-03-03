# Quick Start Guide

There's a lot you can do with Vinyl, but sticking to simple stuff is the best way to get started. This guide will take you through five things:

1. Importing Vinyl
2. Basic audio playback
3. Setting up Vinyl's [configuration file](Config-File) for your audio assets
4. Basic use of labels
5. Basic use of stacks

&nbsp;

## Importing Vinyl

!> Vinyl is intended for use with Git, or an equivalent source control system.

You can find the latest version of Vinyl [here](https://github.com/JujuAdams/Vinyl/releases). Make sure that you're using a version of GameMaker that Vinyl supports, and then download the `.yymps` from that page and import into GameMaker. You'll see a folder called `Vinyl` appear in your asset browser, and a file called `vinyl.dat` will also be created in your Included Files.

If you look inside the Vinyl folder you'll see a lot of subfolders. These subfolders contain functions that comprise the API - the interface that you'll need to execute Vinyl code in your game. The `(Internals)` folder holds code that Vinyl requires to operate and has to be there but otherwise you can forget it exists. You'll also see two scripts and a Note asset (`__VinylConfigMacros` `__VinylConfigDebug` `__VinylConfig`). You'll be using these to customise Vinyl for your use case.

?> When you import `__VinylConfig` it'll contain some example data. If you run your game straight away you'll likely see warnings or outright errors. If you want to postpone getting Vinyl ready for use, delete the entire contents of `__VinylConfig` and that'll avoid errors on boot.

&nbsp;

## Basic Audio Playback

&nbsp;

## The Config File

&nbsp;

## Labels

&nbsp;

## Stacks