// Feather disable all

/// @param sound
/// @param [gain]
/// @param [pitch]
/// @param [loop=false]

function VinylSetupSound(_sound, _gain = undefined, _pitch = undefined, _loop = false)
{
    static _soundDict = __VinylSystem().__soundDict;
    
    __VINYL_HANDLE_GAINS
    __VINYL_HANDLE_PITCHES
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _patternIndex = int64(_sound);
    var _existingPattern = struct_get_from_hash(_soundDict, _patternIndex);
    if (_existingPattern != undefined)
    {
        _existingPattern.__Update(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop);
    }
    else
    {
        struct_set_from_hash(_soundDict, _patternIndex, new __VinylClassPatternSound(_sound, _gainMin, _gainMax, _pitchMin, _pitchMax, _loop));
    }
}