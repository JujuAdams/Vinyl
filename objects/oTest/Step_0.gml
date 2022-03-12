if (keyboard_check_pressed(ord("1")))
{
    VinylBasic(snd_1).Play();
}

if (keyboard_check_pressed(ord("2")))
{
    VinylBasic(snd_1).GainSet(0.5, 1.0).Play();
}

if (keyboard_check_pressed(ord("3")))
{
    VinylBasic(snd_1).PitchSet(0.5, 1.0).Play();
}

if (keyboard_check_pressed(ord("4")))
{
    VinylLibPlay("footstep");
}

if (keyboard_check_pressed(ord("5")))
{
    VinylQueue(snd_1, snd_2, snd_3, snd_4, snd_5).Play();
}

if (keyboard_check_pressed(ord("6")))
{
    VinylMulti(snd_1, snd_2, snd_3, snd_4, snd_5).Play();
}

if (keyboard_check_pressed(ord("7")))
{
    VinylLoop(snd_1).Play();
}

if (keyboard_check_pressed(ord("8")))
{
    VinylLoop(VinylQueue(snd_1, snd_2, snd_3, snd_4, snd_5).PopSet(true, false)).Play();
}

if (keyboard_check_pressed(ord("9")))
{
    instance = VinylLoop(VinylMulti(snd_music_loop_1, snd_music_loop_2, snd_music_loop_3).SynchronizeSet(true).BlendSet(0)).Play();
}

if (keyboard_check_pressed(ord("Q")))
{
    VinylLoop(VinylBasic(snd_music_loop_1).SectionSet(0.5*audio_sound_length(snd_music_loop_1), audio_sound_length(snd_music_loop_1))).Play();
}

if (keyboard_check_pressed(ord("W")))
{
    VinylBasic(snd_music_loop_1).Play();
}

if (keyboard_check_pressed(ord("L")))
{
    instance = VinylLibPlay("loop test");
}

if (keyboard_check_pressed(ord("S")))
{
    if (keyboard_check(vk_shift))
    {
        instance.InstanceGet().Kill();
    }
    else
    {
        instance.InstanceGet().Stop();
    }
}

if (VinylIsSoundInstance(instance))
{
    //instance.InstanceGet().BlendSet(mouse_x/room_width);
}