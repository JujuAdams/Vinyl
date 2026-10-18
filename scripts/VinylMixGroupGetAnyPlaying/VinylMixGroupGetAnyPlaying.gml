/// @param mixGroupIndex

function VinylMixGroupGetAnyPlaying(_mixGroupIndex)
{
    with(__VinylGetMixGroup(_mixGroupIndex))
    {
        var _soundArray = __soundArray;
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            audio_is_playing(_soundArray[_i]);
            ++_i;
        }
    }
}