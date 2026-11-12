draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIText(string_concat("Vinyl ", VINYL_VERSION, ", ", VINYL_DATE, " by Juju Adams\nChicken Nuggets by Wangle Line"));
UINewline();
UIButton("Queue Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestQueues);
});
UIButton("Effects Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestEffects);
});
UIButton("Abstract Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestAbstract);
});
UIButton("PlayAt Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestPlayAt);
});
UINewline();
UIButton("External Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestExternal);
});
UIButton("Ducker Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestDucker);
});
UIButton("BPM Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestBPM);
});
UINewline();
UINewline();
UIText(string_concat("\"Test\" mix gain = ", VinylMixGetGain("Test")));
UINewline();
UIButton("Mix gain -", function()
{
    VinylMixSetGain("Test", VinylMixGetGain("Test") - 0.05);
});
UISpace(20);
UIButton("Mix gain +", function()
{
    VinylMixSetGain("Test", VinylMixGetGain("Test") + 0.05);
});
UISpace(20);
UIButton("Mix slow 0", function()
{
    VinylMixSetGain("Test", 0, 0.05);
});
UISpace(20);
UIButton("Mix slow 1", function()
{
    VinylMixSetGain("Test", 1, 0.05);
});
UINewline();
UINewline();
UIButton("1KHz", function()
{
    VinylPlay(snd1KHz);
});
UISpace(20);
UIButton("Shuffle Bleeps", function()
{
    VinylPlay("Shuffle");
});
UISpace(20);
UIButton("Blast Start", function()
{
    alarm[0] = 4;
});
UISpace(20);
UIButton("Blast End", function()
{
    alarm[0] = -1;
});
UINewline();
UINewline();
UIButton("HLT Test", function()
{
    hltVoice = VinylPlay("HLT");
});
UISpace(20);
UIButton("HLT End Loop", function()
{
    VinylSetLoop(hltVoice, false);
});
UINewline();
UINewline();
UIButton("Blend Test", function()
{
    blendVoice = VinylPlay("Blend");
});
UISpace(20);
UIButton("Factor -", function()
{
    VinylSetBlendFactor(blendVoice, (VinylGetBlendFactor(blendVoice) ?? 0) - 0.05);
});
UISpace(20);
UIButton("Factor +", function()
{
    VinylSetBlendFactor(blendVoice, (VinylGetBlendFactor(blendVoice) ?? 0) + 0.05);
});
UINewline();
UINewline();
UIButton("Set 1KHz gain high", function()
{
    VinylSetupSound(snd1KHz, 1.3, undefined, true);
});
UISpace(20);
UIButton("Set 1KHz gain low", function()
{
    VinylSetupSound(snd1KHz, 0.7, undefined, true);
});
UINewline();
UIButton("Set 1KHz no mix", function()
{
    VinylSetupSound(snd1KHz, undefined, undefined, true, VINYL_NO_MIX);
});
UISpace(20);
UIButton("Set 1KHz \"Test\" mix", function()
{
    VinylSetupSound(snd1KHz, undefined, undefined, true, "Test");
});
UINewline();
UINewline();
UIButton("Start callback test", function()
{
    global.callbackTestVoice = VinylPlay(sndSync0, true);
    VinylLogicOnStop(global.callbackTestVoice, undefined, function()
    {
        show_debug_message("Callback triggered");
    });
});
UISpace(20);
UIButton("Stop callback test", function()
{
    VinylStop(global.callbackTestVoice);
});
UINewline();
UINewline();
UIButton("Play fade out test", function()
{
    fadeOutPauseTest = VinylPlay(sndChickenNuggets, true);
});
UISpace(20);
UIButton("Fade out to pause", function()
{
    VinylFadeOut(fadeOutPauseTest, undefined, true);
});
UINewline();
UIButton("Fade out to stop", function()
{
    VinylFadeOut(fadeOutPauseTest, 1);
});
UISpace(20);
UIButton("Unpause test", function()
{
    VinylSetPaused(fadeOutPauseTest, false);
});
UISpace(20);
UIButton("Stop Test", function()
{
    VinylStop(fadeOutPauseTest);
});