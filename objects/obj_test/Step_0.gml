if (keyboard_check_pressed(vk_space))
{
    instance = VinylLoop(snd_1, snd_2, snd_3).Play();
}

if (keyboard_check_pressed(ord("L")))
{
    instance = VinylPlay("loop_test");
}

if (keyboard_check_pressed(ord("1"))) instance.playing_index = 0;
if (keyboard_check_pressed(ord("2"))) instance.playing_index = 1;
if (keyboard_check_pressed(ord("3"))) instance.playing_index = 2;

if (keyboard_check_pressed(ord("Q")))
{
    var _array = instance.sources;
    _array[@ array_length(_array)] = snd_4;
}

if (keyboard_check_pressed(ord("S")))
{
    instance.StopNow();
}