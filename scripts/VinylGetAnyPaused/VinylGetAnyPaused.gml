/// @param voiceOrArray

function VinylGetAnyPaused(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (VinylGetAnyPaused(_voiceOrArray[_i]))
            {
                return true;
            }
            
            ++_i;
        }
        
        return false;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetAnyPaused();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_is_paused(_voiceOrArray);
    }
    
    return false;
}