// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedTranspose(_dataStruct, _parentStruct)
{
    if (_dataStruct.transposeOption != "Unset")
    {
        return {
            __option:       _dataStruct.transposeOption,
            __knob:         _dataStruct.transposeKnob,
            __knobOverride: _dataStruct.transposeKnobOverride,
            __value:        _dataStruct.transpose,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedTranspose(_parentStruct, undefined);
    }
    else
    {
        return {
            __option:       "Unset",
            __knob:         __VINYL_ASSET_NULL,
            __knobOverride: false,
            __value:        [0, 0],
        };
    }
}