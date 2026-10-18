/// @param fadeTime

function VinylBrainExclusive(_fadeTime) : VinylBrainCommonConstructor(false) constructor
{
    __fadeTime = _fadeTime;
    
    __voice = undefined;
    
    static GetVoice = function(_voice)
    {
        return __voice;
    }
    
    static Push = function(_voice)
    {
        if (VinylGetAllStopped(_voice)) return;
        
        VinylFadeOut(__voice, __fadeTime);
        __voice = _voice;
        
        return self;
    }
    
    static ImplStop = function()
    {
        return VinylStop(__voice);
    }
    
    static ImplGetAnyPlaying = function()
    {
        return VinylGetAnyPlaying(__voice);
    }
    
    static ImplGetAllPlaying = function()
    {
        return VinylGetAllPlaying(__voice);
    }
    
    static ImplGetVoiceForFadeOut = function()
    {
        return __voice;
    }
    
    static ImplSetGain = function(_gain, _time)
    {
        return VinylSetGain(__voice, _gain, _time);
    }
    
    static ImplGetGain = function()
    {
        return VinylGetGain(__voice);
    }
    
    static ImplSetPitch = function(_pitch)
    {
        return VinylSetPitch(__voice, _pitch);
    }
    
    static ImplGetPitch = function()
    {
        return VinylGetPitch(__voice);
    }
    
    static ImplSetLoop = function(_state)
    {
        return VinylSetLoop(__voice, _state);
    }
    
    static ImplGetAnyLoop = function()
    {
        return VinylGetAnyLoop(__voice);
    }
    
    static ImplGetAllLoop = function()
    {
        return VinylGetAllLoop(__voice);
    }
    
    static ImplPause = function()
    {
        return VinylPause(__voice);
    }
    
    static ImplResume = function()
    {
        return VinylResume(__voice);
    }
    
    static ImplGetAllPaused = function()
    {
        return VinylGetAllPaused(__voice);
    }
    
    static ImplGetAnyPaused = function()
    {
        return VinylGetAnyPaused(__voice);
    }
}