draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("External Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButtonInline("Load bleep", function()
{
    VinylSetupExternal("sndBleepExternal.wav");
    VinylSetupShuffle("external shuffle", "sndBleepExternal.wav", undefined, [1/1.5, 1.5]);
});
UIButtonInline("Play bleep", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndBleepExternal.wav");
});
UIButtonInline("Play bleep shuffle", function()
{
    VinylStop(voice);
    voice = VinylPlay("external shuffle");
});
UIButtonInline("Unload bleep", function()
{
    VinylUnloadExternal("sndBleepExternal.wav");
});
UINewline();
UIButtonInline("Load music", function()
{
    VinylSetupExternal("sndChickenNuggetsExternal.ogg");
});
UIButtonInline("Play music", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndChickenNuggetsExternal.ogg");
});
UIButtonInline("Unload music", function()
{
    VinylUnloadExternal("sndChickenNuggetsExternal.ogg");
});
UINewline();
UINewline();
UIButtonInline("Load low bitrate cat (should error)", function()
{
    VinylSetupExternal("sndCatLowBitrateExternal.wav");
});
UINewline();
UIButtonInline("Load cat (8-bit)", function()
{
    VinylSetupExternal("sndCat8External.wav");
});
UIButtonInline("Play cat (8)", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndCat8External.wav");
});
UIButtonInline("Unload cat (8)", function()
{
    VinylUnloadExternal("sndCat8External.wav");
});
UINewline();
UIButtonInline("Load cat (16-bit)", function()
{
    VinylSetupExternal("sndCat16External.wav");
});
UIButtonInline("Play cat (16)", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndCat16External.wav");
});
UIButtonInline("Unload cat (16)", function()
{
    VinylUnloadExternal("sndCat16External.wav");
});