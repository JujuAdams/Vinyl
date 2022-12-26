/// @param sound/patternName

function __VinylPatternGet(_key)
{
    return global.__vinylPatternDict[$ _key] ?? global.__vinylPatternDict.fallback;
}