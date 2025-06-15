// Feather disable all

/// Returns whether any voice exists for the given sound or pattern.
/// 
/// N.B. This function will always return `false` if an abstract pattern is targeted.
/// 
/// @param sound/pattern

function VinylPatternIsPlaying(_pattern)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    if (is_handle(_pattern))
    {
        return audio_is_playing(_pattern);
    }
    else if (is_string(_pattern))
    {
        var _patternStruct = _patternDict[$ _pattern];
        if (_patternStruct != undefined)
        {
            return _patternStruct.__IsSoundPlaying();
        }
        else
        {
            __VinylError("Pattern \"", _pattern, "\" not found");
        }
    }
    else
    {
        __VinylError("Datatype not supported (", typeof(_pattern), ")");
    }
}