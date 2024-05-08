// Feather disable all

/// @param mixName
/// @param assetTag

function VinylSetMixForAssetTag(_mixName, _assetTag)
{
    static _soundDict = __VinylSystem().__soundDict;
    
    if (_mixName == VINYL_NO_MIX) _mixName = undefined;
    
    var _assetArray = tag_get_asset_ids(_assetTag, asset_sound);
    var _i = 0;
    repeat(array_length(_assetArray))
    {
        struct_get_from_hash(_soundDict, int64(_assetArray[_i])).__SetMix(_mixName);
        ++_i;
    }
}