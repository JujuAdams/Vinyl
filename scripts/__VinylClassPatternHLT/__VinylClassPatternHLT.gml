// Feather disable all

/// @param patternIndex
/// @param soundHead
/// @param soundLoop
/// @param soundTail
/// @param gainForce
/// @param gainMin
/// @param gainMax

function __VinylClassPatternHLT(_patternIndex, _soundHead, _soundLoop, _soundTail, _gainForce, _gainMin, _gainMax) constructor
{
    __patternIndex = _patternIndex;
    
    __soundHead = __VinylImportSound(_soundHead);
    __soundLoop = __VinylImportSound(_soundLoop);
    __soundTail = __VinylImportSound(_soundTail);
    __gainForce = _gainForce;
    __gainMin   = _gainMin;
    __gainMax   = _gainMax;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _gainPattern = __VinylRandomRange(__gainMin,  __gainMax);
        var _voice = audio_play_sound(__soundHead, 0, false, _gainLocal*_gainPattern, 0, _pitchLocal);
        __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern).__pattern = __patternIndex;
        return _voice;
    }
    
    static __Update = function(_soundHead, _soundLoop, _soundTail, _gainForce, _gainMin, _gainMax)
    {
        __soundHead = __VinylImportSound(_soundHead);
        __soundLoop = __VinylImportSound(_soundLoop);
        __soundTail = __VinylImportSound(_soundTail);
        __gainForce = _gainForce;
        __gainMin   = _gainMin;
        __gainMax   = _gainMax;
    }
}