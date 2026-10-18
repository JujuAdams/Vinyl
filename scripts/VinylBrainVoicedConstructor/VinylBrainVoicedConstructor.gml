/// @param [update=false]

function VinylBrainVoicedConstructor(_update = false) : VinylBrainParentConstructor(_update) constructor
{
    __voice = undefined;
    
    static GetVoice = function(_voice)
    {
        return __voice;
    }
    
    static ImplStop = function()
    {
        VinylStop(__voice);
    }
    
    static ImplGetAnyPlaying = function()
    {
        return VinylGetAnyPlaying(__voice);
    }
    
    static ImplGetAllPlaying = function()
    {
        return VinylGetAllPlaying(__voice);
    }
    
    static ImplGetWillStop = function()
    {
        return VinylGetWillStop(__voice);
    }
    
    static ImplGetFlatVoiceArray = function(_resultArray)
    {
        array_push(_resultArray, __voice);
    }
    
    static ImplGetTrackPosition = function()
    {
        return VinylGetTrackPosition(__voice);
    }
    
    static ImplSetGain = function(_gain, _time)
    {
        VinylSetGain(__voice, _gain, _time);
    }
    
    static ImplGetGain = function()
    {
        return VinylGetGain(__voice);
    }
    
    static ImplSetPitch = function(_pitch)
    {
        VinylSetPitch(__voice, _pitch);
    }
    
    static ImplGetPitch = function()
    {
        return VinylGetPitch(__voice);
    }
    
    static ImplSetLoop = function(_state)
    {
        VinylSetLoop(__voice, _state);
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
        VinylPause(__voice);
    }
    
    static ImplResume = function()
    {
        VinylResume(__voice);
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