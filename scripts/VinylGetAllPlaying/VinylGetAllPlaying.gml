/// Return `true` if *all* voices in the given array are playing (including if they are paused).
/// If any one voice is not playing then this function will return `false`. If an empty array is
/// provided then this function will return `false`. If a voice is passed to this function directly
/// (not in an array) then this function will return if that particular voice is playing.
/// 
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