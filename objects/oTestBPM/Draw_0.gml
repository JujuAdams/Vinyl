draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButtonInline("Play", function()
{
    VinylStop(voice);
    voice = VinylPlay(sndSync1, true);
    VinylSetPitch(voice, 0.5);
});
UIButtonInline("Pause", function()
{
    VinylSetPause(voice, true);
});
UIButtonInline("Resume", function()
{
    VinylSetPause(voice, false);
});
UIButtonInline("Stop", function()
{
    VinylStop(voice);
});
UINewline();
UIText($"track position   = {VinylGetTrackPosition(voice)}\nbeat this step   = {VinylGetBeatThisStep(voice)}\nbeat count       = {VinylGetBeatCount(voice)}\nbeat distance    = {VinylGetBeatDistance(voice, false)}\nbeat dist (secs) = {VinylGetBeatDistance(voice)}");

if (VinylGetBeatThisStep(voice))
{
    VinylPlay("Shuffle");
}