// Feather disable all

/// @param patternName
/// @param soundArray
/// @param [gain=1]

function VinylSetupBlend(_patternName, _soundArray, _gain = 1)
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