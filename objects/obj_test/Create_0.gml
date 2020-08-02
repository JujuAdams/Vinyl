vinyl_lib.loop_test = vinyl_loop(snd_music_intro, snd_music_loop_1, snd_music_outro);
vinyl_lib.footstep = vinyl_random(snd_1, snd_2, snd_3, snd_4, snd_5);

instance = undefined;

with(vinyl_buss_create("sound effect")) //This buss is a child of "master"
{
    //These two buss are children of "sound effect"
    vinyl_buss_create("footsteps");
    vinyl_buss_create("narration");
}