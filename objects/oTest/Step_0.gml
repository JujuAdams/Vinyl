if (keyboard_check_pressed(ord("M")))
{
	music = VinylPlay(sndTestMusic, true);
}

if (keyboard_check_pressed(ord("S")))
{
	if (keyboard_check(vk_control))
	{
		VinylStopAll();
	}
	else
	{
		VinylStop(music);
	}
}