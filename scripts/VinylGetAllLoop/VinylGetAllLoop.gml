/// @param voiceOrArray

function VinylGetAllLoop(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        if (array_length(_voiceOrArray) <= 0)
        {
            return false;
        }
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (not VinylGetAllLoop(_voiceOrArray[_i]))
            {
                return false;
            }
            
            ++_i;
        }
        
        return true;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetAllLoop();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_sound_get_loop(_voiceOrArray);
    }
    
    return false;
}