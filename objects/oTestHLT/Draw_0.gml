draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonNewline("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIButton("Play", function()
{
    voice = VinylPlay(hlt);
});
UISpace(20);
UIButton("Stop", function()
{
    VinylStop(voice);
});
UISpace(20);
UIButton("Fade Out", function()
{
    VinylFadeOut(voice, 1);
});
UINewline();
UIButton("Toggle loop", function()
{
    VinylSetLoop(voice, not VinylGetLoop(voice));
});
UISpace(20);
UIText($"loop = {VinylGetLoop(voice)? "true" : "false"}");
UINewline();
UIText($"state = {VinylGetPlaying(voice)? voice.GetStage() : "<no hlt playing>"}");
UINewline();
UIText($"playing = {VinylGetPlaying(voice)? "true" : "false"} / stopped = {VinylGetStopped(voice)? "true" : "false"}");