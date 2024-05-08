// Feather disable all

/// @param voice
/// @param gainLocal
/// @param pitchLocal
/// @param gainFactor
/// @param pitchFactor
/// @param pattern

function __VinylClassVoiceSound(_voice, _gainLocal, _pitchLocal, _gainFactor, _pitchFactor, _pattern) constructor
{
    static _voiceStructUpdateArray = __VinylSystem().__voiceStructUpdateArray;
    
    __voice       = _voice;
    __gainLocal   = _gainLocal;
    __pitchLocal  = _pitchLocal;
    __gainFactor  = _gainFactor;
    __pitchFactor = _pitchFactor;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern = _pattern;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutStart = undefined;
    __gainFadeOutSpeed = undefined;
    
    
    
    
    
    static __IsPlaying = function()
    {
        return audio_is_playing(__voice);
    }
    
    static __Stop = function()
    {
        audio_stop_sound(__voice);
    }
    
    static __Update = function(_delta)
    {
        __gainFadeOut -= __gainFadeOutSpeed*_delta;
        if (__gainFadeOut <= 0)
        {
            __Stop();
            return false;
        }
        
        audio_sound_gain(__voice, __gainFadeOutStart*__gainFadeOut, VINYL_STEP_DURATION);
        return true;
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        if (__gainFadeOutStart == undefined)
        {
            __gainFadeOutStart = audio_sound_get_gain(__voice);
            array_push(_voiceStructUpdateArray, self);
        }
        
        __gainFadeOutSpeed = max(0.001, _rateOfChange);
    }
}