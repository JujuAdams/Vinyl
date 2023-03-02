# Pausing

&nbsp;

The functions on this page can be used to pause and resume audio playback.

Audio playback can also be paused by a [stack](Stacks) if a sound is played with a higher priority, though that uses a different system and cannot be manually adjusted.

&nbsp;

## `VinylPause`

`VinylPause(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|

Pauses playback of a [voice](Voice) or [label](Label). Playback can be resumed using `VinylResume()` (see below).

If a label is specified instead then all currently playing voices assigned to the label are paused individually. The label itself does not hold a "paused" state and any new audio played on that label will not start paused.

#### **Example**

```gml
//Pause the game when the player pressed escape
if (keyboard_check_pressed(vk_escape))
{
	//Make sure the background loops pause
	VinylPause("music");
	VinylPause("ambience");
    
    //Stop sound effects entirely
    VinylStop("sfx");
    
    //Create the pause menu handler
	instance_create_layer(x, y, "GUI", oPauseMenu);
}
```

<!-- tabs:end -->

&nbsp;

## `VinylPausedGet`

`VinylPausedGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Boolean, whether the given [voice](Terminology) is paused

|Name    |Datatype|Purpose        |
|--------|--------|---------------|
|`target`|voice   |Voice to target|

?> You cannot get a "paused" state from a label as they have no independent paused state.

#### **Example**

```gml
//If we're paused, draw a flash pause symbol top-right
if (VinylPausedGet(global.backgroundMusic))
{
	//Flash at with the pattern of 150ms on, 150ms off
	if ((current_time mod 300) < 150)
	{
		draw_sprite(sprPaused, 0, 10, display_gui_get_width() - 10);
	}
}
```

<!-- tabs:end -->

&nbsp;

## `VinylResume`

`VinylResume(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|

Resumes playback of a [voice](Voice) or [label](Label). If a label is provided instead then all currently playing voices assigned to the label are resumed.

#### **Example**

```gml
//Unpause the game when the player selects "RESUME"
if ((menuOption == 3) && keyboard_check_pressed(vk_enter))
{
	//Resume playback of the background audio
	VinylResume("music");
	VinylResume("ambience");
    
    instance_destroy();
}
```

<!-- tabs:end -->