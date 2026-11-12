draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonNewline("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIText("Exclusive:");
UINewline();
UISpace(20);
UIText($"playing = {VinylGetPlaying(exclusiveLogic)? "true" : "false"}, asset = {VinylGetAsset(exclusiveLogic)}");
UINewline();
UIButton("Play 1KHz", function()
{
    exclusiveLogic.Push(VinylPlay(snd1KHz));
});
UISpace(20);
UIButton("Play music", function()
{
    exclusiveLogic.Push(VinylPlay(sndChickenNuggets));
});
UISpace(20);
UIButton("Play bonk", function()
{
    exclusiveLogic.Push(VinylPlay(sndBonk));
});
UINewline();
UINewline();
UIText("Limit:");
UINewline();
UISpace(20);
UIText($"playing = {VinylGetPlaying(limitLogic)? "true" : "false"}, count = {limitLogic.GetCount()}, allowed = {limitLogic.GetAllowed()? "true" : "false"}");
UINewline();
UIButton("Play meow", function()
{
    limitLogic.Push(VinylPlay(sndCat));
});