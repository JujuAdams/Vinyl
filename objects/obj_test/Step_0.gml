if (keyboard_check_pressed(vk_space))
{
    vinyl_play(vinyl_lib.footstep);
}

if (keyboard_check_pressed(ord("L")))
{
    instance = vinyl_play("loop_test");
}

if (keyboard_check_pressed(ord("S")))
{
    vinyl_stop(instance);
}