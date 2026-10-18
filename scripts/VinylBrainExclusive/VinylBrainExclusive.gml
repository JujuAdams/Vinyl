/// @param fadeTime

function VinylBrainExclusive(_fadeTime) : __VinylClassBrainInterface() constructor
{
    __fadeTime = _fadeTime;
    
    __voice = undefined;
    
    static GetVoice = function(_voice)
    {
        return __voice;
    }
    
    static Push = function(_voice)
    {
        if ((_voice == undefined) || (not VinylGetAnyPlaying(_voice))) return;
        VinylFadeOut(__voice, __fadeTime);
        __voice = _voice;
        
        return self;
    }
    
    static __ImplStop = function()
    {
        return VinylStop(__voice);
    }
    
    static __ImplGetAnyPlaying = function()
    {
        return VinylGetAnyPlaying(__voice);
    }
    
    static __ImplGetAllPlaying = function()
    {
        return VinylGetAllPlaying(__voice);
    }
    
    static __ImplGetVoiceForFadeOut = function()
    {
        return __voice;
    }
    
    static __ImplSetGain = function(_gain, _time)
    {
        return VinylSetGain(__voice, _gain, _time);
    }
    
    static __ImplGetGain = function()
    {
        return VinylGetGain(__voice);
    }
    
    static __ImplSetPitch = function(_pitch)
    {
        return VinylSetPitch(__voice, _pitch);
    }
    
    static __ImplGetPitch = function()
    {
        return VinylGetPitch(__voice);
    }
    
    static __ImplSetLoop = function(_state)
    {
        return VinylSetLoop(__voice, _state);
    }
    
    static __ImplGetAnyLoop = function()
    {
        return VinylGetAnyLoop(__voice);
    }
    
    static __ImplGetAllLoop = function()
    {
        return VinylGetAllLoop(__voice);
    }
    
    static __ImplPause = function()
    {
        return VinylPause(__voice);
    }
    
    static __ImplResume = function()
    {
        return VinylResume(__voice);
    }
    
    static __ImplGetAllPaused = function()
    {
        return VinylGetAllPaused(__voice);
    }
    
    static __ImplGetAnyPaused = function()
    {
        return VinylGetAnyPaused(__voice);
    }
}