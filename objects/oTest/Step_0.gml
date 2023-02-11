if (keyboard_check_pressed(ord("M")))
{
    music = VinylPlayFadeIn(sndChickenNuggets, true);
}

if (keyboard_check_pressed(ord("C")))
{
    VinylLoopSet(music, false);
}

if (keyboard_check_pressed(vk_up))
{
    VinylPitchTargetSet(music, VinylPitchTargetGet(music) + 1/9);
}

if (keyboard_check_pressed(vk_down))
{
    VinylPitchTargetSet(music, VinylPitchTargetGet(music) - 1/9);
}

if (keyboard_check_pressed(ord("S")))
{
    if (keyboard_check(vk_control))
    {
        VinylStop("music");
    }
    else
    {
        VinylStop(music);
    }
}

if (keyboard_check_pressed(ord("F")))
{
    VinylFadeOut(music);
}

if (keyboard_check_pressed(vk_space))
{
    VinylPlay(sndTestTone, false, 1, 1);
}

if (keyboard_check_pressed(ord("P")))
{
    VinylPause("music");
}

if (keyboard_check_pressed(ord("R")))
{
    VinylResume("music");
}

if (keyboard_check_pressed(ord("T")))
{
    VinylPlaySimple("shuffle test");
}

VinylKnobSet("delayTime", mouse_x / room_width);