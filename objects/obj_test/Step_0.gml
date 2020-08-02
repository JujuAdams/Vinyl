if (keyboard_check_pressed(vk_space))
{
    vinyl_play(snd_1);
}

if (keyboard_check_pressed(ord("L")))
{
    vinyl_play(vinyl_lib.loop_test);
    //var _instance = new __vinyl_class_loop(new __vinyl_class_gm_audio(snd_1));
    //ds_list_add(global.__vinyl_playing, _instance);
}