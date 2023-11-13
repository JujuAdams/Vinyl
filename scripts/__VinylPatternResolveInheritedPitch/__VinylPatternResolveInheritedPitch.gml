// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedPitch(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.pitchOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option:       _dataStruct.pitchOption,
            __knob:         _dataStruct.pitchKnob,
            __knobOverride: _dataStruct.pitchKnobOverride,
            __value:        _dataStruct.pitch,
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