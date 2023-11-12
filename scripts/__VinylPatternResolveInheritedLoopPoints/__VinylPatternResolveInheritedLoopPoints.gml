// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedLoopPoints(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.loopOption != "Unset"))
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
            __option: "Unset",
            __value:  [0, 0],
        };
    }
}