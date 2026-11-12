draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonNewline("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIButton("Play pitch variation", function()
{
    VinylPlay(pitchVariationLogic);
});
UINewline();
UINewline();
UIButton("Play random", function()
{
    array_push(historyArray, VinylGetAsset(VinylPlay(randomLogic)));
});
UISpace(20);
UIButton("Play shuffle", function()
{
    array_push(historyArray, VinylGetAsset(VinylPlay(shuffleLogic)));
});
UISpace(20);
UIButton("Clear history", function()
{
    array_resize(historyArray, 0);
});
UINewline();
UITextNewline(json_stringify(historyArray, true));