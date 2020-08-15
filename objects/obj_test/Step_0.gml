if (keyboard_check_pressed(vk_space))
{
    var _pattern = vinyl_multi(snd_1, snd_2, snd_3);
    _pattern.synchronize = true;
    _pattern.loop = true;
    instance = vinyl_play(_pattern);
}

if (keyboard_check_pressed(ord("L")))
{
    instance = vinyl_play("loop_test");
}

if (keyboard_check_pressed(ord("1"))) instance.playing_index = 0;
if (keyboard_check_pressed(ord("2"))) instance.playing_index = 1;
if (keyboard_check_pressed(ord("3"))) instance.playing_index = 2;

if (keyboard_check_pressed(ord("S")))
{
    vinyl_stop(instance);
}