VinylGroupAdd("test").GainSet(-10);
VinylGroupAdd("test2").PitchSet(2.0);

loopTest = VinylQueue(snd_music_intro, VinylLoop(VinylRandom(snd_music_loop_1, snd_music_loop_2, snd_music_loop_3)), snd_music_outro);
footstep = VinylRandom(snd_1, snd_2, snd_3, snd_4, snd_5).GroupAdd("test", "test2");

instance = undefined;