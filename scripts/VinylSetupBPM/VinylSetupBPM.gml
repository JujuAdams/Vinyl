// Feather disable all

/// @param pattern
/// @param bpm

function VinylSetupBPM(_pattern, _bpm)
{
    static _system     = __VinylSystem();
    static _patternMap = _system.__patternMap;
    
    if (is_handle(_pattern))
    {
        __VinylEnsurePatternSound(_pattern).__UpdateBPM(_bpm);
    }
    else if (is_string(_pattern))
    {
        var _patternStruct = _patternMap[? _pattern];
        if (_patternStruct == undefined)
        {
            __VinylError("Pattern \"", _pattern, "\" not found");
        }
        else
        {
            _patternStruct.__UpdateBPM(_bpm);
        }
    }
    else
    {
        __VinylError("Datatype not supported (", typeof(_pattern), ")");
    }
    
    if (VINYL_LIVE_EDIT && (not _system.__importingJSON))
    {
        __VinylResolveChanges(false);
    }
}