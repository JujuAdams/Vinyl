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
    VinylPlay(hlt);
});
UISpace(20);
UIButton("Stop", function()
{
    VinylStop(hlt);
});
UISpace(20);
UIButton("Fade Out", function()
{
    VinylFadeOut(hlt, 1);
});
UINewline();
UIButton("Toggle loop", function()
{
    VinylSetLoop(hlt, not VinylGetLoop(hlt));
});
UIText($"loop = {VinylGetLoop(hlt)? "true" : "false"}");
UINewline();
UIText($"state = {hlt.GetStage()}");
UISpace(20);
UIText($"playing = {VinylGetPlaying(hlt)? "true" : "false"} / stopped = {VinylGetStopped(hlt)? "true" : "false"}");
UINewline();