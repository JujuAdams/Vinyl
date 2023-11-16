// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedTranspose(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__transposeOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option:       _dataStruct.__transposeOption,
            __knob:         _dataStruct.__transposeKnob,
            __knobOverride: _dataStruct.__transposeKnobOverride,
            __value:        _dataStruct.__transpose,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedTranspose(_parentStruct, undefined);
    }
    else
    {
        return {
            __option:       __VINYL_OPTION_UNSET,
            __knob:         __VINYL_ASSET_NULL,
            __knobOverride: false,
            __value:        [0, 0],
        };
    }
}