// Feather disable all

/// @param patternType

function __VinylPatternTypeGetMultiAsset(_patternType)
{
    switch(_patternType)
    {
        case __VINYL_PATTERN_TYPE_SOUND:
        case __VINYL_PATTERN_TYPE_BASIC:
            return false;
        break;
        
        case __VINYL_PATTERN_TYPE_SHUFFLE:
        case __VINYL_PATTERN_TYPE_QUEUE:
        case __VINYL_PATTERN_TYPE_MULTI:
            return true;
        break;
        
        default:
            __VinylError("Pattern type \"", _patternType, "\" not recognised");
        break;
    }
}