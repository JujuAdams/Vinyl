// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedStack(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__stackOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option:   _dataStruct.__stackOption,
            __value:    _dataStruct.__stackName,
            __priority: _dataStruct.__stackPriority,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedStack(_parentStruct, undefined);
    }
    else
    {
        return {
            __option:   __VINYL_OPTION_UNSET,
            __value:    __VINYL_ASSET_NULL,
            __priority: 0,
        };
    }
}