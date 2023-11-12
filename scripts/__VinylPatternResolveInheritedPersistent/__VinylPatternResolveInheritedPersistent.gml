// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedPersistent(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.persistentOption != "Unset"))
    {
        return {
            __option: _dataStruct.persistentOption,
            __value:  _dataStruct.persistent,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedPersistent(_parentStruct, undefined);
    }
    else
    {
        return {
            __option: "Unset",
            __value:  __VINYL_ASSET_NULL,
        };
    }
}