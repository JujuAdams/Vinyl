// Feather disable all

/// @param sound

function __VinylEnsurePatternSound(_sound)
{
    static _soundMap = __VinylSystem().__soundMap;
    
    var _pattern = _soundMap[? int64(_sound)];
    if (_pattern == undefined)
    {
        _pattern = new __VinylClassPatternSound(_sound, 1, 1, undefined, (VINYL_DEFAULT_MIX == VINYL_NO_MIX)? undefined : VINYL_DEFAULT_MIX, undefined, undefined, undefined, undefined, undefined);
        _soundMap[? int64(_sound)] = _pattern;
    }
    
    return _pattern;
}