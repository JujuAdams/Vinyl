draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIButtonInline("Play pitch variation", function()
{
    VinylPlay(pitchVariationLogic);
});
UINewline();
UINewline();
UIButtonInline("Play random", function()
{
    array_push(historyArray, VinylGetAsset(VinylPlay(randomLogic)));
});
UISpace(20);
UIButtonInline("Play shuffle", function()
{
    array_push(historyArray, VinylGetAsset(VinylPlay(shuffleLogic)));
});
UISpace(20);
UIButtonInline("Clear history", function()
{
    array_resize(historyArray, 0);
});
UINewline();
UIText(json_stringify(historyArray, true));