if (keyboard_check_pressed(vk_space))
{
    VinylPlay(sndBleep2);
}

if (keyboard_check_pressed(vk_shift))
{
    VinylPlay("shuffle");
}

if (keyboard_check_pressed(ord("B")))
{
    blendVoice = VinylPlay(vinBlendTest);
}

VinylSetBlend(blendVoice, mouse_x / room_width);