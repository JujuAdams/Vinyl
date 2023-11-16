// Feather disable all

/// @param dataStruct
/// @param parentStruct

function __VinylPatternResolveInheritedEffectChain(_dataStruct, _parentStruct)
{
    if (is_struct(_dataStruct) && (_dataStruct.__effectChainOption != __VINYL_OPTION_UNSET))
    {
        return {
            __option: _dataStruct.__effectChainOption,
            __value:  _dataStruct.__effectChainName,
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