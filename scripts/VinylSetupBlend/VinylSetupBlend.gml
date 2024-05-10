// Feather disable all

/// @param patternName
/// @param soundArray
/// @param [loop=true]
/// @param [gain=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupBlend(_patternName, _soundArray, _loop = true, _gain = 1, _mix = VINYL_DEFAULT_MIX)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    if (_mix == VINYL_NO_MIX) _mix = undefined;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_soundArray, _loop, _gain, _mix);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternBlend(_patternName, _soundArray, _loop, _gain, _mix);
    }
}