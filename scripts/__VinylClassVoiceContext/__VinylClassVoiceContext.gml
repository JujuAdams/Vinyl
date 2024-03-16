// Feather disable all

/// @param voice
/// @param gainLocal
/// @param gainFinal
/// @param pitchLocal
/// @param pitchFinal

function __VinylClassVoiceContext(_voice, _gainLocal, _gainFinal, _pitchLocal, _pitchFinal) constructor
{
    __voice      = _voice;
    __gainLocal  = _gainLocal;
    __gainFinal  = _gainFinal;
    __pitchLocal = _pitchLocal;
    __pitchFinal = _pitchFinal;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern = undefined;
    }
}