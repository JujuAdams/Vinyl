draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});

UINewline();
UITextInline($"Master gain = {VinylMasterGetGain()}");
UISpace(30);
UIButtonInline("- master gain", function()
{
    VinylMasterSetGain(VinylMasterGetGain() - 0.1);
});
UIButtonInline("+ master gain", function()
{
    VinylMasterSetGain(VinylMasterGetGain() + 0.1);
});
UINewline();
UIButton("Stop all", function()
{
    VinylStopAll();
});
UINewline();
UIButton("Play one-time sound", function()
{
    VinylPlayOmni(sndCat);
});
UINewline();
UIButtonInline("Play loop", function()
{
    VinylStop(loopVoice);
    loopVoice = VinylPlayOmni(sndChickenNuggets, true);
});
UISpace(10);
UIButtonInline("Stop loop", function()
{
    VinylStop(loopVoice);
});
UINewline();
UITextInline($"playing = {VinylGetPlaying(loopVoice)? "true" : "false"} / stopped = {VinylGetStopped(loopVoice)? "true" : "false"}");
UINewline();
UITextInline($"Gain = {VinylGetGain(loopVoice)}");
UISpace(30);
UIButtonInline("- gain", function()
{
    VinylSetGain(loopVoice, VinylGetGain(loopVoice) - 0.1);
});
UIButtonInline("+ gain", function()
{
    VinylSetGain(loopVoice, VinylGetGain(loopVoice) + 0.1);
});
UINewline();
UITextInline($"Pitch = {VinylGetPitch(loopVoice)}");
UISpace(30);
UIButtonInline("- pitch", function()
{
    VinylSetPitch(loopVoice, VinylGetPitch(loopVoice) - 0.1);
});
UIButtonInline("+ pitch", function()
{
    VinylSetPitch(loopVoice, VinylGetPitch(loopVoice) + 0.1);
});
UINewline();
UITextInline($"Loop = {VinylGetLoop(loopVoice)? "true" : "false"}");
UISpace(30);
UIButtonInline("Toggle loop", function()
{
    VinylSetLoop(loopVoice, not VinylGetLoop(loopVoice));
});
UINewline();
UITextInline($"Paused = {VinylGetPaused(loopVoice)? "true" : "false"}");
UISpace(30);
UIButtonInline("Toggle paused", function()
{
    VinylSetPaused(loopVoice, not VinylGetPaused(loopVoice));
});