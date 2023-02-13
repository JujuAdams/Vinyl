/// @param patternName

function __VinylPatternGetEffectChain(_patternName)
{
    var _pattern = __VinylPatternGet(_patternName);
    return is_struct(_pattern)? _pattern.__effectChainName : "main";
}