draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIButtonInline("Play", function()
{
    VinylPlay(hlt);
});
UISpace(20);
UIButtonInline("Stop", function()
{
    VinylStop(hlt);
});
UISpace(20);
UIButtonInline("Fade Out", function()
{
    VinylFadeOut(hlt, 1);
});
UINewline();
UIButtonInline("Toggle loop", function()
{
    VinylSetLoop(hlt, not VinylGetLoop(hlt));
});
UITextInline($"loop = {VinylGetLoop(hlt)? "true" : "false"}");
UINewline();
UITextInline($"state = {hlt.GetStage()}");
UISpace(20);
UITextInline($"playing = {VinylGetPlaying(hlt)? "true" : "false"} / stopped = {VinylGetStopped(hlt)? "true" : "false"}");
UINewline();