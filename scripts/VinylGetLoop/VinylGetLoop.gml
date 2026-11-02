/// Returns `true` if *any* voices in the given array are looping. Only if all voices are not
/// looping will this function then return `false`. If an empty array is provided then this
/// function will return `false`. If a voice is passed to this function directly (not in an array)
/// then this function will return if that particular voice is looping.
/// 
/// @param voiceOrArray

function VinylGetLoop(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (VinylGetLoop(_voiceOrArray[_i]))
            {
                return true;
            }
            
            ++_i;
        }
        
        return false;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetLoop();
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            return audio_sound_get_loop(_voiceOrArray);
        }
    }
    
    return false;
}