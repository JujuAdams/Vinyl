UIStart(10, 10, 8);

UIText("Vinyl " + __VINYL_VERSION + ", " + __VINYL_DATE + "\nLibrary by @jujuadams, music \"Chicken Nuggets\" by @WangleLine");
UIText("Top Level Active = " + string(VinylSystemGetTopLevelVoiceCount()) + " / Total Active = " + string(VinylSystemGetTotalVoiceCount()) + " / Inactive = " + string(VinylSystemGetPoolInactiveCount()));

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

UIButtonInline("Stop all non-persistent", function()
{
    VinylStopAllNonPersistent();
});

UIButtonInline("Test tone", function()
{
    music = VinylPlay(snd1KHz, true);
});

UINewline();

UITextInline("Global transpose = " + string(VinylGlobalTransposeGet()));

UIButtonInline("Tranpose up", function()
{
    VinylGlobalTransposeSet(VinylGlobalTransposeGet() + 1);
});

UIButtonInline("Tranpose down", function()
{
    VinylGlobalTransposeSet(VinylGlobalTransposeGet() -1);
});

UISpace(30);
UITextInline("@delay time = " + string_format(VinylKnobGet("delay time"), 2, 2) + " -> " + string_format(VinylKnobOutputGet("delay time"), 2, 2));

UIButtonInline("Delay up", function()
{
    VinylKnobSet("delay time", VinylKnobGet("delay time") + 0.1);
});

UIButtonInline("Delay down", function()
{
    VinylKnobSet("delay time", VinylKnobGet("delay time") - 0.1);
});

UIButtonInline("Delay target 0", function()
{
    VinylKnobTargetSet("delay time", 0, 0.1);
});

UIButtonInline("Delay target 1", function()
{
    VinylKnobTargetSet("delay time", 1, 0.5);
});

UINewline();

UIText("music: VinylExists() = " + string(VinylExists(music))
     + ", VinylShutdownGet() = " + string(VinylShutdownGet(music))
     + ", VinylLoopGet() = " + string(VinylLoopGet(music))
     + ", VinylPersistentGet() = " + string(VinylPersistentGet(music))
     + ", VinylPatternGet() = " + string(VinylPatternGet(music)));

UIButtonInline("Play music", function()
{
    if (VinylStackPatternGet("music", 0) != sndChickenNuggets)
    {
        music = VinylPlay(sndChickenNuggets);
        VinylStopCallbackSet(music,
                             function(_data, _id)
                             {
                                 show_message(string(_id) + " said \"" + string(_data) + "\" on stop");
                             },
                             "boop");
    }
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

UIButtonInline("Persistent toggle", function()
{
     VinylPersistentSet(music, !VinylPersistentGet(music));
});

UINewline();

UITextInline("\"music\" label count = " + string(VinylLabelVoiceCountGet("music")));

UIButtonInline("Stop \"music\" label", function()
{
     VinylStop("music");
});

UIButtonInline("Fade out \"music\" label", function()
{
     VinylFadeOut("music");
});

UIButtonInline("Pause \"music\" label", function()
{
    VinylPause("music");
});

UIButtonInline("Resume \"music\" label", function()
{
    VinylResume("music");
});

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

UIButtonInline("Bleep shuffle (standard)", function()
{
    VinylPlay("bleep shuffle");
});

UIButtonInline("Bleep shuffle (simple)", function()
{
    VinylPlaySimple("bleep shuffle");
});

UINewline();

UIButtonInline("Music sync test", function()
{
    if (VinylStackPatternGet("music", 1) != sndChickenNuggets)
    {
        music = VinylPlay("music sync test");
    }
});

UIButtonInline("Queue test", function()
{
    VinylPlay("queue test");
});

UINewline();

UIButtonInline("Queue loop test", function()
{
    VinylPlay("queue loop test");
});

UINewline();

UIButtonInline("500hz Peak EQ test", function()
{
    VinylKnobSet("peak freq", 0);
    VinylPlay("cat peak eq");
});

UIButtonInline("1Khz Peak EQ test", function()
{
    VinylKnobSet("peak freq", 0.5);
    VinylPlay("cat peak eq");
});

UIButtonInline("1.5Khz Peak EQ test", function()
{
    VinylKnobSet("peak freq", 1);
    VinylPlay("cat peak eq");
});

UIButtonInline("Low Shelf EQ test", function()
{
    VinylPlay("cat low shelf");
});

UIButtonInline("High Shelf EQ test", function()
{
    VinylPlay("cat high shelf");
});

UIButtonInline("Mulitband EQ test", function()
{
    VinylPlay("music multiband eq");
});

UINewline();