draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("External Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButtonInline("Play external bleep", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndBleepExternal.wav");
});
UIButtonInline("Play external music", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndChickenNuggetsExternal.ogg");
});