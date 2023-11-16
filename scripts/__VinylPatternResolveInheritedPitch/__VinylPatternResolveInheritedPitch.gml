// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedPitch(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__pitchOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option:       _dataStruct.__pitchOption,
            __knob:         _dataStruct.__pitchKnob,
            __knobOverride: _dataStruct.__pitchKnobOverride,
            __value:        _dataStruct.__pitch,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedPitch(_parentStruct, undefined);
    }
    else
    {
        return {
            __option:       __VINYL_OPTION_UNSET,
            __knob:         __VINYL_ASSET_NULL,
            __knobOverride: false,
            __value:        [1, 1],
        };
    }
}