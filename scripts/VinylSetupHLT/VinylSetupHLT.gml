// Feather disable all

/// @param patternName
/// @param [soundHead]
/// @param soundLoop
/// @param [soundTail]
/// @param [gain=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupHLT(_patternName, _soundHead = undefined, _soundLoop, _soundTail = undefined, _gain = 1, _mix = VINYL_DEFAULT_MIX)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_soundHead, _soundLoop, _soundTail, _gain);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternHLT(_patternName, _soundHead, _soundLoop, _soundTail, _gain);
    }
}