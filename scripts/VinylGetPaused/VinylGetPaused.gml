/// Returns `true` if *all* voices in the given array are paused. If any one voice is not paused
/// then this function will return `false`. If an empty array is provided then this function will
/// return `false`. If a voice is passed to this function directly (not in an array) then this
/// function will return if that particular voice is paused.
/// 
/// @param voiceOrArray

function VinylGetPaused(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        if (array_length(_voiceOrArray) <= 0) return false;
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (not VinylGetPaused(_voiceOrArray[_i]))
            {
                return false;
            }
        
            ++_i;
        }
        
        return true;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetPaused();
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            return audio_is_paused(_voiceOrArray);
        }
    }
    
    return false;
}