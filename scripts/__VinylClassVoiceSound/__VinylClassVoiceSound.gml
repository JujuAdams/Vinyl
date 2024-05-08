// Feather disable all

/// @param voice
/// @param gainLocal
/// @param pitchLocal
/// @param gainFactor
/// @param pitchFactor
/// @param pattern

function __VinylClassVoiceSound(_voice, _gainLocal, _pitchLocal, _gainFactor, _pitchFactor, _pattern) constructor
{
    __voice       = _voice;
    __gainLocal   = _gainLocal;
    __pitchLocal  = _pitchLocal;
    __gainFactor  = _gainFactor;
    __pitchFactor = _pitchFactor;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern = _pattern;
    }
    
    static __IsPlaying = function()
    {
        return audio_is_playing(__voice);
    }
    
    static __Stop = function()
    {
        audio_stop_sound(__voice);
    }
}