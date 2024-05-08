// Feather disable all

/// @param mixName
/// @param [baseGain=1]

function VinylSetupMix(_mixName, _gainBase = 1)
{
    static _mixDict  = __VinylSystem().__mixDict;
    static _mixArray = __VinylSystem().__mixArray;
    
    if (_mixName == VINYL_NO_MIX)
    {
        __VinylError("Cannot set up a new mix with the same name as VINYL_NO_MIX (\"", VINYL_NO_MIX, "\")");
    }
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _mixDict[$ _mixName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_gainBase);
    }
    else
    {
        var _mixStruct = new __VinylClassMix(_mixName, _gainBase);
        _mixDict[$ _mixName] = _mixStruct;
        array_push(_mixArray, _mixStruct);
    }
}