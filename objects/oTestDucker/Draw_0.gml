draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIText($"duckPrio0 playing = {VinylIsPlaying(duckPrio0)}");
UIText($"duckPrio1 playing = {VinylIsPlaying(duckPrio1)}");
UINewline();
UIButtonInline("Ducker bleep", function()
{
    duckPrio0 = VinylPlay(sndDucker1KHz);
});
UIButtonInline("Ducker 1KHz", function()
{
    duckPrio1 = VinylPlay(sndDucker1KHz);
});
UINewline();
UINewline();
UIButtonInline("Ducker prio 0", function()
{
    duckPrio0 = VinylPlay(sndSync0, true);
});
UISpace(20);
UIButtonInline("Ducker prio 1", function()
{
    duckPrio1 = VinylPlay(sndSync1, true);
});
UISpace(20);
UIButtonInline("Ducker prio 2", function()
{
    duckPrio2 = VinylPlay(sndSync2, true);
});
UINewline();
UIButtonInline("Fade out prio 0", function()
{
    VinylFadeOut(duckPrio0);
    duckPrio0 = undefined;
});
UISpace(20);
UIButtonInline("Fade out prio 1", function()
{
    VinylFadeOut(duckPrio1);
    duckPrio1 = undefined;
});
UISpace(20);
UIButtonInline("Fade out prio 2", function()
{
    VinylFadeOut(duckPrio2);
    duckPrio2 = undefined;
});