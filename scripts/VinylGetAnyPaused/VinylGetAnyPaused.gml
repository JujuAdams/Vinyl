/// Returns `true` if *any* voices in the given array are paused. Only if all voices are not
/// paused will then this function return `false`. If an empty array is provided then this
/// function will return `false`. If a voice is passed to this function directly (not in an array)
/// then this function will return if that particular voice is paused.
/// 
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