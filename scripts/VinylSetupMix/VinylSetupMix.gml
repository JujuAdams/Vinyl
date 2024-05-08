// Feather disable all

/// @param mixName
/// @param [baseGain=1]

function VinylSetupMix(_mixName, _baseGain = 1)
{
    static _mixDict = __VinylSystem().__mixDict;
    
    if (_mixName == VINYL_NO_MIX)
    {
        __VinylError("Cannot set up a new mix with the same name as VINYL_NO_MIX (\"", VINYL_NO_MIX, "\")");
    }
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _mixDict[$ _mixName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__Update(_baseGain);
    }
    else
    {
        _mixDict[$ _mixName] = new __VinylClassMix(_mixName, _baseGain);
    }
}