if (keyboard_check_pressed(vk_space))
{
    vinyl_play(vinyl_queue(snd_1, snd_2, snd_3, snd_4, snd_5));
}

if (keyboard_check_pressed(ord("L")))
{
    instance = vinyl_play("loop_test");
}

if (keyboard_check_pressed(ord("S")))
{
    vinyl_stop(instance);
}