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

UIButtonInline("Test tone", function()
{
    music = VinylPlay(snd1KHz, true);
});

UITextInline("Global transpose = " + string(VinylGlobalTransposeGet()));

UIButtonInline("Tranpose up", function()
{
    VinylGlobalTransposeSet(VinylGlobalTransposeGet() + 1);
});

UIButtonInline("Tranpose down", function()
{
    VinylGlobalTransposeSet(VinylGlobalTransposeGet() -1);
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

UIButtonInline("Stop \"music\" label", function()
{
     VinylStop("music");
});

UIButtonInline("Fade out \"music\" label", function()
{
     VinylFadeOut("music");
});

UINewline();
UINewline();

UIButtonInline("Bonk left", function()
{
    VinylPlay(sndBonk, false, 1, 1, -1);
});

UIButtonInline("Bonk centre", function()
{
    VinylPlay(sndBonk, false, 1, 1, 0);
});

UIButtonInline("Bonk right", function()
{
    VinylPlay(sndBonk, false, 1, 1, 1);
});

UIButtonInline("Ow!", function()
{
    VinylPlay(sndOw);
});

UIButtonInline("Ow! but simple", function()
{
    VinylPlaySimple(sndOw);
});

UIButtonInline("Normal cat", function()
{
    VinylPlay(sndCat);
});

UIButtonInline("Space cat", function()
{
    VinylPlay("space cat", false, 1, 1, random_range(-1, 1));
});

UIButtonInline("Bleep shuffle", function()
{
    VinylPlaySimple("bleep shuffle");
});

UINewline();
UINewline();

UIButtonInline("Music sync test", function()
{
    music = VinylPlay("music sync test");
});

UIButtonInline("Queue test", function()
{
    VinylPlay("queue test");
});

UINewline();
UINewline();