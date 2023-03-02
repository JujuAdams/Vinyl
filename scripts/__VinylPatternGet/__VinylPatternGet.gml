/// @param sound/patternName

function __VinylPatternGet(_key)
{
    static _globalData = __VinylGlobalData();
    var _patternDict = _globalData.__patternDict; //Don't use a struct here because this struct can be recreated
    
    var _pattern = _patternDict[$ _key];
    if (_pattern != undefined)
    {
        return _pattern;
    }
    else if (is_numeric(_key))
    {
        return _patternDict.fallback;
    }
    
    return undefined;
}