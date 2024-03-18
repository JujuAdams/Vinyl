if (keyboard_check_pressed(vk_space))
{
    VinylPlay(snd1KHz);
}

if (keyboard_check_pressed(vk_shift))
{
    VinylPlay(__VINYL_RUNTIME_PATTERN_MASK+1);
}