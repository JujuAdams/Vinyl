draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButtonInline("Simple", function()
{
    VinylStop(voice);
    voice = VinylPlay(sndSync1, true);
    VinylSetPitch(voice, 0.5);
});
UIButtonInline("Shuffle", function()
{
    VinylStop(voice);
    voice = VinylPlay("bpmShuffle", true);
    VinylSetPitch(voice, 0.5);
});
UIButtonInline("HLT", function()
{
    VinylStop(voice);
    voice = VinylPlay("bpmHLT", true);
    VinylSetPitch(voice, 0.5);
});
UIButtonInline("Blend", function()
{
    VinylStop(voice);
    voice = VinylPlay("bpmBlend", true);
    
    var _i = 0;
    repeat(VinylGetBlendMemberCount(voice))
    {
        VinylSetBlendMemberGain(voice, _i, 1);
        ++_i;
    }
});
UINewline();
UIButtonInline("Pause", function()
{
    VinylSetPause(voice, true);
});
UIButtonInline("Resume", function()
{
    VinylSetPause(voice, false);
});
UIButtonInline("End Loop", function()
{
    VinylSetLoop(voice, false);
});
UIButtonInline("Stop", function()
{
    VinylStop(voice);
});
UINewline();
UIText($"track position   = {VinylGetTrackPosition(voice)}\nbeat this step   = {VinylGetBeatThisStep(voice)}\nbeat count       = {VinylGetBeatCount(voice)}\nbeat distance    = {VinylGetBeatDistance(voice, false)}\nbeat dist (secs) = {VinylGetBeatDistance(voice)}");

if (VinylGetBeatThisStep(voice))
{
    VinylPlay(sndBleep0);
}