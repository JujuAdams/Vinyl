// Feather disable all

/// @param sound
/// @param [gain=1]
/// @param [pitch=1]
/// @param [loop=false]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupSound(_sound, _gain = undefined, _pitch = undefined, _loop = false, _mix = VINYL_DEFAULT_MIX)
{
    static _soundDict = __VinylSystem().__soundDict;
    
    __VINYL_HANDLE_GAINS
    __VINYL_HANDLE_PITCHES
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _patternIndex = int64(_sound);
    var _existingPattern = struct_get_from_hash(_soundDict, _patternIndex);
    if (_existingPattern != undefined)
    {
        _existingPattern.__Update(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix);
    }
    else
    {
        struct_set_from_hash(_soundDict, _patternIndex, new __VinylClassPatternSound(_sound, _gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix));
    }
}