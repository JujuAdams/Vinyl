/// @param voiceOrArray

function VinylGetAllPlaying(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        if (array_length(_voiceOrArray) <= 0) return false;
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (not audio_is_playing(_voiceOrArray[_i]))
            {
                return false;
            }
        
            ++_i;
        }
        
        return true;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplGetAllPlaying();
    }
    else
    {
        return audio_is_playing(_voiceOrArray);
    }
}