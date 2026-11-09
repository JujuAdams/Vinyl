/// Returns `true` if *any* voices in the given array are playing (including if they are paused).
/// Only if all voices are not playing will then this function return `false`. If an empty array
/// is provided then this function will return `false`. If a voice is passed to this function
/// directly (not in an array) then this function will return if that particular voice is playing.
/// 
/// @param voiceOrArray

function VinylGetPlaying(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (VinylGetPlaying(_voiceOrArray[_i]))
            {
                return true;
            }
            
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetPlaying();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_is_playing(_voiceOrArray);
    }
    
    return false;
}