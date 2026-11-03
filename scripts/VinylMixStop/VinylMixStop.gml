/// Stops all sounds associated with the mix group. This function is relatively slow, especially
/// as your game gets bigger, so use with care.
/// 
/// @param mixGroupIndex

function VinylMixStop(_mixGroupIndex)
{
    with(__VinylGetMixGroup(_mixGroupIndex))
    {
        var _soundArray = __soundArray;
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            audio_stop_sound(_soundArray[_i].__sound);
            ++_i;
        }
    }
}