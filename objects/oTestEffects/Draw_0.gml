draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UIButton("Play On", function()
{
    VinylPlayOn(reverbEmitter, sndOw);
});
UINewline();
UIButton("Play bleep on echo emitter", function()
{
    VinylPlayOn(oBackground.emitter, sndBleep0);
});
UINewline();
UIButton("Play fallback sound using defined emitter", function()
{
    VinylPlay(VinylFallbackSoundIDE);
});