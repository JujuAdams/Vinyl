/// @param voiceOrArray

function VinylGetAllPaused(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        if (array_length(_voiceOrArray) <= 0) return false;
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (not VinylGetAllPaused(_voiceOrArray[_i]))
            {
                return false;
            }
        
            ++_i;
        }
        
        return true;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplGetAllPaused();
    }
    else
    {
        return audio_is_paused(_voiceOrArray);
    }
}