VINYL_LIB.loop_test = VinylLoop(snd_music_intro, snd_music_loop_1, snd_music_outro);
VINYL_LIB.footstep = VinylRandom(snd_1, snd_2, snd_3, snd_4, snd_5);

//instance = undefined;
//
//with(VinylBussCreate("sound effect")) //This buss is a child of "master"
//{
//    //These two buss are children of "sound effect"
//    VinylBussCreate("footsteps");
//    VinylBussCreate("narration");
//}