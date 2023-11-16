// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedGain(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__gainOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option:       _dataStruct.__gainOption,
            __knob:         _dataStruct.__gainKnob,
            __knobOverride: _dataStruct.__gainKnobOverride,
            __value:        _dataStruct.__gain,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedGain(_parentStruct, undefined);
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