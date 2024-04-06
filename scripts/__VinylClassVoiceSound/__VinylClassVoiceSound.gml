// Feather disable all

/// @param voice
/// @param gainLocal
/// @param pitchLocal
/// @param gainFactor
/// @param pitchFactor

function __VinylClassVoiceSound(_voice, _gainLocal, _pitchLocal, _gainFactor, _pitchFactor) constructor
{
    __voice       = _voice;
    __gainLocal   = _gainLocal;
    __pitchLocal  = _pitchLocal;
    __gainFactor  = _gainFactor;
    __pitchFactor = _pitchFactor;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern = undefined;
    }
    
    static __IsPlaying = function()
    {
        return audio_is_playing(__voice);
    }
}