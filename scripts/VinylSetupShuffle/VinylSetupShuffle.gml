// Feather disable all

/// @param patternName
/// @param soundArray
/// @param [gain=1]
/// @param [pitch=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupShuffle(_patternName, _soundArray, _gain = undefined, _pitch = undefined, _mix = VINYL_DEFAULT_MIX)
{
    static _patternDict = __VinylSystem().__patternDict; 
    
    __VINYL_HANDLE_GAINS
    __VINYL_HANDLE_PITCHES
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternShuffle(_patternName, _soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix);
    }
}