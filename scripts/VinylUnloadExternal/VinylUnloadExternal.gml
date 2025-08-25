// Feather disable all

/// @param patternName

function VinylUnloadExternal(_patternName)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    var _existingPattern = _patternDict[$ _patternName];
    if (is_struct(_existingPattern))
    {
        if (is_instanceof(_existingPattern, __VinylClassPatternExternalWAV)
        ||  is_instanceof(_existingPattern, __VinylClassPatternExternalOGG))
        {
            _existingPattern.__Free();
        }
        else
        {
            __VinylTrace("Warning! Cannot unload pattern \"", _patternName, "\", it is not an external pattern");
        }
    }
}