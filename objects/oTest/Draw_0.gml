UIStart(10, 10, 8);
UIText("Vinyl " + __VINYL_VERSION + ", " + __VINYL_DATE);
UIText("Library by @jujuadams, music \"Chicken Nuggets\" by @WangleLine");
UINewline();

UITextInline("System gain = " + string_format(VinylSystemGainGet(), 0, 1));

UIButtonInline("System gain up", function()
{
    VinylSystemGainSet(VinylSystemGainGet() + 0.1);
});

UIButtonInline("System gain down", function()
{
    VinylSystemGainSet(VinylSystemGainGet() - 0.1);
});

UIButtonInline("Stop all", function()
{
    VinylStopAll();
});

UINewline();
UINewline();

UIText("music: VinylExists() = " + string(VinylExists(music)) + ", VinylShutdownGet() = " + string(VinylShutdownGet(music)) + ", VinylLoopGet() = " + string(VinylLoopGet(music)));

UIButtonInline("Play music", function()
{
    music = VinylPlay(sndChickenNuggets);
});

UIButtonInline("Stop music", function()
{
    VinylStop(music);
});

UIButtonInline("Fade in music", function()
{
    VinylStop(music);
    music = VinylPlayFadeIn(sndChickenNuggets);
});

UIButtonInline("Fade out music", function()
{
     VinylFadeOut(music);
});

UIButtonInline("Loop toggle", function()
{
     VinylLoopSet(music, !VinylLoopGet(music));
});

UINewline();
UINewline();

UIText("\"music\" label count = " + string(VinylLabelInstanceCountGet("music")));

UIButtonInline("Fade out music", function()
{
     VinylLabelInstanceCountGet("music");
});

UINewline();
UINewline();