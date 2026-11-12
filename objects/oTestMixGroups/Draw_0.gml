draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonNewline("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UITextNewline($"Mix group \"{VinylMixGetExportName(MIX_SFX)}\" any playing = {VinylMixGetAnyPlaying(MIX_SFX)? "true" : "false"}");
UITextNewline($"Mix group \"{VinylMixGetExportName(MIX_MUSIC)}\" any playing = {VinylMixGetAnyPlaying(MIX_MUSIC)? "true" : "false"}");
UINewline();
UIButton("Play sfx", function()
{
    VinylPlay(sndCat);
});
UISpace(30);
UIButton("Stop \"sfx\"", function()
{
    VinylMixStop(MIX_SFX);
});
UISpace(30);
UIButton("Pause \"sfx\"", function()
{
    VinylMixPause(MIX_SFX);
});
UISpace(30);
UIButton("Resume \"sfx\"", function()
{
    VinylMixResume(MIX_SFX);
});
UINewline();
UIButton("Play music", function()
{
    VinylPlay(sndChickenNuggets, true);
});
UISpace(30);
UIButton("Stop \"music\" mix group", function()
{
    VinylMixStop(MIX_MUSIC);
});
UINewline();