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
});
UIButtonInline("Play bleep", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndBleepExternal.wav");
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