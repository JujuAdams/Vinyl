VinylGroupAdd("test").PitchSet(1.0);

VinylLibAdd("loop test", VinylQueue(snd_music_intro, VinylLoop(VinylRandom(snd_music_loop_1, snd_music_loop_2, snd_music_loop_3)), snd_music_outro));
VinylLibAdd("footstep", VinylRandom(snd_1, snd_2, snd_3, snd_4, snd_5).GroupAdd("test"));

instance = undefined;