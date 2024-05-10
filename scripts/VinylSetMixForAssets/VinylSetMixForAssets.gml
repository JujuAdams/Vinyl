// Feather disable all

/// @param mixName
/// @param sound/pattern/array
/// @param ...

function VinylSetMixForAssets()
{
    static _soundDict   = __VinylSystem().__soundDict;
    static _patternDict = __VinylSystem().__patternDict;
    
    var _mixName = argument[0];
    if (_mixName == VINYL_NO_MIX) _mixName = undefined;
    
    var _i = 1;
    repeat(argument_count-1)
    {
        var _patternArray = argument[_i];
        
        if (not is_array(_patternArray))
        {
            _patternArray = [_patternArray];
        }
        
        var _j = 0;
        repeat(array_length(_patternArray))
        {
            var _pattern = _patternArray[_j];
            
            if (is_handle(_pattern))
            {
                struct_get_from_hash(_soundDict, int64(_pattern)).__SetMix(_mixName);
            }
            else if (is_string(_pattern))
            {
                var _patternStruct = _patternDict[$ _pattern];
                if (_patternStruct == undefined)
                {
                    __VinylError("Pattern \"", _pattern, "\" not found");
                }
                else
                {
                    _patternStruct.__SetMix(_mixName);
                }
            }
            else if (_pattern == undefined)
            {
                //Ignore!
            }
            else
            {
                __VinylError("Datatype not supported (", typeof(_pattern), ")");
            }
            
            ++_j;
        }
        
        ++_i;
    }
}