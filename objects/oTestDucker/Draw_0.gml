draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UITextNewline($"duckPrio0 playing = {VinylIsPlaying(duckPrio0)}");
UITextNewline($"duckPrio1 playing = {VinylIsPlaying(duckPrio1)}");
UINewline();
UIButton("Ducker bleep", function()
{
    duckPrio0 = VinylPlay(sndDucker1KHz);
});
UIButton("Ducker 1KHz", function()
{
    duckPrio1 = VinylPlay(sndDucker1KHz);
});
UINewline();
UINewline();
UIButton("Ducker prio 0", function()
{
    duckPrio0 = VinylPlay(sndSync0, true);
});
UISpace(20);
UIButton("Ducker prio 1", function()
{
    duckPrio1 = VinylPlay(sndSync1, true);
});
UISpace(20);
UIButton("Ducker prio 2", function()
{
    duckPrio2 = VinylPlay(sndSync2, true);
});
UINewline();
UIButton("Fade out prio 0", function()
{
    VinylFadeOut(duckPrio0, 1);
    duckPrio0 = undefined;
});
UISpace(20);
UIButton("Fade out prio 1", function()
{
    VinylFadeOut(duckPrio1, 1);
    duckPrio1 = undefined;
});
UISpace(20);
UIButton("Fade out prio 2", function()
{
    VinylFadeOut(duckPrio2, 1);
    duckPrio2 = undefined;
});