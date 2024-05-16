// Feather disable all

/// Returns the metadata associated with the sound or pattern, as set up by Vinyl's config JSON or
/// a call to VinylSetup*().
/// 
/// @param sound/pattern

function VinylGetMetadata(_pattern)
{
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    
    if (audio_exists(_pattern))
    {
        return struct_get_from_hash(_soundDict, int64(_pattern)).__metadata;
    }
    else if (is_string(_pattern))
    {
        var _patternStruct = _patternDict[$ _pattern];
        if (_patternStruct != undefined)
        {
            return _patternStruct.__metadata;
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