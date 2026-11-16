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
    VinylStop(voice);
    voice = VinylPlay(snd1KHz);
    exclusiveLogic.Push(voice);
});
UISpace(20);
UIButton("Play music", function()
{
    VinylStop(voice);
    voice = VinylPlay(sndChickenNuggets);
    exclusiveLogic.Push(voice);
});
UISpace(20);
UIButton("Play bonk", function()
{
    VinylStop(voice);
    voice = VinylPlay(sndBonk);
    exclusiveLogic.Push(voice);
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