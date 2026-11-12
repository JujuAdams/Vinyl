draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("External Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButton("Load bleep", function()
{
    VinylSetupExternal("sndBleepExternal.wav");
    VinylSetupShuffle("external shuffle", "sndBleepExternal.wav", undefined, [1/1.5, 1.5]);
});
UIButton("Play bleep", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndBleepExternal.wav");
});
UIButton("Play bleep shuffle", function()
{
    VinylStop(voice);
    voice = VinylPlay("external shuffle");
});
UIButton("Unload bleep", function()
{
    VinylUnloadExternal("sndBleepExternal.wav");
});
UINewline();
UIButton("Load music", function()
{
    VinylSetupExternal("sndChickenNuggetsExternal.ogg");
});
UIButton("Play music", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndChickenNuggetsExternal.ogg");
});
UIButton("Unload music", function()
{
    VinylUnloadExternal("sndChickenNuggetsExternal.ogg");
});
UINewline();
UINewline();
UIButton("Load low bitrate cat (should error)", function()
{
    VinylSetupExternal("sndCatLowBitrateExternal.wav");
});
UINewline();
UIButton("Load cat (8-bit)", function()
{
    VinylSetupExternal("sndCat8External.wav");
});
UIButton("Play cat (8)", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndCat8External.wav");
});
UIButton("Unload cat (8)", function()
{
    VinylUnloadExternal("sndCat8External.wav");
});
UINewline();
UIButton("Load cat (16-bit)", function()
{
    VinylSetupExternal("sndCat16External.wav");
});
UIButton("Play cat (16)", function()
{
    VinylStop(voice);
    voice = VinylPlay("sndCat16External.wav");
});
UIButton("Unload cat (16)", function()
{
    VinylUnloadExternal("sndCat16External.wav");
});