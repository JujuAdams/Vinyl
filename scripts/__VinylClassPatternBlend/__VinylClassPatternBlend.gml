// Feather disable all

/// @param patternIndex
/// @param soundArray
/// @param gainForce
/// @param gain

function __VinylClassPatternBlend(_patternIndex, _soundArray, _gainForce, _gain) constructor
{
    __patternIndex = _patternIndex;
    
    __soundArray = __VinylImportSoundArray(_soundArray);
    __gainForce  = _gainForce;
    __gain       = _gain;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _struct = new __VinylClassVoiceBlend(self);
        return _struct.__voiceTop;
    }
    
    static __Update = function(_soundArray, _gainForce, _gain)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __gainForce  = _gainForce;
        __gain       = _gain;
        
        //TODO - Change tracks over for extant currently-playing blend voices
    }
}