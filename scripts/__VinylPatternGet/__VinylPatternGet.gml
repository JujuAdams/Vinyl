// Feather disable all
/// @param sound/patternName

function __VinylPatternGet(_key)
{
    if (_key == undefined) return undefined;
    
    var _patternDict = __VinylDocument().__patternDict;
    
    var _pattern = _patternDict[$ _key];
    if (_pattern == undefined)
    {
        _pattern = _patternDict[$ __VINYL_FALLBACK_NAME];
    }
    
    return _pattern;
}
