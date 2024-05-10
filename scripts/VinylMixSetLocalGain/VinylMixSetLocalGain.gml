// Feather disable all

/// @param mixName
/// @param gain

function VinylMixSetLocalGain(_mixName, _gain)
{
    static _mixDict = __VinylSystem().__mixDict;
    
    var _mixStruct = _mixDict[$ _mixName];
    if (_mixStruct == undefined) __VinylError("Mix \"", _mixName, "\" not recognised");
    
    _mixStruct.__SetGain(_gain);
}