draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIText($"Mix group \"{VinylMixGetExportName(MIX_SFX)}\" any playing = {VinylMixGetAnyPlaying(MIX_SFX)? "true" : "false"}");
UIText($"Mix group \"{VinylMixGetExportName(MIX_MUSIC)}\" any playing = {VinylMixGetAnyPlaying(MIX_MUSIC)? "true" : "false"}");
UINewline();
UIButtonInline("Play sfx", function()
{
    VinylPlay(sndCat);
});
UISpace(30);
UIButtonInline("Stop \"sfx\"", function()
{
    VinylMixStop(MIX_SFX);
});
UISpace(30);
UIButtonInline("Pause \"sfx\"", function()
{
    VinylMixPause(MIX_SFX);
});
UISpace(30);
UIButtonInline("Resume \"sfx\"", function()
{
    VinylMixResume(MIX_SFX);
});
UINewline();
UIButtonInline("Play music", function()
{
    VinylPlay(sndChickenNuggets, true);
});
UISpace(30);
UIButtonInline("Stop \"music\" mix group", function()
{
    VinylMixStop(MIX_MUSIC);
});
UINewline();