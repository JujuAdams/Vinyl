// Feather disable all

/// Returns whether any voice exists that is playing the given sound, or playing any sound from a
/// pattern. If a pattern contains multiple sounds then this function will return `true` if a voice
/// exists that is playing any of those sounds.
/// 
/// N.B. This function will always return `false` if an abstract pattern is targeted.
/// 
/// @param sound/pattern

function VinylPatternIsPlaying(_pattern)
{
    static _patternMap = __VinylSystem().__patternMap;
    
    if (is_handle(_pattern))
    {
        return audio_is_playing(_pattern);
    }
    else if (is_string(_pattern))
    {
        var _patternStruct = _patternMap[? _pattern];
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