draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UINewline();
UIButtonInline("Simple", function()
{
    VinylStop(voice);
    voice = VinylPlay(sndSync1, true);
    bpmBrain = new VinylBrainBPM(voice, originalBPM, true);
    bpm = originalBPM;
});
UISpace(30);
UIButtonInline("Shuffle", function()
{
    VinylStop(voice);
    voice = VinylPlay(shuffleBrain, true);
    bpmBrain = new VinylBrainBPM(voice, originalBPM, true);
    bpm = originalBPM;
});
UISpace(30);
UIButtonInline("HLT", function()
{
    VinylStop(voice);
    voice = VinylPlay(hltBrain, true);
    bpmBrain = new VinylBrainBPM(voice, originalBPM, true);
    bpm = originalBPM;
});
UISpace(30);
UIButtonInline("Blend", function()
{
    VinylStop(voice);
    voice = VinylPlay(soundArray, true);
    bpmBrain = new VinylBrainBPM(voice, originalBPM, true);
    bpm = originalBPM;
});
UINewline();
UIButtonInline("Pause", function()
{
    VinylSetPaused(voice, true);
});
UISpace(30);
UIButtonInline("Resume", function()
{
    VinylSetPaused(voice, false);
});
UISpace(30);
UIButtonInline("End Loop", function()
{
    VinylSetLoop(voice, false);
});
UISpace(30);
UIButtonInline("Stop", function()
{
    VinylStop(voice);
});
UISpace(30);
UIButtonInline("Change BPM", function()
{
    if (bpmBrain != undefined)
    {
        if (bpm == originalBPM)
        {
            bpm = 2*originalBPM;
        }
        else
        {
            bpm = originalBPM;
        }
        
        var _pitchMultiplier = bpmBrain.GetPitchForBPM(bpm);
        VinylSetPitch(voice, _pitchMultiplier);
    }
});
UINewline();

var _string = $"track position   = {VinylGetTrackPosition(voice)}\n";
_string += $"current bpm      = {bpm}\n";
_string += $"current pitch    = {VinylGetPitch(voice)}\n"

if (bpmBrain != undefined)
{
    _string += $"beat this step   = {bpmBrain.GetBeatThisStep()}\n"
    _string += $"beat count       = {bpmBrain.GetBeatCount()}\n";
    _string += $"beat distance    = {bpmBrain.GetBeatDistance(false)}\n";
    _string += $"beat dist (secs) = {bpmBrain.GetBeatDistance()}\n";
}

UIText(_string);

if ((bpmBrain != undefined) && bpmBrain.GetBeatThisStep())
{
    VinylPlay(sndBleep0);
}