draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonNewline("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});

UINewline();
UIText($"Master gain = {VinylMasterGetGain()}");
UISpace(30);
UIButton("- master gain", function()
{
    VinylMasterSetGain(VinylMasterGetGain() - 0.1);
});
UIButton("+ master gain", function()
{
    VinylMasterSetGain(VinylMasterGetGain() + 0.1);
});
UINewline();
UIButtonNewline("Stop all", function()
{
    VinylStopAll();
});
UINewline();
UIButtonNewline("Play one-time sound", function()
{
    VinylPlay(sndCat);
});
UINewline();
UIButton("Play loop", function()
{
    VinylStop(loopVoice);
    loopVoice = VinylPlay(sndChickenNuggets, true);
});
UISpace(10);
UIButton("Stop loop", function()
{
    VinylStop(loopVoice);
});
UINewline();
UIText($"playing = {VinylGetPlaying(loopVoice)? "true" : "false"} / stopped = {VinylGetStopped(loopVoice)? "true" : "false"}");
UINewline();
UIText($"Gain = {VinylGetGain(loopVoice)}");
UISpace(30);
UIButton("- gain", function()
{
    VinylSetGain(loopVoice, VinylGetGain(loopVoice) - 0.1);
});
UIButton("+ gain", function()
{
    VinylSetGain(loopVoice, VinylGetGain(loopVoice) + 0.1);
});
UINewline();
UIText($"Pitch = {VinylGetPitch(loopVoice)}");
UISpace(30);
UIButton("- pitch", function()
{
    VinylSetPitch(loopVoice, VinylGetPitch(loopVoice) - 0.1);
});
UIButton("+ pitch", function()
{
    VinylSetPitch(loopVoice, VinylGetPitch(loopVoice) + 0.1);
});
UINewline();
UIText($"Loop = {VinylGetLoop(loopVoice)? "true" : "false"}");
UISpace(30);
UIButton("Toggle loop", function()
{
    VinylSetLoop(loopVoice, not VinylGetLoop(loopVoice));
});
UINewline();
UIText($"Paused = {VinylGetPaused(loopVoice)? "true" : "false"}");
UISpace(30);
UIButton("Toggle paused", function()
{
    VinylSetPaused(loopVoice, not VinylGetPaused(loopVoice));
});