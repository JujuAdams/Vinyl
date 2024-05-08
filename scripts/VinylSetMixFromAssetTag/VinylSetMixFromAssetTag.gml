// Feather disable all

/// @param assetTag
/// @param mixName

function VinylSetMixFromAssetTag(_assetTag, _mixName)
{
    static _soundDict = __VinylSystem().__soundDict;
    
    if (_mixName == VINYL_NO_MIX) _mixName = undefined;
    
    var _assetArray = tag_get_asset_ids(_assetTag, asset_sound);
    var _i = 0;
    repeat(array_length(_assetArray))
    {
        var _patternStruct = struct_get_from_hash(_soundDict, int64(_pattern));
        if (_patternStruct == undefined) __VinylError("Pattern \"", _pattern, "\" not found");
        _patternStruct.__SetMix(_mixName);
        ++_i;
    }
}