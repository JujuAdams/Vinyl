/// @param voiceOrArray

function VinylGetPitch(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _result = array_create(array_length(_voiceOrArray), 1);
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            _result[@ _i] = VinylGetPitch(_voiceOrArray[_i]);
            ++_i;
        }
        
        return _result;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplGetPitch();
    }
    else
    {
        return audio_sound_get_pitch(_voiceOrArray);
    }
}