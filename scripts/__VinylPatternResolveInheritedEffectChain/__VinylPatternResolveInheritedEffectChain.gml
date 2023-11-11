// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedEffectChain(_dataStruct, _parentStruct)
{
    if (_dataStruct.effectChainOption != "Unset")
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
            __option: "Unset",
            __value:  __VINYL_ASSET_NULL,
        };
    }
}