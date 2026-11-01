/// Sets up Vinyl-specific properties for all sounds that use the given audio group.
/// 
/// N.B. Please note that use of `audio_group_set_gain()` is NOT recommended. GameMaker's native
///      audio groups should only be used to manage memory and NEVER to manage gain.
/// 
/// @param audioGroup
/// @param mixGroupIndex
/// @param [gain=1]
/// @param [otherData]

function VinylDefineSoundFromAudioGroup(_audioGroup, _mixGroupIndex, _gain = 1, _otherData = undefined)
{
    var _array = audio_group_get_assets(_audioGroup);
    if (is_array(_array) && (array_length(_array) > 0))
    {
        VinylDefineSound(_array, _mixGroupIndex, _gain, _otherData);
        return _array;
    }
    else
    {
        __VinylTrace($"Warning! No sound assets found for audio group \"{_audioGroup}\"");
        return [];
    }
}