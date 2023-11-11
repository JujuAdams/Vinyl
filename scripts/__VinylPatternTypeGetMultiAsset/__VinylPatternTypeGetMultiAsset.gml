// Feather disable all

/// @param patternType

function __VinylPatternTypeGetMultiAsset(_patternType)
{
    switch(_patternType)
    {
        case "Asset":
        case "Basic":
            return false;
        break;
        
        case "Shuffle":
        case "Queue":
        case "Multi":
            return true;
        break;
        
        default:
            __VinylError("Pattern type \"", _patternType, "\" not recognised");
        break;
    }
}