// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedBPM(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.bpmOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.bpmOption,
            __value:  _dataStruct.bpm,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedTranspose(_parentStruct, undefined);
    }
    else
    {
        return {
            __option: __VINYL_OPTION_UNSET,
            __value:  120,
        };
    }
}