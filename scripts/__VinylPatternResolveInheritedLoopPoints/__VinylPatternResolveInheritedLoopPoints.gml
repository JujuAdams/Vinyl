// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedLoopPoints(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__loopPointsOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.__loopPointsOption,
            __value:  _dataStruct.__loopPoints,
        };
    }
    
    //No inheritance!
    
    return {
        __option: __VINYL_OPTION_UNSET,
        __value:  [0, 0],
    };
}