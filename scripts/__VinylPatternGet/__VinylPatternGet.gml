// Feather disable all
/// @param sound/patternName

function __VinylPatternGet(_key)
{
    static _globalData = __VinylGlobalData();
    if (_key == undefined) return undefined;
    
    //Fix weird issues with audio reference changes in GM2023.800
    if (is_numeric(_key)) _key = real(_key);
    
    var _patternDict = _globalData.__patternDict; //Don't use a static here because this struct can be recreated
    return _patternDict[$ _key] ?? _patternDict.fallback;
}
