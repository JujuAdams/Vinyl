/// @param voiceOrArray

function VinylGetGain(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _result = array_create(array_length(_voiceOrArray), 0);
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            _result[@ _i] = VinylGetGain(_voiceOrArray[_i]);
            ++_i;
        }
        
        return _result;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplGetGain();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_sound_get_gain(_voiceOrArray);
    }
    
    return 0;
}