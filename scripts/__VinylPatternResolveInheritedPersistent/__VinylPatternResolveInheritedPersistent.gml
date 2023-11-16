// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedPersistent(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__persistentOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.__persistentOption,
            __value:  _dataStruct.__persistent,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedPersistent(_parentStruct, undefined);
    }
    else
    {
        return {
            __option: __VINYL_OPTION_UNSET,
            __value:  __VINYL_ASSET_NULL,
        };
    }
}