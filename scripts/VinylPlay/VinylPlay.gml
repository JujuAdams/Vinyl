// Feather disable all

/// @param target
/// @param [loop]
/// @param [gain=1]
/// @param [loop=1]

function VinylPlay(_target, _loop = undefined, _gain = 1, _pitch = 1)
{
    static _genData = __VinylGenPlay();
    
    var _function = struct_get_from_hash(_genData, int64(_target));
    if (_function == undefined)
    {
        if (audio_exists(_target))
        {
            return audio_play_sound(_target, 0, _loop, _gain, 0, _pitch);
        }
        else
        {
            if (__VINYL_RUNNING_FROM_IDE)
            {
                __VinylWarning("Could not find data for trigger ", _target);
                return audio_play_sound(VinylFallbackSound, 0, false, _gain, 0, _pitch);
            }
            else
            {
                return -1;
            }
        }
    }
    else
    {
        return _function(_loop, _gain, _pitch);
    }
}