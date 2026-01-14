# Config Macros

&nbsp;

The following macros can be found in the `__VinylConfigMacros` script. You should adjust these macros according to your needs. When updating Vinyl, you will usually need to back up any macros that you've changed and then restore those values after updating the library.

&nbsp;

## `VINYL_MAX_VOICE_GAIN`

*Typical value: `2`*

Maximum final gain for audio voices. Must be greater than or equal to zero. Setting this value higher will allow for higher gain values throughout Vinyl but may lead to degraded audio quality.

&nbsp;

## `VINYL_MASTER_GAIN_BOOST`

*Typical value: `1`*

Boost to global master gain. This is helpful to tame audio levels if they're too loud or to increase audio levels if they're too quiet.

&nbsp;

## `VINYL_SET_LISTENER_ORIENTATION`

*Typical value: `true`*

Whether to set a more helpful listener orientation at the start of the game. This improves on the frankly bizarre default listener orientation that GameMaker uses. If this macro is set to `true` the following code will be executed when the game starts:

```
audio_listener_set_orientation(0,   0, 0, 1,   0, -1, 0);
```

&nbsp;

## `VINYL_AUDIO_FALLOFF_MODEL`

*Typical value: `audio_falloff_linear_distance_clamped`*

Falloff model to set on boot. Please see GameMaker documentation for `audio_falloff_set_model()` more information. Set this macro to `undefined` to not set a falloff model on boot (at the time of writing, GameMaker's default model is `audio_falloff_none` which isn't very helpful).

&nbsp;

## `VINYL_DEFAULT_FALLOFF_*`

|Macro                           |Typical value|
|--------------------------------|-------------|
|`VINYL_DEFAULT_FALLOFF_DIST`    |`0`          |
|`VINYL_DEFAULT_FALLOFF_MAX_DIST`|`100`        |
|`VINYL_DEFAULT_FALLOFF_FACTOR`  |`1`          |

Default values to use for `VinylPlayAt()`. Please see GameMaker documentation for `audio_play_sound_at()` more information.

&nbsp;

## `VINYL_NO_MIX`

*Typical value: `"no mix"`*

The name to use to indicate no mix. This should be a unique string and cannot be used for the name of mixes when calling `VinylSetupMix()` or `VinylSetupImportJSON()`.

&nbsp;

## `VINYL_DEFAULT_MIX`

*Typical value: `VINYL_NO_MIX`*

The default mix to use for all sounds and patterns unless otherwise specified. If you set this macro to `VINYL_NO_MIX` then no mix will be set by default.

&nbsp;

## `VINYL_DEFAULT_FADE_IN_RATE`

*Typical value: `1`*

The default fade-in rate for `VinylPlayFadeIn()` operations. This macro is measured in "gain units per second".

&nbsp;

## `VINYL_DEFAULT_FADE_OUT_RATE`

*Typical value: `1`*

The default fade-out rate for `VinylFadeOut()` and `VinylMixFadeOutVoices()` operations. This macro is measured in "gain units per second".

&nbsp;

## `VINYL_SAFE_JSON_IMPORT`

*Typical value: `true`*

Whether to rigorously check imported JSON when calling VinylSetupImportJSON(). This is useful to catch errors in JSON but carries a performance penality. You may want to consider setting this macro to `false` for production builds after your JSON import has been thoroughly tested.

&nbsp;

## `VINYL_LIVE_EDIT`

*Typical value: `true`*

Whether live editing is enabled.

&nbsp;

## `VINYL_STEP_DURATION`

*Typical value: `50`*

Length of moment-to-moment gain adjustments, in milliseconds. Choose lower values for tigher, quicker gain adjustment or choose higher values for smooth, less glitchy gain adjustment.

&nbsp;

## `VINYL_WILL_STOP_TOLERANCE`

*Typical value: `20`*

How far from the end of an audio asset to determine the audio as finishing, measured in milliseconds. This is used for audio scheduling for head-loop-tail and queue voices.