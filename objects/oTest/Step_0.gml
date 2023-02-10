VinylListenerSet(mouse_x, mouse_y);

if (keyboard_check_pressed(vk_up))
{
    VinylPitchTargetSet(music, VinylPitchTargetGet(music) + 1/9);
}

if (keyboard_check_pressed(vk_down))
{
    VinylPitchTargetSet(music, VinylPitchTargetGet(music) - 1/9);
}

if (keyboard_check_pressed(ord("F")))
{
    VinylFadeOut(music);
}