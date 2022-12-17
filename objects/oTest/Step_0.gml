if (keyboard_check_pressed(ord("M")))
{
	music = VinylPlay(sndChickenNuggets, true);
}

if (keyboard_check_pressed(vk_up))
{
	VinylGainTargetSet(music, VinylGainTargetGet(music) + 6);
}

if (keyboard_check_pressed(vk_down))
{
	VinylGainTargetSet(music, VinylGainTargetGet(music) - 6);
}

if (keyboard_check_pressed(ord("S")))
{
	if (keyboard_check(vk_control))
	{
		VinylStop("music");
	}
	else
	{
		VinylStop(music);
	}
}