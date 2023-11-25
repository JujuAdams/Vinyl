// Feather disable all

/// @param typeString
/// @param patternName

function __VinylConvertPatternNameToConstructor(_type, _patternName)
{
    if (_type == __VINYL_PATTERN_TYPE_FALLBACK)
    {
        return __VinylClassPatternFallback;
    }
    else if (_type == __VINYL_PATTERN_TYPE_SOUND)
    {
        return __VinylClassPatternSound;
    }
    else if (_type == __VINYL_PATTERN_TYPE_BASIC)
    {
        return __VinylClassPatternBasic;
    }
    else if (_type == __VINYL_PATTERN_TYPE_SHUFFLE)
    {
        return __VinylClassPatternShuffle;
    }
    else if (_type == __VINYL_PATTERN_TYPE_QUEUE)
    {
        return __VinylClassPatternQueue;
    }
    else if (_type == __VINYL_PATTERN_TYPE_MULTI)
    {
        return __VinylClassPatternMulti;
    }
    else if (_type == __VINYL_PATTERN_TYPE_REF_NAME_MATCH)
    {
        return __VinylClassPatternRefNameMatch;
    }
    else if (_type == __VINYL_PATTERN_TYPE_REF_ASSET_TAG)
    {
        return __VinylClassPatternRefAssetTag;
    }
    else
    {
        __VinylError("Pattern type \"", _type, "\" for pattern UUID \"", _patternName, "\" not recognised");
    }
}
