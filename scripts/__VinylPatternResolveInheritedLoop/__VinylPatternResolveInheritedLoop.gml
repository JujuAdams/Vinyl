// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedLoop(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__loopOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.__loopOption,
            __value:  _dataStruct.__loop,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedLoop(_parentStruct, undefined);
    }
    else
    {
        return {
            __option: __VINYL_OPTION_UNSET,
            __value:  false,
        };
    }
}