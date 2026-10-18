/// @param voiceOrArray

function VinylGetAnyPlaying(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (VinylGetAnyPlaying(_voiceOrArray[_i]))
            {
                return true;
            }
            
            ++_i;
        }
        
        return false;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplGetAnyPlaying();
    }
    else
    {
        return audio_is_playing(_voiceOrArray);
    }
}