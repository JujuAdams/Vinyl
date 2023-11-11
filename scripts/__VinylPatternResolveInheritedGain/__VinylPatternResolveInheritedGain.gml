// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedGain(_dataStruct, _parentStruct)
{
    if (_dataStruct.gainOption != "Unset")
    {
        return {
            __option:       _dataStruct.gainOption,
            __knob:         _dataStruct.gainKnob,
            __knobOverride: _dataStruct.gainKnobOverride,
            __value:        _dataStruct.gain,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedGain(_parentStruct, undefined);
    }
    else
    {
        return {
            __option:       "Unset",
            __knob:         __VINYL_ASSET_NULL,
            __knobOverride: false,
            __value:        [1, 1],
        };
    }
}