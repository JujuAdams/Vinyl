/// @param playable
/// @param x
/// @param y
/// @param z
/// @param [loop=false]
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlayAt(_playable, _x, _y, _z, _loop = false, _gain = 1, _pitch = 1)
{
    static _mixGroupArray = __VinylSystem().__mixGroupArray;
    static _soundDefMap   = __VinylSystem().__soundDefMap;
    
    if (is_array(_playable))
    {
        var _voiceArray = array_create(array_length(_playable), -1);
        
        var _i = 0;
        repeat(array_length(_playable))
        {
            _voiceArray[@ _i] = VinylPlayAt(_playable[_i], _x, _y, _z, _loop, _gain, _pitch);
            ++_i;
        }
        
        return _voiceArray;
    }
    else if (is_struct(_playable))
    {
        return _playable.__ImplPlayAt(_x, _y, _z, _loop, _gain, _pitch);
    }
    else if (_playable != undefined)
    {
        var _soundDef = _soundDefMap[? _playable];
        if (_soundDef != undefined)
        {
            var _voice = audio_play_sound_at(_playable, _x, _y, _z,
                                             VINYL_FALLOFF_REF_DIST, VINYL_FALLOFF_MAX_DIST, VINYL_FALLOFF_FACTOR,
                                             _loop, 0,
                                             _gain*_soundDef.__gain*_mixGroupArray[_soundDef.__mixGroupIndex].__gain, 0, _pitch);
        }
        else
        {
            __VinylTrace($"Warning! Sound \"{audio_get_name(_playable)}\" has not been assigned to a mix group, sound playing on master bus");
            var _voice = audio_play_sound_at(_playable, _x, _y, _z,
                                             VINYL_FALLOFF_REF_DIST, VINYL_FALLOFF_MAX_DIST, VINYL_FALLOFF_FACTOR,
                                             _loop, 0,
                                             _gain, 0, _pitch);
        }
        
        return _voice;
    }
    
    return -1;
}