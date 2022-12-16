if (keyboard_check_pressed(ord("M")))
{
	music = VinylPlay(sndTestMusic, true);
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