/// Returns if there are any sounds playing that are associated with the mix group. This function
/// is relatively slow, especially as your game gets bigger, so use with care.
/// 
/// @param mixGroupIndex

function VinylMixGetAnyPlaying(_mixGroupIndex)
{
    with(__VinylGetMixGroup(_mixGroupIndex))
    {
        var _soundArray = __soundArray;
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            if (audio_is_playing(_soundArray[_i].__sound))
            {
                return true;
            }
            
            ++_i;
        }
    }
    
    return false;
}