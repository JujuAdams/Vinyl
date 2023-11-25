// Feather disable all
/// @param sound/patternName

function __VinylPatternGet(_key)
{
    if (_key == undefined) return undefined;
    
    var _patternDict = __VinylDocument().__patternDict;
    
    //TODO - Optimise this lmao
    if (is_numeric(_key))
    {
        _key = audio_get_name(_key);
    }
    
    var _pattern = _patternDict[$ _key];
    
    if (_pattern == undefined)
    {
        _pattern = _patternDict[$ __VINYL_SOUND_DEFAULT_UUID];
    }
    
    return _pattern;
}
