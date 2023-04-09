# Gain

&nbsp;

## `VinylGainSet`

`VinylGainSet(target, gain)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype      |Purpose                                                                                                                                                             |
|--------|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`target`|voice or label|The voice or label to target                                                                                                                                        |
|`gain`  |number        |Voice gain to set, in normalised gain units, greater than or equal to `0`. Defaults to `1`, no change in volume. Applied multiplicatively with other sources of gain|

Sets the gain of a [voice](Voice) or [label](Label).

If a voice is specified, the voice gain is set. This gain is independent of, for example, label gain, asset gain, and system gain.

If a label is specified, the gain for the label is set. This will immediately impact all current voices assigned to that label, and will impact future voices too.

#### **Example**

```gml
//Get our music volume from the settings
var _musicGain = global.settings.musicGain;

//Make sure we're not setting a silly value
_musicGain = clamp(_musicGain, 0, 1);

//Apply the new gain to the "music" label
VinylGainSet("music", _musicGain);
```

<!-- tabs:end -->

&nbsp;

## `VinylGainGet`

`VinylGainGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the gain for the [voice](Voice) or [label](Label)

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|

#### **Example**

```gml
//Go to the next room when the "ambience" label has faded out
if (waitForAmbience && (VinylGainGet("ambience") <= 0))
{
    show_debug_message("Ambience faded out, going to next room");
    room_goto_next();
}
```

<!-- tabs:end -->

&nbsp;

## `VinylGainTargetSet`

`VinylGainTargetSet(target, gain, [rate=VINYL_DEFAULT_GAIN_RATE])`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name    |Datatype        |Purpose                                                                                           |
|--------|----------------|--------------------------------------------------------------------------------------------------|
|`target`|voice or label  |Voice or label to target                                                                          |
|`gain`  |number          |Target gain, in normalised gain units                                                             |
|`[rate]`|number          |Speed to approach the target gain, in gain units per second. Defaults to `VINYL_DEFAULT_GAIN_RATE`|

Sets the target gain of a [voice](Voice) or [label](Label). The gain for that voice or label will change over time at the given rate until reaching its target.

!> Setting a target gain of `0` for a voice will not stop the voice when reaching silence. Please use `VinylFadeOut()` to fade out and stop a voice.

#### **Example**

```gml
//Enter through a door when the player presses the Enter key
if (keyboard_check_pressed(vk_enter) && place_meeting(x, y, oRoomExit))
{
    //Set up the fade out
    VinylGainTargetSet("ambience", 0);

    //And indicate we're waiting for the ambience to fade out
    waitForAmbience = true;
}
```

<!-- tabs:end -->

&nbsp;

## `VinylGainTargetGet`

`VinylGainTargetGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the target gain for the [voice](Voice) or [label](Label)

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|

#### **Example**

```gml
//If we're in debug mode and the secret (shift+J) keyboard combo is pressed ...
if (DEBUG_MODE && keyboard_check(vk_shift) && keyboard_check_pressed(ord("J"))
{
    //... output a debug message telling us what the target volume for the music is
    show_debug_message("Background music target = "
                     + string(VinylGainTargetGet(global.backgroundMusic)));
}
```

<!-- tabs:end -->

&nbsp;

## `VinylOutputGainGet`

`VinylOutputGainGet(target)`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the final output gain of the [voice](Voice) or [label](Label)

|Name    |Datatype      |Purpose                 |
|--------|--------------|------------------------|
|`target`|voice or label|Voice or label to target|

#### **Example**

```gml
//Find the coordinates of the view so our rectangle covers the entire screen
var _l = camera_get_view_x(camera);
var _t = camera_get_view_y(camera);
var _r = _l + camera_get_view_width(camera);
var _b = _t + camera_get_view_height(camera);

//Set the alpha blend factor based on the volume of the heartbeat sound
//This sound increases in volume when our health is low
var _alpha = lerp(0, 0.5, VinylOutputGainGet(heartbeat));

//Only draw the rectangle if we have to to save on GPU time where possible
if (_alpha > 0)
{
    draw_set_alpha(_alpha);
    draw_set_colour(c_red);
    draw_rectangle(_l, _t, _r, _b, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
```

<!-- tabs:end -->

&nbsp;

## `VinylSystemGainSet`

`VinylSystemGainSet(gain)`

<!-- tabs:start -->

#### **Description**

*Returns:* N/A (`undefined`)

|Name  |Datatype|Purpose    |
|------|--------|-----------|
|`gain`|number  |Gain to set|

Sets the gain of the overall system. You may want to use this for controlling the master volume of all sounds, or to compensate for platform-specific audio requirements.

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->

&nbsp;

## `VinylSystemGainGet`

`VinylSystemGainGet()`

<!-- tabs:start -->

#### **Description**

*Returns:* Number, the gain value for the entire system

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

#### **Example**

```gml
//TODO lol
```

<!-- tabs:end -->
