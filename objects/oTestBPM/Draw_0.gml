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
    VinylSetPitch(voice, 1);
    bpm = originalBPM;
});
UIButtonInline("Shuffle", function()
{
    VinylStop(voice);
    voice = VinylPlay("bpmShuffle", true);
    VinylSetPitch(voice, 1);
    bpm = originalBPM;
});
UIButtonInline("HLT", function()
{
    VinylStop(voice);
    voice = VinylPlay("bpmHLT", true);
    VinylSetPitch(voice, 1);
    bpm = originalBPM;
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
    
    bpm = originalBPM;
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
UIButtonInline("Change BPM", function()
{
    if (bpm == originalBPM)
    {
        bpm = originalBPM * 2;
    }
    else
    {
        bpm = originalBPM;
    }
    
    var _pitchMultiplier = VinylGetPitchForBPM("bpmShuffle", bpm);
    VinylSetPitch(voice, _pitchMultiplier, 100);
});
UINewline();
UIText($"track position   = {VinylGetTrackPosition(voice)}\nbeat this step   = {VinylGetBeatThisStep(voice)}\nbeat count       = {VinylGetBeatCount(voice)}\nbeat distance    = {VinylGetBeatDistance(voice, false)}\nbeat dist (secs) = {VinylGetBeatDistance(voice)}\ncurrent bpm = {bpm}\ncurrent pitch = {VinylGetPitch(voice)}");

if (VinylGetBeatThisStep(voice))
{
    VinylPlay(sndBleep0);
}