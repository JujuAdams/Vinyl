// Feather disable all

/// @param patternName

function VinylUnloadExternal(_patternName)
{
    static _patternMap = __VinylSystem().__patternMap;
    
    var _existingPattern = _patternMap[? _patternName];
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