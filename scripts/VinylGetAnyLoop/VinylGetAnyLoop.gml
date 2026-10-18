/// @param voiceOrArray

function VinylGetAnyLoop(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (VinylGetAnyLoop(_voiceOrArray[_i]))
            {
                return true;
            }
            
            ++_i;
        }
        
        return false;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplGetAnyLoop();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_sound_get_loop(_voiceOrArray);
    }
    
    return false;
}