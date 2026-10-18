/// @param mixGroupIndex

function VinylMixGroupStop(_mixGroupIndex)
{
    with(__VinylGetMixGroup(_mixGroupIndex))
    {
        var _soundArray = __soundArray;
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            audio_stop_sound(_soundArray[_i]);
            ++_i;
        }
    }
}