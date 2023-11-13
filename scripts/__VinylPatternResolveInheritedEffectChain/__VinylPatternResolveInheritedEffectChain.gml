// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedEffectChain(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.effectChainOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.effectChainOption,
            __value:  _dataStruct.effectChain,
        };
    }
    
    if (is_struct(_parentStruct))
    {
        return __VinylPatternResolveInheritedEffectChain(_parentStruct, undefined);
    }
    else
    {
        return {
            __option: __VINYL_OPTION_UNSET,
            __value:  __VINYL_ASSET_NULL,
        };
    }
}