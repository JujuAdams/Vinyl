/// @param sound/patternName

function __VinylPatternGet(_key)
{
    static _globalData = __VinylGlobalData();
    var _patternDict = _globalData.__patternDict; //Don't use a struct here because this struct can be recreated
    return _patternDict[$ _key] ?? _patternDict.fallback;
}