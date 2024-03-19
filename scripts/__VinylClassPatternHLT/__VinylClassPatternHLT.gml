// Feather disable all

/// @param patternIndex
/// @param soundHead
/// @param soundLoop
/// @param soundTail
/// @param gainForce
/// @param gain

function __VinylClassPatternHLT(_patternIndex, _soundHead, _soundLoop, _soundTail, _gainForce, _gain) constructor
{
    __patternIndex = _patternIndex;
    
    __soundHead = __VinylImportSound(_soundHead);
    __soundLoop = __VinylImportSound(_soundLoop);
    __soundTail = __VinylImportSound(_soundTail);
    __gainForce = _gainForce;
    __gain      = _gain;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _struct = new __VinylClassVoiceHLT(self);
        return _struct.__currentVoice;
    }
    
    static __Update = function(_soundHead, _soundLoop, _soundTail, _gainForce, _gain)
    {
        __soundHead = __VinylImportSound(_soundHead);
        __soundLoop = __VinylImportSound(_soundLoop);
        __soundTail = __VinylImportSound(_soundTail);
        __gainForce = _gainForce;
        __gain      = _gain;
    }
}