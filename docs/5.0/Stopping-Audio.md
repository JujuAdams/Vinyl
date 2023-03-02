# Stopping Audio

&nbsp;

Stopping audio is a surprisingly involved process. Vinyl offers two basic ways to stop audio - stopping it instantly, or fading it out. Both methods can be applied to a single voice, all voices assigned to a label, or all voices currently playing. Alternatively, you can use the [persistence](Persistence) feature alongside the persistence-related stopper functions for a third way to stop audio playing.

&nbsp;

## `VinylStop`

`VinylStop(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                     |
|--------|--------------|----------------------------|
|`target`|voice or label|The voice or label to target|

Immediately stops playback of a voice and marks it as destroyed.

If a label is specified, each currently playing voice assigned to that label will be immediately stopped. The label itself has no "stopped" state and any new voices will be played as normal.

#### **Example**

```gml
//Oops we died
if (hp <= 0)
{
	//Stop any background music we're playing
	VinylStop("music");
	
    room_restart();
}
```

<!-- tabs:end -->

&nbsp;

## `VinylStopAll`

`VinylStopAll()`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Immediately stops playback of all currently playing voices and marks them as destroyed.

?> If you want a little more control of which voices get stopped, consider using `VinylStop()` with a [label](Labels), or using [`VinylStopAllNonPersistent()`](Persistence).

#### **Example**

```gml
//Quit to the main menu
if (keyboard_check_pressed(vk_escape))
{
    VinylStopAll();           //Stop everything!
    VinylPlay(sndTransition); //Play a nice "swoosh" to sell the transition
    room_goto(rMainMenu);
}
```

<!-- tabs:end -->

&nbsp;

## `VinylFadeOut`

`VinylFadeOut(target, [rate=VINYL_DEFAULT_GAIN_RATE])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                                   |
|--------|--------------|------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                              |
|`[rate]`|number        |Speed to approach silence, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Begins a fade out for a [voice](Voice) or [label](Label). This puts the voice into "shutdown mode" which can be detected later by [`VinylShutdownGet()`](Advanced).

If a voice is specified, the voice's gain will decrease at the given rate (in normalised gain units per second) until the gain reaches zero, at which point the sound is stopped and the voice is marked as destroyed.

If a label is specified, each currently playing voice assigned to that label will fade out. The label itself has no "fade out" state and any new voices will be played at their normal gain.

#### **Example**

```gml
//Enter through a door when the player presses the Enter key
if (keyboard_check_pressed(vk_enter) && place_meeting(x, y, oRoomExit))
{
    VinylGainTargetSet("ambience", 0); //Set up the fade out
    waitForAmbience = true;            //And indicate we're waiting for the ambience to fade out
}
```

<!-- tabs:end -->

&nbsp;

## `VinylFadeOutAll`

`VinylFadeOut(target, [rate=VINYL_DEFAULT_GAIN_RATE])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                             |
|--------|--------------|------------------------------------------------------------------------------------|
|`target`|voice or label|Voice or label to target                                                            |
|`[rate]`|number  |Speed to approach silence, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Begins a fade out for all currently playing voices. This puts all voices into "shutdown mode" which can be detected later by [`VinylShutdownGet()`](Advanced).

?> If you want a little more control of which voices get faded out, consider using `VinylFadeOut()` with a [label](Labels), or using [`VinylFadeOutAllNonPersistent()`](Persistence).

#### **Example**

```gml
instance_create_layer(x, y, "Instances", objBigBadBossman);

VinylFadeOutAll(0.1);                      //Fade out everything currently playing slowly for maximum impact
VinylPlayFadeIn(sndTheFinalShowdown, 0.1); //Fade in the epic end game boss music
```

<!-- tabs:end -->

&nbsp;

## `VinylShutdownGet`

`VinylShutdownGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether a [voice](Voices) is in "shutdown mode"

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|

#### **Example**

```gml
//Don't try to pitch shift the background music if we're fading it out
if (not VinylShutdownGet(global.backgroundMusic))
{
    VinylPitchTargetSet(global.backgroundMusic, 0.8);
}
```

<!-- tabs:end -->

&nbsp;

## `VinylStopCallbackSet`

`VinylStopCallbackSet(target, callback, [callbackData])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name            |Datatype                      |Purpose                                                                                                |
|----------------|------------------------------|-------------------------------------------------------------------------------------------------------|
|`target`        |voice or label                |Voice or label to target                                                                               |
|`callback`      |method, script, or `undefined`|Method or script to execute when the voice stops playing                                               |
|`[callbackData]`|any                           |Data to be passed into the callback when the voice stops playing. If not specified, `undefined` is used|

Sets a callback for execution when the voice stops playing. This callback will be executed no matter how the voice is stopped (e.g. via the sound ending, via a direct stop command, etc.). The callback function will be given two arguments:

|Argument   |Name         |Datatype|                                                               |
|-----------|-------------|--------|---------------------------------------------------------------|
|`argument0`|Callback data|any     |The data that was defined when calling `VinylStopCallbackSet()`|
|`argument1`|Voice ID     |number  |The ID of the voice that triggered the callback                |

#### **Example**

```gml
if (not dead)
{
	//Make sure we don't trigger this code more than once
	dead = true;

	//Play a sound effect on death
	var _urk = VinylPlay(sndDeathrattle);

	//Only actually destroy this instance after the sound stops
	VinylStopCallbackSet(_urk,
		                 function(_data, _voice)
	                     {
	                         instance_destroy(_data);
	                     }
	                     self);
 }
```

<!-- tabs:end -->

&nbsp;

## `VinylStopCallbackSet`

`VinylStopCallbackGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Struct, containing the callback and callback data as set by `VinylStopCallbackGet()`

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|

The struct returned from this function contains two member variables.

|Member    |Datatype                      |Usage                                                           |
|----------|------------------------------|----------------------------------------------------------------|
|`callback`|method, script, or `undefined`|Method or script to execute when the voice stops playing        |
|`data`    |any                           |Data to be passed into the callback when the voice stops playing|

!> The returned struct is static! Do not keep a copy of this struct as it is liable to change unexpectedly.

#### **Example**

```gml
//Grab whatever callback has been attached to the background music voice
var _callbackInfo = VinylStopCallbackGet(global.backgroundMusic);

//Only try to attach a callback if one hasn't been defined already
if (_callbackInfo.callback == undefined)
{
	VinylStopCallbackSet(global.backgroundMusic,
		                 function(_data, _voice)
	                     {
	                         room_goto(_data);
	                     }
	                     rBonusLevel);
 }
```

<!-- tabs:end -->