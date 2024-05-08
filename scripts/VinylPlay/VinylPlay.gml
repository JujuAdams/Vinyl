// Feather disable all

/// @param sound/pattern
/// @param [loop]
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlay(_pattern, _loop = undefined, _gain = 1, _pitch = 1)
{
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    
    if (is_handle(_pattern))
    {
        return struct_get_from_hash(_soundDict, int64(_pattern)).__Play(_loop, _gain, _pitch);
    }
    else if (is_string(_pattern))
    {
        var _patternStruct = _patternDict[$ _pattern];
        if (_patternStruct != undefined)
        {
            return _patternStruct.__Play(_loop, _gain, _pitch);
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