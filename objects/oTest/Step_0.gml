if (keyboard_check_pressed(ord("1")))
{
    VinylBasic(snd_1).Play();
}

if (keyboard_check_pressed(ord("2")))
{
    VinylBasic(snd_1).SetGain(0.5, 1.0).Play();
}

if (keyboard_check_pressed(ord("3")))
{
    VinylBasic(snd_1).SetPitch(0.5, 1.0).Play();
}

if (keyboard_check_pressed(ord("4")))
{
    VINYL_LIB.footstep.Play();
}

//if (keyboard_check_pressed(vk_space))
//{
//    instance = VinylLoop(snd_1, snd_2, snd_3).Play();
//}

if (keyboard_check_pressed(ord("L")))
{
    instance = VINYL_LIB.loop_test.Play();
}

//if (keyboard_check_pressed(ord("1"))) instance.playing_index = 0;
//if (keyboard_check_pressed(ord("2"))) instance.playing_index = 1;
//if (keyboard_check_pressed(ord("3"))) instance.playing_index = 2;
//
//if (keyboard_check_pressed(ord("Q")))
//{
//    var _array = instance.sources;
//    _array[@ array_length(_array)] = snd_4;
//}

if (keyboard_check_pressed(ord("S")))
{
    if (!keyboard_check(vk_shift))
    {
        instance.Stop();
    }
    else
    {
        instance.StopNow();
    }
}