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
    VinylPlay(retrigger);
});
UISpace(20);
UIButton("Stop", function()
{
    VinylStop(retrigger);
});
UINewline();
UIText($"playing = {VinylGetPlaying(retrigger)? "true" : "false"}");