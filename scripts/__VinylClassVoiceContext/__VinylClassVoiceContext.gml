// Feather disable all

/// @param voice
/// @param gainLocal
/// @param pitchLocal
/// @param gainPattern
/// @param pitchPattern

function __VinylClassVoiceContext(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern) constructor
{
    __voice        = _voice;
    __gainLocal    = _gainLocal;
    __pitchLocal   = _pitchLocal;
    __gainPattern  = _gainPattern;
    __pitchPattern = _pitchPattern;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern = undefined;
    }
}