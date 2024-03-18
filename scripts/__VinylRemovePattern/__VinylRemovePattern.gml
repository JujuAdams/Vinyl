// Feather disable all

/// @param patternName

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("__VinylRemovePattern", __VinylRemovePattern);
function __VinylRemovePattern(_patternName)
{
    static _genPlayData = __VinylGenPlay();
    static _genNameData = __VinylGenPatternNames();
    
    if (not VINYL_LIVE_EDIT) return;
    
    var _patternIndex = _genNameData[$ _patternName];
    if (_patternIndex == undefined)
    {
        __VinylWarning("Target pattern name \"", _patternName, "\" not recognised");
        return;
    }
    
    struct_set_from_hash(_genPlayData, int64(_patternIndex), undefined);
    __VinylWarning("Pattern \"", _patternName, "\" removed");
}