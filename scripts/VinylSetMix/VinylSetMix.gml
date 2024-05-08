// Feather disable all

/// @param mixName
/// @param sound/pattern
/// @param ...

function VinylSetMix()
{
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    
    var _mixName = argument[0];
    if (_mixName == VINYL_NO_MIX) _mixName = undefined;
    
    var _i = 1;
    repeat(argument_count-1)
    {
        var _pattern = argument[_i];
        
        if (is_handle(_pattern))
        {
            var _patternStruct = struct_get_from_hash(_soundDict, int64(_pattern));
            if (_patternStruct == undefined) __VinylError("Pattern \"", _pattern, "\" not found");
        }
        else if (is_string(_pattern))
        {
            var _patternStruct = _patternDict[$ _pattern];
            if (_patternStruct == undefined) __VinylError("Pattern \"", _pattern, "\" not found");
        }
        else
        {
            __VinylError("Datatype not supported (", typeof(_pattern), ")");
        }
        
        _patternStruct.__SetMix(_mixName);
        
        ++_i;
    }
}