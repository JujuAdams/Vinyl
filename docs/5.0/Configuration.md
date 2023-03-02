# Configuration

&nbsp;

Vinyl is a powerful libraries with a lot of features. Keeping a handle on how it all interacts requires a custom solution. The core of Vinyl is a single configuration file that controls the underlying gains, pitches, and behaviours of audio played with Vinyl. You can find this configuration file in the Vinyl folder in your asset browser; its name is `__VinylConfig`. When you import Vinyl for the first time, this config file will be filled with some example configuration and some comments. You can see an online copy of this file [here](https://github.com/JujuAdams/Vinyl/blob/master/notes/__VinylConfig/__VinylConfig.txt).

?> The configuration file uses its own syntax and expects data to be formatted in a certain way. You can read about how to use `__VinylConfig` [here](Config-Syntax).

`__VinylConfig` can be edited whilst the game is running from the IDE on Windows, Mac, or Linux. If Vinyl detects that a change has been made, Vinyl will live update audio playback without you having to close and recompile the entire game. This means you can finesse your audio mix without having to stop playing the game - a substantial workflow improvement over what GameMaker offers natively.

In addition to the configuration file, Vinyl also has a couple other scripts used to control behaviour. These are [`__VinylConfigMacros`](Config-Macros) and [`__VinylDebugMacros`](Debug-Macros). Each script contains a handful of macros that you can adjust to get Vinyl operating exactly how you want. You should edit these scripts.

Vinyl is intended for use with Git, or an equivalent source control system. You may notice that during compilation, the `vinyl.dat` file in Included Files (called the `/datafiles` directory on disk) frequently shows changes. If you're working in a team, you can either add `vinyl.dat` to your `.gitignore` or you can literally ignore any changes made to that file. `vinyl.dat` is regenerated for every compile and doesn't contain persistent data that's relevant for other developers.

&nbsp;

### Updating Vinyl

Vinyl is distributed as a `.yymps`. Standard practice when importing these sorts of files into GameMaker is to delete the existing library completely before reimporting it, and this is still broadly an effective technique for Vinyl. However, `__VinylConfig` comes packaged with the Vinyl library and, as such, replacing Vinyl necessarily means replacing `__VinylConfig` and erasing all of the work you put in configuring your audio.

There's no great trick to get around this - make a backup of `__VinylConfig` before updating, or restore the old file from your source control history. You may find that you need to do similar things to restore macros in [`__VinylConfigMacros`](Config-Macros) and [`__VinylDebugMacros`](Debug-Macros). *You're using source control, right? You really should be using source control.*