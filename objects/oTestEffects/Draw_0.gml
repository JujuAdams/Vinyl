draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButtonInline("Play On", function()
{
    VinylPlayOn(reverbEmitter, sndOw);
});
UINewline();
UIButtonInline("Play bleep on echo emitter", function()
{
    VinylPlayOn(oBackground.emitter, sndBleep0);
});
UINewline();
UIButtonInline("Play fallback sound using defined emitter", function()
{
    VinylPlay(VinylFallbackSound);
});