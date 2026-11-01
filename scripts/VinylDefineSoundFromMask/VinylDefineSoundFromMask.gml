/// Sets up Vinyl-specific properties for all sounds whose name matches the provided mask string.
/// 
/// @param mask
/// @param mixGroupIndex
/// @param [gain=1]
/// @param [otherData]

function VinylDefineSoundFromMask(_mask, _mixGroupIndex, _gain = 1, _otherData = undefined)
{
    var _array = asset_get_ids(asset_sound);
    var _i = array_length(_array)-1;
    repeat(array_length(_array))
    {
        var _name = audio_get_name(_array[_i]);
        if (not __VinylTestStringMask(_name, _mask))
        {
            array_delete(_array, _i, 1);
        }
        
        --_i;
    }
    
    if (array_length(_array) > 0)
    {
        VinylDefineSound(_array, _mixGroupIndex, _gain, _otherData);
        return _array;
    }
    else
    {
        __VinylTrace($"Warning! No sound assets found for mask \"{_mask}\"");
        return [];
    }
}