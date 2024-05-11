// Feather disable all

/// Sets the local gain for the mix. This is multipled with the base gain (see VinylSetupMix()) to
/// give a gain factor applied to all audio played on this mix. Setting the local gain for a mix
/// will affect all current and future audio played on the mix.
/// 
/// @param mixName
/// @param gain

function VinylMixSetLocalGain(_mixName, _gain)
{
    static _mixDict = __VinylSystem().__mixDict;
    
    var _mixStruct = _mixDict[$ _mixName];
    if (_mixStruct == undefined) __VinylError("Mix \"", _mixName, "\" not recognised");
    
    _mixStruct.__SetLocalGain(_gain);
}