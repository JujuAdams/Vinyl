// Feather disable all

/// @param mixName
/// @param rateOfChange

function VinylMixFadeOutVoices(_mixName, _rateOfChange)
{
    static _mixDict = __VinylSystem().__mixDict;
    
    var _mixStruct = _mixDict[$ _mixName];
    if (_mixStruct == undefined) __VinylError("Mix \"", _mixName, "\" not recognised");
    
    _mixStruct.__FadeOutVoices(_rateOfChange);
}