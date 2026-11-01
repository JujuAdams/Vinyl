/// Sets up Vinyl-specific properties for all sounds that use the given asset tag.
/// 
/// @param assetTag
/// @param mixGroupIndex
/// @param [gain=1]
/// @param [otherData]

function VinylDefineSoundFromAssetTag(_assetTag, _mixGroupIndex, _gain = 1, _otherData = undefined)
{
    var _array = tag_get_asset_ids(_assetTag, asset_sound);
    if (is_array(_assetTag) && (array_length(_array) > 0))
    {
        VinylDefineSound(_array, _mixGroupIndex, _gain, _otherData);
        return _array;
    }
    else
    {
        __VinylTrace($"Warning! No sound assets found for tag \"{_assetTag}\"");
        return [];
    }
}