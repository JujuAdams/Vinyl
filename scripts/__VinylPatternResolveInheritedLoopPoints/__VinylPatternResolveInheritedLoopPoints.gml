// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedLoopPoints(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.loopOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.loopOption,
            __value:  _dataStruct.loopPoints,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedLoopPoints(_parentStruct, undefined);
    }
    else
    {
        return {
            __option: __VINYL_OPTION_UNSET,
            __value:  [0, 0],
        };
    }
}