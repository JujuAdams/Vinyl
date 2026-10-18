/// @param voiceOrArray

function VinylGetAllPlaying(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        if (array_length(_voiceOrArray) > 0)
        {
            var _i = 0;
            repeat(array_length(_voiceOrArray))
            {
                if (not VinylGetAllPlaying(_voiceOrArray[_i]))
                {
                    return false;
                }
                
                ++_i;
            }
            
            return true;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetAllPlaying();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_is_playing(_voiceOrArray);
    }
    
    return false;
}