draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UITextInline(string_concat("Vinyl ", VINYL_VERSION, ", ", VINYL_DATE, " by Juju Adams\nChicken Nuggets by Wangle Line"));
UINewline();
UINewline();
UIButtonInline("Queue Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestQueues);
});
UIButtonInline("Effects Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestEffects);
});
UIButtonInline("Abstract Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestAbstract);
});
UIButtonInline("PlayAt Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestPlayAt);
});
UINewline();
UINewline();
UITextInline(string_concat("\"Test\" mix gain = ", VinylMixGetGain("Test")));
UINewline();
UIButtonInline("Mix gain -", function()
{
    VinylMixSetGain("Test", VinylMixGetGain("Test") - 0.05);
});
UISpace(20);
UIButtonInline("Mix gain +", function()
{
    VinylMixSetGain("Test", VinylMixGetGain("Test") + 0.05);
});
UISpace(20);
UIButtonInline("Mix slow 0", function()
{
    VinylMixSetGain("Test", 0, 0.05);
});
UISpace(20);
UIButtonInline("Mix slow 1", function()
{
    VinylMixSetGain("Test", 1, 0.05);
});
UINewline();
UINewline();
UIButtonInline("1KHz", function()
{
    VinylPlay(snd1KHz);
});
UISpace(20);
UIButtonInline("Shuffle Bleeps", function()
{
    VinylPlay("Shuffle");
});
UISpace(20);
UIButtonInline("Blast Start", function()
{
    alarm[0] = 4;
});
UISpace(20);
UIButtonInline("Blast End", function()
{
    alarm[0] = -1;
});
UINewline();
UINewline();
UIButtonInline("HLT Test", function()
{
    hltVoice = VinylPlay("HLT");
});
UISpace(20);
UIButtonInline("HLT End Loop", function()
{
    VinylSetLoop(hltVoice, false);
});
UINewline();
UINewline();
UITextInline(string_concat("Blend factor = ", VinylGetBlendFactor(blendVoice)));
UINewline();
UIButtonInline("Blend Test", function()
{
    blendVoice = VinylPlay("Blend");
});
UISpace(20);
UIButtonInline("Factor -", function()
{
    VinylSetBlendFactor(blendVoice, (VinylGetBlendFactor(blendVoice) ?? 0) - 0.05);
});
UISpace(20);
UIButtonInline("Factor +", function()
{
    VinylSetBlendFactor(blendVoice, (VinylGetBlendFactor(blendVoice) ?? 0) + 0.05);
});
UINewline();
UINewline();
UIButtonInline("Set 1KHz gain high", function()
{
    VinylSetupSound(snd1KHz, 1.3, undefined, true);
});
UISpace(20);
UIButtonInline("Set 1KHz gain low", function()
{
    VinylSetupSound(snd1KHz, 0.7, undefined, true);
});
UINewline();
UIButtonInline("Set 1KHz no mix", function()
{
    VinylSetupSound(snd1KHz, undefined, undefined, true, VINYL_NO_MIX);
});
UISpace(20);
UIButtonInline("Set 1KHz \"Test\" mix", function()
{
    VinylSetupSound(snd1KHz, undefined, undefined, true, "Test");
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
UINewline();
UINewline();
UIButtonInline("Start callback test", function()
{
    global.callbackTestVoice = VinylPlay(sndSync0, true);
    VinylCallbackOnStop(global.callbackTestVoice, function()
    {
        show_debug_message("Callback triggered");
    });
});
UISpace(20);
UIButtonInline("Stop callback test", function()
{
    VinylStop(global.callbackTestVoice);
});
UINewline();
UINewline();
UIButtonInline("Play fade out test", function()
{
    fadeOutPauseTest = VinylPlay(sndChickenNuggets, true);
});
UISpace(20);
UIButtonInline("Fade out to pause", function()
{
    VinylFadeOut(fadeOutPauseTest, undefined, true);
});
UINewline();
UIButtonInline("Unpause test", function()
{
    VinylSetPause(fadeOutPauseTest, false);
});
UISpace(20);
UIButtonInline("Stop Test", function()
{
    VinylStop(fadeOutPauseTest);
});