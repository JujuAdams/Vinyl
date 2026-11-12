draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UITextInline("Exclusive:");
UINewline();
UISpace(20);
UITextInline($"playing = {VinylGetPlaying(exclusiveLogic)? "true" : "false"}, asset = {VinylGetAsset(exclusiveLogic)}");
UINewline();
UIButtonInline("Play 1KHz", function()
{
    exclusiveLogic.Push(VinylPlay(snd1KHz));
});
UISpace(20);
UIButtonInline("Play music", function()
{
    exclusiveLogic.Push(VinylPlay(sndChickenNuggets));
});
UISpace(20);
UIButtonInline("Play bonk", function()
{
    exclusiveLogic.Push(VinylPlay(sndBonk));
});
UINewline();
UINewline();
UITextInline("Limit:");
UINewline();
UISpace(20);
UITextInline($"playing = {VinylGetPlaying(limitLogic)? "true" : "false"}, count = {limitLogic.GetCount()}, allowed = {limitLogic.GetAllowed()? "true" : "false"}");
UINewline();
UIButtonInline("Play meow", function()
{
    limitLogic.Push(VinylPlay(sndCat));
});