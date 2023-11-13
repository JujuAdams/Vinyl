// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedLoop(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.loopOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.loopOption,
            __value:  _dataStruct.loop,
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