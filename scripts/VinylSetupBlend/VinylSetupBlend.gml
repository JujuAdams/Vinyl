// Feather disable all

/// @param patternName
/// @param soundArray
/// @param [gain=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupBlend(_patternName, _soundArray, _gain = 1, _mix = VINYL_DEFAULT_MIX)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__Update(_soundArray, _gain);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternBlend(_patternName, _soundArray, _gain);
    }
}