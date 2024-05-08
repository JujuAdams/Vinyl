// Feather disable all

/// @param patternName
/// @param soundArray
/// @param gain
/// @param pitch

function VinylSetupShuffle(_patternName, _soundArray, _gain, _pitch)
{
    static _patternDict = __VinylSystem().__patternDict; 
    
    __VINYL_HANDLE_GAINS
    __VINYL_HANDLE_PITCHES
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__Update(_soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternShuffle(_patternName, _soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax);
    }
}