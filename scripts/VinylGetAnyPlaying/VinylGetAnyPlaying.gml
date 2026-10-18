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
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplGetAnyPlaying();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_is_playing(_voiceOrArray);
    }
    
    return false;
}