draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UIText($"system pressure = {VinylGetSystemPressure()}");
UINewline();
UIText($"voice={voice}, playing={VinylIsPlaying(voice)}");
UIText($"gain={VinylGetGain(voice)}, f.gain={VinylGetFinalGain(voice)}");
UIText($"pitch={VinylGetPitch(voice)}, f.pitch={VinylGetFinalPitch(voice)}");
UINewline();
UIButtonInline("Play", function()
{
    VinylStop(voice);
    voice = VinylAbstract();
});
UISpace(10);
UIButtonInline("Play from pattern", function()
{
    VinylStop(voice);
    voice = VinylPlay("abstractPattern");
});
UISpace(10);
UIButtonInline("Stop", function()
{
    VinylStop(voice);
});
UINewline();
UIButtonInline("gain = 0", function()
{
    VinylSetGain(voice, 0);
});
UIButtonInline("gain = 2", function()
{
    VinylSetGain(voice, 2);
});
UIButtonInline("Fade Out", function()
{
    VinylFadeOut(voice);
});
UINewline();
UINewline();
UIButtonInline("Stop all abstract", function()
{
    VinylAbstractStopAll();
});