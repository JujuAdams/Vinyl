/// @param mixGroupIndex

function VinylMixGroupPause(_mixGroupIndex)
{
    with(__VinylGetMixGroup(_mixGroupIndex))
    {
        var _soundArray = __soundArray;
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            audio_pause_sound(_soundArray[_i]);
            ++_i;
        }
    }
}