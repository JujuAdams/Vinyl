// Feather disable all

function __VinylPatternToName(_constructor)
{
    switch(_constructor)
    {
        case __VinylClassPatternRefNameMatch: case "__VinylClassPatternRefNameMatch": return "Name Match"; break;
        case __VinylClassPatternRefAssetTag:  case "__VinylClassPatternRefAssetTag":  return "Asset Tag";  break;
        case __VinylClassPatternBasic:        case "__VinylClassPatternBasic":        return "Basic";      break;
        case __VinylClassPatternShuffle:      case "__VinylClassPatternShuffle":      return "Shuffle";    break;
        case __VinylClassPatternQueue:        case "__VinylClassPatternQueue":        return "Queue";      break;
        case __VinylClassPatternMulti:        case "__VinylClassPatternMulti":        return "Multi";      break;
    }
    
    return "<Not a pattern>";
}