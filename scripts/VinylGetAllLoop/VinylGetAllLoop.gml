/// Returns `true` if *all* voices in the given array are looping. If any one voice is not looping
/// then this function will return `false`. If an empty array is provided then this function will
/// return `false`. If a voice is passed to this function directly (not in an array) then this
/// function will return if that particular voice is looping.
/// 
/// @param voiceOrArray

function VinylGetAllLoop(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        if (array_length(_voiceOrArray) <= 0)
        {
            return false;
        }
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (not VinylGetAllLoop(_voiceOrArray[_i]))
            {
                return false;
            }
            
            ++_i;
        }
        
        return true;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetAllLoop();
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