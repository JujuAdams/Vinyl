// Feather disable all

/// Fades out all voices currently playing in a given mix. Once a voice is set to fade out, it
/// cannot be stopped.
/// 
/// @param mixName
/// @param rateOfChange

function VinylMixFadeOutVoices(_mixName, _rateOfChange)
{
    static _mixDict = __VinylSystem().__mixDict;
    
    var _mixStruct = _mixDict[$ _mixName];
    if (_mixStruct == undefined) __VinylError("Mix \"", _mixName, "\" not recognised");
    
    _mixStruct.__FadeOutQueue(_rateOfChange);
}