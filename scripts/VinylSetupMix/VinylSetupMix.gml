// Feather disable all

/// Sets up a mix that can be used to control multiple sounds, patterns, and voices all at the same
/// time. Mixes should be defined before sounds and patterns.
/// 
/// You should typically only call this function once on boot. Subsequent calls to this function
/// will only affect audio that is already playing if VINYL_LIVE_EDIT is set to <true>, and even
/// then calls to this function whilst audio is playing is expensive.
/// 
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