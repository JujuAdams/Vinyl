if (keyboard_check_pressed(vk_space))
{
    VinylPlay(snd1KHz);
}

if (keyboard_check_pressed(vk_shift))
{
    VinylPlay(vinFootsteps);
}

if (keyboard_check_pressed(ord("C")))
{
    VinylHLTEndLoop(hltVoice);
}